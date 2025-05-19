import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// AuthService kümmert sich um Anmeldung/Registrierung
/// und legt das Nutzerprofil DSGVO-konform in Firestore an.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db  = FirebaseFirestore.instance;

  /// Stream der Authentifizierungszustände
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Anonym anmelden (z.B. für interne Tests)
  Future<UserCredential> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  /// Anmeldung mit E-Mail und Passwort
  Future<UserCredential> signInWithEmail(
    String email,
    String password,
  ) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Registrierung mit E-Mail, Passwort und optionalem Nickname.
  /// Speichert in Firestore nur die email und nickname – keine weiteren PII.
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? nickname,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    final data = {
      'email': user.email,
      if (nickname != null) 'nickname': nickname,
    };
    await _db.collection('users').doc(user.uid).set(data);
    return cred;
  }

  /// Abmelden
  Future<void> signOut() {
    return _auth.signOut();
  }
}
