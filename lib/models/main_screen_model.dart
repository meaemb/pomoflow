import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers.dart';

class MainScreenModel {
  final Ref ref;
  static const String _prefSelectedIndexKey = 'selectedIndex';

  MainScreenModel(this.ref);

  // Сохранение индекса (как в книге: saveCurrentIndex)
  Future<void> saveCurrentIndex(int index) async {
    final prefs = ref.read(sharedPrefProvider);
    await prefs.setInt(_prefSelectedIndexKey, index);
  }

  // Загрузка индекса (как в книге: loadCurrentIndex)
  Future<int> loadCurrentIndex() async {
    final prefs = ref.read(sharedPrefProvider);
    return prefs.getInt(_prefSelectedIndexKey) ?? 0;
  }
}

// Провайдер для модели главного экрана (как в книге)
final mainScreenModelProvider = Provider<MainScreenModel>((ref) {
  return MainScreenModel(ref);
});