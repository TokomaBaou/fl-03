import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_app_3/data/data_source/firestore_data_source.dart';
import 'package:fl_app_3/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// firestoreDataSource
  final CloudFirestoreDataSource _firestoreDataSource =
      CloudFirestoreDataSource(FirebaseFirestore.instance);

  /// Firestoreからデータを取得し、_userModelListに追加する
  Future<List<UserModel>> _getUserModelList() async {
    // わざと遅延させる
    await Future.delayed(const Duration(seconds: 2));

    final snapshot =
        await _firestoreDataSource.getDocuments(collection: 'user');
    return snapshot.map((e) => UserModel.fromMap(e)).toList();
  }

  Stream<List<UserModel>> _getUserModelListStream() {
    return _firestoreDataSource
        .getDocumentsStream(collection: 'user')
        .map((snapshot) => snapshot.map((e) => UserModel.fromMap(e)).toList());
  }

  @override
  void initState() {
    super.initState();
    _getUserModelList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サンプルFirebase'),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _getUserModelListStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userModelList = snapshot.data!;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(userModelList[index].iconPath),
                  title: Text(userModelList[index].userName),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // body: FutureBuilder(
      //   future: _getUserModelList(),
      //   builder: (context, snapshot) {
      //     /// ローディング中
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     /// エラー発生
      //     if (snapshot.hasError) {
      //       return const Center(child: Text('エラーが発生しました'));
      //     }

      //     /// データ一覧表示
      //     if (snapshot.hasData) {
      //       final userModelList = snapshot.data as List<UserModel>;
      //       return ListView.builder(
      //         itemCount: userModelList.length,
      //         itemBuilder: (context, index) {
      //           final userModel = userModelList[index];
      //           return ListTile(
      //             leading: Image.network(userModel.iconPath),
      //             title: Text(userModel.userName),
      //             subtitle: Text(userModel.createdAt.toString()),
      //           );
      //         },
      //       );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
