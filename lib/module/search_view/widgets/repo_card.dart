import 'package:flutter/material.dart';
import 'package:git_viewer/model/git_repo.dart';
import 'package:intl/intl.dart';

class RepoCard extends StatelessWidget {
  RepoCard({Key? key, required this.repo}) : super(key: key);

  final GitRepo repo;

  final _dateFormatter = DateFormat('MMM dd, y');

  String _formattedDate(DateTime? date) {
    if (date == null) return '';

    var dateStr = _dateFormatter.format(date);
    return (date.year == DateTime.now().year)
        ? dateStr.substring(0, 6)
        : dateStr;
  }

  String formatLargeIntString(String val) {
    int len = val.length;
    if (len <= 3) return val;

    if (len == 4) {
      return val.substring(0, 1) + ',' + val.substring(1);
    } else if (len == 5) {
      return val.substring(0, 2) + '.' + val.substring(2, 3) + 'K';
    } else if (len == 6) {
      return val.substring(0, 3) + 'K';
    } else if (len > 6) {
      return val.substring(0, 1) + 'M';
    }
    return val;
  }

  Column _iconWithValue(String val, IconData icon) {
    return Column(
      children: <Widget>[
        Icon(icon, color: val != '0' ? Colors.green : Colors.black),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            formatLargeIntString(val),
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _repoTopicChips(ThemeData theme) {
    if (repo.topics != null) {
      var chips = repo.topics?.map((e) {
        var topic = e as String;
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
          child: Text(
            topic,
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        children: chips ?? [],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              (repo.owner?.avatarUrl != null)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(repo.owner?.avatarUrl ?? ''))
                  : const CircleAvatar(backgroundColor: Colors.grey),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    repo.name ?? 'Repository Name',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(48.0, 4.0, 0, 0),
            child: Text(
              repo.description ?? 'Repository description',
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(48.0, 0, 0, 0),
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: _repoTopicChips(theme),
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _iconWithValue(
                (repo.forksCount ?? 0).toString(),
                Icons.share_outlined,
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
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Wrap(
              spacing: 24,
              alignment: WrapAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.add,
                        size: 18,
                      ),
                    ),
                    Text(
                      _formattedDate(repo.createdAt),
                      style: const TextStyle(fontSize: 10.0),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.update,
                        size: 18,
                      ),
                    ),
                    Text(
                      _formattedDate(repo.updatedAt),
                      style: const TextStyle(fontSize: 10.0),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
