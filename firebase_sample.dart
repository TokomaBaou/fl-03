/// FirebaseのCRUDを行うクラス
class FirebaseFireStore {
  /// Firebaseのインスタンス
  final _firebase = FirebaseFirestore.instance;

  /// データを追加する
  Future<void> addData(String collectionName, Map<String, dynamic> data) async {
    await _firebase.collection(collectionName).add(data);
  }

  /// データを更新する
  Future<void> updateData(String collectionName, String documentId,
      Map<String, dynamic> data) async {
    await _firebase.collection(collectionName).doc(documentId).update(data);
  }

  /// データを削除する
  Future<void> deleteData(String collectionName, String documentId) async {
    await _firebase.collection(collectionName).doc(documentId).delete();
  }

  /// documentデータを取得する
  Future<DocumentSnapshot> getData(
      String collectionName, String documentId) async {
    return await _firebase.collection(collectionName).doc(documentId).get();
  }

  /// collectionデータを取得する（Stream）
  Stream<QuerySnapshot> getDataStream(String collectionName) {
    return _firebase.collection(collectionName).snapshots();
  }

  /// collectionデータを取得する（Future）
  Future<QuerySnapshot> getDataFuture(String collectionName) {
    return _firebase.collection(collectionName).get();
  }
}
