import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({
    Key? key,
    required this.onSubmitted,
  }) : super(key: key);

  final void Function(String) onSubmitted;
  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  /// [AnimationController] for search bar animations.
  late AnimationController _animationController;

  /// [TextEditingController] for search TextField.
  late TextEditingController _searchFieldController;

  /// [FocusNode] for search TextField.
  final _searchFieldFocusNode = FocusNode();

  /// Whether the search bar is expanded or not.
  bool _expanded = false;

  void _reveal() {
    setState(() {
      _expanded = true;
      _animationController.forward();
    });
  }

  void _hide() {
    setState(() {
      _expanded = false;
      _searchFieldController.clear();
      _searchFieldFocusNode.unfocus();
      _animationController.reverse();
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _searchFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _animationController
      ..stop()
      ..dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final expandedWidth = deviceWidth - 32.0;
    final textFieldWidth = deviceWidth - 132.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 56.0,
      width: _expanded ? expandedWidth : 56.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: Stack(
        children: [
          /// [InkWell] which hides the search bar.
          Positioned(
            top: 9,
            left: 8,
            child: AnimatedOpacity(
              opacity: _expanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Material(
                borderRadius: BorderRadius.circular(30),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: _expanded ? () => _hide() : () {},
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20.0,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Search [TextField].
          AnimatedPositioned(
            duration: const Duration(milliseconds: 375),
            left: _expanded ? 50.0 : 20.0,
            curve: Curves.easeInOut,
            top: 11,
            child: AnimatedOpacity(
              opacity: _expanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: SizedBox(
                height: 32.0,
                width: textFieldWidth,
                child: TextField(
                  controller: _searchFieldController,
                  cursorRadius: const Radius.circular(10.0),
                  cursorWidth: 2.0,
                  cursorColor: Colors.black45,
                  focusNode: _searchFieldFocusNode,
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  textInputAction: TextInputAction.done,
                  onSubmitted: widget.onSubmitted,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'GitHub user',
                    labelStyle: TextStyle(
                      color: Color(0xff5B5B5B),
                      fontWeight: FontWeight.w400,
                    ),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// [InkWell] which starts the animation and updates the search String.
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Material(
                borderRadius: BorderRadius.circular(30),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: !_expanded
                      ? () => _reveal()
                      : () => widget
                          .onSubmitted(_searchFieldController.text.trim()),
                  child: Container(
                    height: 52.0,
                    width: 52.0,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.search_outlined,
                      size: 20.0,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
