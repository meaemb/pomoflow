import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/auth.dart';
import 'models/tip_state.dart';
import 'models/tip.dart';
import 'models/session_state.dart';
import 'data/database_repository.dart';
import 'models/user_dao.dart';
import 'models/message_dao.dart';
import 'components/message.dart';
import 'models/feedback_dao.dart';  // ← только эта строка, НЕ models/feedback.dart

final feedbackDaoProvider = Provider<FeedbackDao>((ref) {
  return FeedbackDao(ref.watch(userDaoProvider));
});

// Firebase провайдеры (для чата)
final userDaoProvider = ChangeNotifierProvider<UserDao>((ref) => UserDao());

final messageDaoProvider = Provider<MessageDao>((ref) => MessageDao(ref.watch(userDaoProvider)));

final messageListProvider = StreamProvider<List<Message>>((ref) {
  return ref.watch(messageDaoProvider).getMessageStream();
});

// Основные провайдеры
final sharedPrefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final authProvider = Provider<Auth>((ref) {
  final prefs = ref.watch(sharedPrefProvider);
  return Auth(prefs);
});

final tipProvider = StateNotifierProvider<TipNotifier, TipState>((ref) {
  return TipNotifier();
});

final savedTipsStreamProvider = StreamProvider<List<Tip>>((ref) {
  final notifier = ref.watch(tipProvider.notifier);
  return notifier.savedTipsStream;
});

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});

final selectedIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository();
});