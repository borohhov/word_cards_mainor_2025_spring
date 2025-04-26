import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:word_cards_mainor_2025_spring/controllers/auth/firebase_auth.dart';
import 'package:word_cards_mainor_2025_spring/controllers/persistence/persistence.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

import '../../firebase_options.dart';

class FirebaseController implements PersistenceInterface {
  late FirebaseFirestore db;
  late String userId;
  @override
  Future<List<WordCardList>> getAllWordCardLists() async {
    await init();
    List<WordCardList> list = [];
    var auth = FirebaseAuthImpl();
    await db.collection("wordcards").where('userId', isEqualTo: auth.currentUser?.uid).get().then(
          (querySnapshot) {
        //print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          try {
            list.add(WordCardList.fromJson(docSnapshot.data()));
          }
          catch (e) {
            continue;
          }
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return list;
  }

  @override
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    db = FirebaseFirestore.instance;
    var auth = FirebaseAuthImpl();
    userId = auth.currentUser!.uid;
  }

  @override
  Future<void> saveWordCardList(WordCardList list) async {
    await init();
    var newList = list;
    newList.uid = userId;
    await db.collection('wordcards').add(list.toJson());
  }

}