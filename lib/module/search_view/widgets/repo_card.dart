import 'package:flutter/material.dart';
import 'package:git_viewer/model/git_repo.dart';

class RepoCard extends StatelessWidget {
  const RepoCard({Key? key, required this.repo}) : super(key: key);

  final GitRepo repo;

  Column _iconWithValue(String val, IconData icon) {
    return Column(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            val,
            style: const TextStyle(
              // color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              (repo.owner?.avatarUrl != null)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(repo.owner?.avatarUrl ?? ''),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    repo.name ?? 'Repository Name',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(56.0, 4.0, 16.0, 16.0),
            child: Text(
              repo.description ?? 'Repository description',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _iconWithValue(
                (repo.forksCount ?? 0).toString(),
                Icons.notification_important_outlined,
              ),
              _iconWithValue(
                (repo.watchersCount ?? 0).toString(),
                Icons.visibility_outlined,
              ),
              _iconWithValue(
                (repo.openIssuesCount ?? 0).toString(),
                Icons.notification_important_outlined,
              ),
              _iconWithValue(
                (repo.stargazersCount ?? 0).toString(),
                Icons.star_border_rounded,
              ),
            ],
          )
        ],
      ),
    );
  }
}
