import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newss/View%20Model/CategoryNewsModel.dart';
import '../NewsHeadlines.dart';

class NewsRepository {
  Future<NewsHeadlines> fetchNewsHeadlines(String sourceName) async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=$sourceName&apiKey=580bbf9da8fa4dcd9851b31cfd9e47bb';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsHeadlines.fromJson(body);
    }
    throw Exception('Error');
  }
  Future<CategoryNewsModel> fetchCategoriesNews(String category) async {
    String url = 'https://newsapi.org/v2/everything?q=${category}&apiKey=580bbf9da8fa4dcd9851b31cfd9e47bb';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoryNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }

}
