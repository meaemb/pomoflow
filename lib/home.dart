import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'components/theme_button.dart';
import 'components/color_button.dart';
import 'components/audio_player_controls.dart';
import 'components/login.dart';
import 'components/message_list.dart';
import 'constants.dart';
import 'components/tip_card.dart';
import 'components/category_card.dart';
import 'components/review_card.dart';
import 'models/tip.dart';
import 'models/category.dart';
import 'models/review.dart';
import 'models/saved_session_manager.dart';
import 'models/session_manager.dart';
import 'models/auth.dart';
import 'models/user.dart';
import 'screens/explore_page.dart';
import 'screens/my_sessions_page.dart';
import 'screens/account_page.dart';
import 'services/background_manager.dart';
import 'providers.dart';
import 'models/main_screen_model.dart';

class Home extends ConsumerStatefulWidget {
  final Auth auth;
  final User user;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;
  final ColorSelection colorSelected;
  final SavedSessionManager sessionManager;
  final SessionManager sessionManagerOrders;
  final int initialTab;

  const Home({
    super.key,
    required this.auth,
    required this.user,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.sessionManager,
    required this.sessionManagerOrders,
    required this.initialTab,
  });

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final mainScreenModel = ref.read(mainScreenModelProvider);
    final savedIndex = await mainScreenModel.loadCurrentIndex();

    setState(() {
      selectedIndex = widget.initialTab != 0 ? widget.initialTab : savedIndex;
    });
  }

  Future<void> _saveSelectedTab(int index) async {
    final mainScreenModel = ref.read(mainScreenModelProvider);
    await mainScreenModel.saveCurrentIndex(index);
  }

  Future<void> _saveSavedTipsToPrefs() async {
    final prefs = ref.read(sharedPrefProvider);
    const savedTipsKey = 'savedTips';
    final savedTipIds = ref.read(tipProvider).savedTipIds;
    await prefs.setStringList(savedTipsKey, savedTipIds);
    print('💾 Сохранено избранное: $savedTipIds');
  }

  void toggleSaved(Tip tip) {
    final notifier = ref.read(tipProvider.notifier);
    notifier.toggleSavedTip(tip.id);
    _saveSavedTipsToPrefs();
  }

  bool isSaved(Tip tip) {
    return ref.read(tipProvider).savedTipIds.contains(tip.id);
  }

  final List<String> labels = ['Explore', 'Sessions', 'Account', 'Chat'];
  final List<IconData> icons = [Icons.explore, Icons.history, Icons.account_circle, Icons.chat];
  final List<IconData> selectedIcons = [Icons.explore, Icons.history, Icons.account_circle, Icons.chat];

  Widget _buildPage(int index) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: IndexedStack(
        key: ValueKey(selectedIndex),
        index: selectedIndex,
        children: [
          ExplorePage(
            key: ValueKey('explore_$selectedIndex'),
            onToggleSave: toggleSaved,
            isSaved: isSaved,
            sessionManager: widget.sessionManager,
            sessionManagerOrders: widget.sessionManagerOrders,
          ),
          const MySessionsPage(),
          const AccountPage(),
          Consumer(
            builder: (context, ref, child) {
              final userDao = ref.watch(userDaoProvider);
              if (userDao.isLoggedIn()) {
                return const MessageList();
              } else {
                return const Login();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool useRail = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'PomoFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          AudioPlayerControls(manager: BackgroundManager()),
          const SizedBox(width: 8),
          ThemeButton(changeThemeMode: widget.changeTheme),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
          // Кнопка Logout (показывается только если залогинен)
          Consumer(
            builder: (context, ref, child) {
              final userDao = ref.watch(userDaoProvider);
              if (userDao.isLoggedIn()) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    userDao.logout();
                  },
                  tooltip: 'Logout',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: useRail
          ? Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
                _saveSelectedTab(index);
              });
              context.go('/$index');
            },
            labelType: NavigationRailLabelType.selected,
            destinations: List.generate(labels.length, (index) {
              return NavigationRailDestination(
                icon: Icon(icons[index]),
                selectedIcon: Icon(selectedIcons[index]),
                label: Text(labels[index]),
              );
            }),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildPage(selectedIndex),
          ),
        ],
      )
          : Column(
        children: [
          Expanded(
            child: _buildPage(selectedIndex),
          ),
          NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
                _saveSelectedTab(index);
              });
              context.go('/$index');
            },
            destinations: List.generate(labels.length, (index) {
              return NavigationDestination(
                icon: Icon(icons[index]),
                selectedIcon: Icon(selectedIcons[index]),
                label: labels[index],
              );
            }),
          ),
        ],
      ),
    );
  }
}