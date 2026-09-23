import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'constants.dart';
import 'home.dart';
import 'models/saved_session_manager.dart';
import 'models/session_manager.dart';
import 'models/auth.dart';
import 'models/user.dart';
import 'models/tip.dart';
import 'screens/screens.dart';
import 'providers.dart';
import 'api/mock_pomoflow_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPrefProvider.overrideWithValue(sharedPrefs),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const PomoFlow();
  }
}

class PomoFlow extends ConsumerStatefulWidget {
  const PomoFlow({super.key});

  @override
  ConsumerState<PomoFlow> createState() => _PomoFlowState();
}

class _PomoFlowState extends ConsumerState<PomoFlow> {
  late final SavedSessionManager sessionManager;
  late final SessionManager sessionManagerOrders;
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.blue;
  late final Auth auth;
  late final User user;

  List<Tip> _allTips = [];

  @override
  void initState() {
    super.initState();
    auth = ref.read(authProvider);
    sessionManager = SavedSessionManager();
    sessionManagerOrders = SessionManager();
    user = const User(
      fullName: 'Begina',
      profileImageUrl: 'assets/avatars/my_avatar.jpg',
      role: 'Premium Member',
      points: 1250,
    );
    auth.addListener(_onAuthChanged);
    _loadTips();
  }

  Future<void> _loadTips() async {
    final service = MockPomoFlowService();
    final data = await service.getExploreData();
    setState(() {
      _allTips = data.tips;
      print('✅ Загружено ${_allTips.length} советов из API');
      for (int i = 0; i < _allTips.length; i++) {
        print('   [$i] ${_allTips[i].name}');
      }
    });
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  Future<String?> _appRedirect(BuildContext context, GoRouterState state) async {
    final loggedIn = auth.loggedIn;
    final isOnLoginPage = state.matchedLocation == '/login';

    if (!loggedIn) {
      return '/login';
    }
    if (loggedIn && isOnLoginPage) {
      return '/${PomoTab.explore.value}';
    }
    return null;
  }

  late final _router = GoRouter(
    initialLocation: '/login',
    redirect: _appRedirect,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginPage(
          onLogIn: (credentials) async {
            await auth.signIn(credentials.username, credentials.password);
            if (mounted) {
              context.go('/${PomoTab.explore.value}');
            }
          },
        ),
      ),
      GoRoute(
        path: '/:tab',
        name: 'home',
        builder: (context, state) {
          final tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
          return Home(
            auth: auth,
            user: user,
            changeTheme: changeThemeMode,
            changeColor: changeColor,
            colorSelected: colorSelected,
            sessionManager: sessionManager,
            sessionManagerOrders: sessionManagerOrders,
            initialTab: tab,
          );
        },
        routes: [
          GoRoute(
            path: 'tip/:id',
            name: 'tip_detail',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              print('🔍 Запрос открыть совет с индексом: $id');
              print('🔍 Всего загружено советов: ${_allTips.length}');

              final tip = id >= 0 && id < _allTips.length ? _allTips[id] : null;
              if (tip == null) {
                print('❌ Совет не найден! ID: $id, Всего: ${_allTips.length}');
                return const Scaffold(
                  body: Center(child: Text('Tip not found')),
                );
              }
              print('✅ Открываем совет: ${tip.name}');
              return TipPage(
                tip: tip,
                sessionManager: sessionManager,
                sessionManagerOrders: sessionManagerOrders,
              );
            },
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            'Error: ${state.error.toString()}',
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        debugPrint('Tour finished!');
      },
      builder: (context) => MaterialApp.router(
        title: 'PomoFlow',
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        themeMode: themeMode,
        theme: ThemeData(
          colorSchemeSeed: colorSelected.color,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: colorSelected.color,
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}