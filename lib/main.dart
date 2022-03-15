import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:git_viewer/model/git_repo.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Git Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GitViewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  bool _hasResults = false;
  List<GitRepo> _repos = [];

  void _updateResults(bool hasresults, List<GitRepo> repos) {
    setState(() {
      _hasResults = hasresults;
      _repos = repos;
    });
  }

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

  Widget _buildResults() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _repos.length,
      separatorBuilder: (_, idx) => const Divider(),
      itemBuilder: (_, idx) {
        var repo = _repos[idx];
        return ListTile(
          leading: repo.owner?.avatarUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(repo.owner?.avatarUrl ?? ''),
                )
              : null,
          title: Text(
            _repos[idx].name ?? 'Repository Name',
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: _textController,
            textInputAction: TextInputAction.done,
            cursorColor: theme.colorScheme.onPrimary,
            style: TextStyle(color: theme.colorScheme.onPrimary),
            decoration: InputDecoration(
              hintText: 'GitHub username',
              hintStyle: TextStyle(color: theme.colorScheme.onPrimary),
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onPrimary,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            onFieldSubmitted: (val) async =>
                await _fetchPublicRepositories(val),
          ),
        ),
        body: AnimatedCrossFade(
          firstChild: _defaultBody,
          secondChild: _buildResults(),
          crossFadeState: _hasResults
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Future<void> _fetchPublicRepositories(String userInput) async {
    // var username = _textController.text.trim();
    var url = Uri.https('api.github.com', '/users/$userInput/repos');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonConvert = jsonDecode(response.body) as List<dynamic>;
        // var gitRepo = gitRepoFromMap(response.body);
        // var gitRepo = GitRepo.fromJson(jsonConvert[0]);
        var repos = jsonConvert.map(((e) => GitRepo.fromJson(e))).toList();
        _updateResults(true, repos);
      }
    } catch (e, _) {
      log('Eror: ' + e.toString());
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
