import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/mock_pomoflow_service.dart';
import '../components/tip_section.dart';
import '../components/category_section.dart';
import '../components/review_section.dart';
import '../models/tip.dart';
import '../models/saved_session_manager.dart';
import '../models/session_manager.dart';
import '../models/quote.dart';
import '../providers.dart';
import '../network/tip_api_service.dart';
import 'focus_page.dart';
import 'sounds_page.dart';
import 'saved_tips_page.dart';
import '../utils/route_animations.dart';
import '../components/lottie_loading.dart';

class ExplorePage extends ConsumerStatefulWidget {
  final void Function(Tip) onToggleSave;
  final bool Function(Tip) isSaved;
  final SavedSessionManager sessionManager;
  final SessionManager sessionManagerOrders;

  const ExplorePage({
    super.key,
    required this.onToggleSave,
    required this.isSaved,
    required this.sessionManager,
    required this.sessionManagerOrders,
  });

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> with SingleTickerProviderStateMixin {
  final MockPomoFlowService mockService = MockPomoFlowService();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  Quote _currentQuote = Quote.getLocalQuote();
  bool _isLoadingQuote = true;

  final TextEditingController _searchController = TextEditingController();
  List<String> _previousSearches = [];
  static const String _prefSearchKey = 'previousTipSearches';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    _loadPreviousSearches();
    _loadQuoteFromApi();
  }

  Future<void> _loadQuoteFromApi() async {
    setState(() => _isLoadingQuote = true);
    try {
      final tipApi = TipApiService();
      final quoteText = await tipApi.fetchRandomTip();
      if (quoteText.isNotEmpty) {
        setState(() {
          _currentQuote = Quote(text: quoteText, author: 'Advice API');
          _isLoadingQuote = false;
        });
      } else {
        setState(() {
          _currentQuote = Quote.getLocalQuote();
          _isLoadingQuote = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentQuote = Quote.getLocalQuote();
        _isLoadingQuote = false;
      });
    }
  }

  Future<void> _loadPreviousSearches() async {
    final prefs = ref.read(sharedPrefProvider);
    final searches = prefs.getStringList(_prefSearchKey);
    if (searches != null) {
      setState(() => _previousSearches = searches);
    }
  }

  Future<void> _savePreviousSearches() async {
    final prefs = ref.read(sharedPrefProvider);
    await prefs.setStringList(_prefSearchKey, _previousSearches);
  }

  void _addToPreviousSearches(String query) {
    if (query.isEmpty) return;
    setState(() {
      if (!_previousSearches.contains(query)) {
        _previousSearches.insert(0, query);
        if (_previousSearches.length > 10) {
          _previousSearches = _previousSearches.take(10).toList();
        }
      }
      _savePreviousSearches();
    });
  }

  void _removeFromPreviousSearches(String query) {
    setState(() {
      _previousSearches.remove(query);
      _savePreviousSearches();
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      ref.read(tipProvider.notifier).clearSearch();
      setState(() {});
      return;
    }
    _addToPreviousSearches(query);
    ref.read(tipProvider.notifier).searchTips(query);
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(tipProvider.notifier).clearSearch();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // ИСПРАВЛЕНО: используем цвет из темы вместо серого
              Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteCard(Quote quote) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Quote of the Day', style: TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.grey[500])),
          const SizedBox(height: 16),
          Text('"${quote.text}"', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.4, color: textColor), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text('— ${quote.author}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search productivity tips...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch) : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          const SizedBox(width: 8),
          StatefulBuilder(
            builder: (context, setStatePopup) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.history),
                tooltip: 'Search history',
                onSelected: (value) {
                  _searchController.text = value;
                  _performSearch(value);
                },
                itemBuilder: (context) {
                  return _previousSearches.map((search) {
                    return PopupMenuItem(
                      value: search,
                      child: Row(
                        children: [
                          Expanded(child: Text(search)),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              setState(() {
                                _previousSearches.remove(search);
                                _savePreviousSearches();
                              });
                              setStatePopup(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadSavedTipsFromPrefs() async {
    final prefs = ref.read(sharedPrefProvider);
    const savedTipsKey = 'savedTips';
    if (prefs.containsKey(savedTipsKey)) {
      final savedTipIds = prefs.getStringList(savedTipsKey);
      if (savedTipIds != null && savedTipIds.isNotEmpty) {
        ref.read(tipProvider.notifier).loadSavedTips(savedTipIds);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipState = ref.watch(tipProvider);
    final displayTips = tipState.filteredTips;
    final isSearchActive = tipState.searchQuery.isNotEmpty;

    return FutureBuilder<ExploreData>(
      future: mockService.getExploreData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LottieLoading();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error loading data'));
        }

        final data = snapshot.data!;
        final allTips = data.tips;
        final categories = data.categories;
        final reviews = data.reviews;

        if (tipState.allTips.isEmpty && allTips.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(tipProvider.notifier).loadTips(allTips);
            _loadSavedTipsFromPrefs();
          });
        }

        final tipsToShow = isSearchActive ? displayTips : allTips;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            children: [
              if (_isLoadingQuote)
                Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20), child: const LottieLoading())
              else
                _buildQuoteCard(_currentQuote),

              // ===== ТРИ КНОПКИ: ТАЙМЕР, ЗВУКИ, СОХРАНЁННЫЕ =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFeatureCard(
                      icon: Icons.timer_outlined,
                      title: 'Focus Timer',
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimations.slideTransition(const FocusPage()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.headphones,
                      title: 'Sounds',
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimations.fadeTransition(const SoundsPage()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.favorite,
                      title: 'Saved Tips',
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimations.scaleTransition(const SavedTipsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // =============================================

              _buildSearchBar(),
              if (isSearchActive && displayTips.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Search results (${displayTips.length})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              TipSection(
                tips: tipsToShow,
                onToggleSave: widget.onToggleSave,
                isSaved: widget.isSaved,
                sessionManager: widget.sessionManager,
                sessionManagerOrders: widget.sessionManagerOrders,
              ),
              CategorySection(categories: categories),
              ReviewSection(reviews: reviews),
            ],
          ),
        );
      },
    );
  }
}