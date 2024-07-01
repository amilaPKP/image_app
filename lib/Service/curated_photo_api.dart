import 'dart:convert';

import 'package:http/http.dart' as http;

class photoApi {
  static const BASE_URl = 'https://api.pexels.com/v1';
  final String apiKey;

  photoApi(this.apiKey);

  Future getPhotos() async {
    final response = await http.get(Uri.parse('$BASE_URl/curated?per_page=80'),
        headers: {'Authorization': apiKey});
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    } else {
      print('not successful');
    }
  }

  Future getCategoryPhotos({required String query}) async {
    final response = await http.get(
        Uri.parse('$BASE_URl/search?query=$query&per_page=80'),
        headers: {'Authorization': apiKey});
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    } else {
      print('not successful');
    }
  }

  Future loadMorePhotos(
      {required String query, required int pageNumber}) async {
    final response = await http.get(
        Uri.parse('$BASE_URl/search/?page=' +
            pageNumber.toString() +
            '&per_page=80&query=$query'),
        headers: {'Authorization': apiKey});
    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    } else {
      print('not successful');
    }
  }
}
