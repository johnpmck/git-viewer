import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:git_viewer/module/search_view/search_view.dart';
import 'package:git_viewer/module/search_view/search_view_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Git Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SearchView(),
          binding: BindingsBuilder.put(() => SearchViewController()),
        ),
      ],
    );
  }
}
