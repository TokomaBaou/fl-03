import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserModel {
  UserModel({
    required this.userId,
    required this.userName,
    required this.iconPath,
    required this.createdAt,
  });

  /// モデル内部で使う変数
  String userId;
  String userName;
  String iconPath;
  Timestamp createdAt;

  /// jsonからモデルを生成する
  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
        userId: data['userId'],
        userName: data['userName'],
        iconPath: data['iconPath'],
        createdAt: data['createdAt'],
      );

  /// モデルをjsonに変換する
  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userName': userName,
        'iconPath': iconPath,
        'createdAt': createdAt,
      };

  /// モデルの初期データ
  factory UserModel.initialData() => UserModel(
        userId: const Uuid().v4(),
        userName: '',
        iconPath:
            'https://user-images.githubusercontent.com/67848399/194080091-d82038f9-09f2-489b-99c5-50a7a6419105.png',
        createdAt: Timestamp.now(),
      );

  /// fromJsonメソッド
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['userId'],
        userName: json['userName'],
        iconPath: json['iconPath'],
        createdAt: json['createdAt'],
      );
}
