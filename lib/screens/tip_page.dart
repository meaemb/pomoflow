import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tip.dart';
import '../models/tip_step.dart';
import '../models/saved_session_manager.dart';
import '../models/session_manager.dart';
import '../components/step_item.dart';
import 'checkout_page.dart';
import '../components/step_details.dart';
import '../components/feedback_section.dart';

class TipPage extends StatefulWidget {
  final Tip tip;
  final SavedSessionManager sessionManager;
  final SessionManager sessionManagerOrders;

  const TipPage({
    super.key,
    required this.tip,
    required this.sessionManager,
    required this.sessionManagerOrders,
  });

  @override
  State<TipPage> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> with SingleTickerProviderStateMixin {
  static const desktopThreshold = 700;
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const double drawerWidth = 375.0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
        ? screenWidth * largeScreenPercentage
        : screenWidth)
        .clamp(0.0, maxWidth);
  }

  int calculateColumnCount(double screenWidth) {
    return screenWidth > desktopThreshold ? 2 : 1;
  }

  void _showStepBottomSheet(TipStep step) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (context) => StepDetails(
        step: step,
        tipName: widget.tip.name,
        sessionManager: widget.sessionManager,
        quantityUpdated: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildStepItem(int index) {
    final step = widget.tip.steps[index];
    return InkWell(
      onTap: () => _showStepBottomSheet(step),
      child: StepItem(
        step: step,
        index: index,
        sessionManager: widget.sessionManager,
        quantityUpdated: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStepsGrid(int columns) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) => _buildStepItem(index),
      itemCount: widget.tip.steps.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  SliverToBoxAdapter _buildStepsSection(String title) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(title),
            _buildStepsGrid(columns),
          ],
        ),
      ),
    );
  }

  // ✅ ИСПРАВЛЕННЫЙ SliverAppBar (с NetworkImage)
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 64.0,
            ),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: NetworkImage(widget.tip.imageUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        print('Ошибка загрузки картинки: $exception');
                      },
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.school, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoSection() {
    final textTheme = Theme.of(context).textTheme;
    final tip = widget.tip;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tip.name, style: textTheme.headlineLarge),
            Text(tip.provider, style: textTheme.bodySmall),
            Text(
              tip.getRatingAndDuration(),
              style: textTheme.bodySmall,
            ),
            Text(tip.level, style: textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  Widget buildEndDrawer() {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: CheckoutPage(
          sessionManager: widget.sessionManager,
          didUpdate: () {
            setState(() {});
          },
          onSubmit: (session) {
            final savedSession = SavedSession(
              name: session.name.isNotEmpty ? session.name : 'Session',
              reminder: session.reminderType == 1,
              date: session.selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(session.selectedDate!)
                  : '',
              time: session.selectedTime != null
                  ? '${session.selectedTime!.hour.toString().padLeft(2, '0')}:${session.selectedTime!.minute.toString().padLeft(2, '0')}'
                  : '',
              totalMinutes: session.totalFocusMinutes,
              stepTitles: session.steps.map((step) => step.title).toList(),
            );
            widget.sessionManagerOrders.addSession(savedSession);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: openDrawer,
      tooltip: 'Session',
      icon: const Icon(Icons.timer),
      label: Text('${widget.sessionManager.totalSteps} Steps'),
    );
  }

  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildStepsSection('Steps'),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FeedbackSection(tipId: widget.tip.id),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = _calculateConstrainedWidth(screenWidth);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: buildEndDrawer(),
        floatingActionButton: _buildFloatingActionButton(),
        body: Center(
          child: SizedBox(
            width: constrainedWidth,
            child: _buildCustomScrollView(),
          ),
        ),
      ),
    );
  }
}