import 'package:firebase_auth/firebase_auth.dart';

class DebugAuth {
  Future<void> authStateChanges() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
}

                    /*
                    await ref.update({
                      "notas": "gato",
                    });

                    DatabaseReference ref2 =
                        FirebaseDatabase.instance.ref('users/$userId/notas');
                    ref2.onValue.listen((DatabaseEvent event) {
                      final data = event.snapshot.value;

                      print(data);
                    });
                    */