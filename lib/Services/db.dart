import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DbService extends GetxController {
  final databaseReference = FirebaseDatabase.instance.ref();
  int balance = 0;

  String readData() {
    var k = 'Loading';
    // databaseReference.path("Smart Trasportation/1388918383/balance")
    databaseReference.onValue.listen((event) {
      k = event.snapshot.value.toString();
      log(k);
    });
    return k;
  }

  int readBalance() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('Smart Trasportation/8716382154/balance');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      balance = int.parse(data.toString());
      log(balance.toString());
      update();
    });

    return balance;
  }
}
