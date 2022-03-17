import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:git_viewer/resource.dart';
import 'package:http/http.dart' as http;

import '../../model/git_repo.dart';

class SearchViewController extends GetxController {
  /// The current String entered by a user (a GitHub username to search).
  final searchString = ''.obs;

  /// All public repos for a GitHub username matching `searchString`.
  final repos = Resource<List<GitRepo>>.loading('').obs;

  /// Fetch all publi repositories for a user. Search query is retrieved from `searchString`.
  Future<void> fetchPublicRepositories() async {
    log('Fetching repositories');
    var username = searchString();
    var url = Uri.https('api.github.com', '/users/$username/repos');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonConvert = jsonDecode(response.body) as List<dynamic>;
        var allRepos = jsonConvert.map(((e) => GitRepo.fromJson(e))).toList();
        repos(Resource.completed(allRepos));
      }
    } catch (e, _) {
      log('Eror: ' + e.toString());
      repos(Resource.error('Eror: ' + e.toString()));
    }
  }
}
