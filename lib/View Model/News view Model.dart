import 'package:newss/Repository/News%20Repository.dart';
import 'package:newss/View%20Model/CategoryNewsModel.dart';

import '../NewsHeadlines.dart';

class NewsViewModel {
  final _repo = NewsRepository();

  Future<NewsHeadlines> fetchNewsHeadlines(String sourceName) async {
    final response = await _repo.fetchNewsHeadlines(sourceName);
    return response;
  }

  Future<CategoryNewsModel> fetchCategoriesNews(String category) async {
    final response = await _repo.fetchCategoriesNews(category);
    return response;
  }
}
