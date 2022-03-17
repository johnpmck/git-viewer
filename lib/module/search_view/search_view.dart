import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:git_viewer/model/git_repo.dart';
import 'package:git_viewer/module/search_view/widgets/animated_search_bar.dart';
import 'package:git_viewer/module/search_view/widgets/repo_card.dart';
import 'package:git_viewer/resource.dart';

import 'search_view_controller.dart';

/// Main view.
class SearchView extends GetView<SearchViewController> {
  SearchView({Key? key}) : super(key: key);

  final _defaultBody = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: const <Widget>[
      FlutterLogo(size: 60),
      SizedBox(height: 24),
      Text(
        'View all public repositories for GitHub users or organizations.',
        textAlign: TextAlign.center,
      ),
    ],
  );

  Widget _buildResults(Resource<List<GitRepo>> resource) {
    switch (resource.status) {
      case Status.error:
        return Center(
          child: Text(resource.message ?? 'error occurred'),
        );
      case Status.loading:
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      case Status.completed:
        var repos = resource.data;
        if (repos != null) {
          return ListView.separated(
            controller: controller.scrollController,
            shrinkWrap: true,
            itemCount: repos.length,
            separatorBuilder: (_, idx) => const Divider(),
            itemBuilder: (_, idx) => RepoCard(repo: repos[idx]),
          );
        }
        return const Center(
          child: Text('fetchPublicRepositories() retured null!'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Git Viewer'),
        ),
        body: Obx(
          () {
            return AnimatedContainer(
              // color: Colors.blue.shade200,
              duration: const Duration(milliseconds: 250),
              child: controller.searchString().isEmpty
                  ? _defaultBody
                  : _buildResults(controller.repos()),
            );
          },
        ),
        floatingActionButton: Obx(
          () => AnimatedSearchBar(
            onSubmitted: _updateSearchString,
            shrink: controller.shrink(),
          ),
        ),
      ),
    );
  }

  _updateSearchString(String query) {
    if (query.isNotEmpty) {
      FocusScope.of(Get.context!).unfocus();
      controller.searchString(query);
      controller.fetchPublicRepositories();
    }
  }
}
