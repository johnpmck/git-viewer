import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:git_viewer/model/git_repo.dart';
import 'package:git_viewer/module/search_view/widgets/animated_search_bar.dart';
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
        'Enter a GitHub username to view all public repositories.',
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
            shrinkWrap: true,
            itemCount: repos.length,
            separatorBuilder: (_, idx) => const Divider(),
            itemBuilder: (_, idx) {
              var repo = repos[idx];
              return ListTile(
                leading: repo.owner?.avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(repo.owner?.avatarUrl ?? ''),
                      )
                    : null,
                title: Text(
                  repos[idx].name ?? 'Repository Name',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  repo.description ?? 'Repository description',
                  // style: TextStyle(fontSize: 12),
                ),
              );
            },
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
              color: Colors.blue.shade200,
              duration: const Duration(milliseconds: 250),
              child: controller.searchString().isEmpty
                  ? _defaultBody
                  : _buildResults(controller.repos()),
            );
          },
        ),
        floatingActionButton: AnimatedSearchBar(
          onSubmitted: _updateSearchString,
        ),
      ),
    );
  }

  _updateSearchString(String query) {
    controller.searchString(query);
    controller.fetchPublicRepositories();
  }
}
