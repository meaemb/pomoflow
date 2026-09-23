import '../models/tip_model.dart';
import '../models/tip.dart';
import '../models/category.dart';
import '../models/review.dart';
import '../network/tip_api_service.dart';

class ExploreData {
  final List<Tip> tips;
  final List<Category> categories;
  final List<Review> reviews;

  ExploreData({
    required this.tips,
    required this.categories,
    required this.reviews,
  });
}

class MockPomoFlowService {
  final TipApiService _apiService = TipApiService();

  Future<ExploreData> getExploreData() async {
    // ТЕПЕРЬ ДАННЫЕ ИДУТ ИЗ ТВОЕГО API В ИНТЕРНЕТЕ!
    final tipModels = await _apiService.fetchAllTipsFromMyApi();

    // Конвертируем TipModel в Tip
    final tips = tipModels.map((model) => Tip.fromModel(model)).toList();

    print('✅ Загружено ${tips.length} советов из интернета через API');

    return ExploreData(
      tips: tips,
      categories: Category.samples,
      reviews: Review.samples,
    );
  }
}