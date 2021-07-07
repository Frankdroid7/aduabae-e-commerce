import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as ayo;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  List<CategoryModel> categoryModelList = [];
  Future<List<CategoryModel>> getAllCategories() async {
    categoryModelList = await ApiHelper.getAllCategories();
    setState(() {
      _isLoading = false;
    });

    return categoryModelList;
  }

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              _isLoading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryModelList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(categoryModelList[index].categoryName!),
                              SizedBox(height: 10),
                              Text(categoryModelList[index].categoryId!),
                            ],
                          ),
                        );
                      }),
              ElevatedButton(
                onPressed: () {
                  ApiHelper.deleteCategory();
                },
                child: Text('DELETE'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ApiHelper {
  static String baseEndpoint = 'http://aduabaecommerceapi.azurewebsites.net';
  static Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categoryModelList = [];
    String url = '$baseEndpoint/Categories/get-all-categories';

    ayo.Response _response = await ayo.get(Uri.parse(url));
    print(_response.body);

    List decodedResponse = jsonDecode(_response.body);
    categoryModelList =
        decodedResponse.map((json) => CategoryModel.fromJson(json)).toList();
    return categoryModelList;
  }

  static Future deleteCategory() async {
    String url = '$baseEndpoint/Categories/remove-categories';
    ayo.Response _response = await ayo.delete(
      Uri.parse(url),
      body: jsonEncode(['Spices']),
    );
    print(_response.body);
  }
}

class CategoryModel {
  String? categoryId;
  String? categoryName;

  CategoryModel({@required this.categoryId, this.categoryName});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }
}
