import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../constants/status_constants.dart';

class FirebaseAuthService {
  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User? get currentFirebaseUser => _firebaseAuth.currentUser;

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.villager,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'role': role.name,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return AppUser(uid: uid, email: email, name: name, role: role);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data() ?? <String, dynamic>{};

    return AppUser(
      uid: uid,
      email: (data['email'] as String?) ?? email,
      name: (data['name'] as String?) ?? 'User',
      role: UserRole.values.firstWhere(
        (item) => item.name == data['role'],
        orElse: () => UserRole.villager,
      ),
    );
  }

  Future<AppUser?> getCurrentUser() async {
    final current = currentFirebaseUser;
    if (current == null) {
      return null;
    }

    final doc = await _firestore.collection('users').doc(current.uid).get();
    final data = doc.data();
    if (data == null) {
      return null;
    }

    return AppUser(
      uid: current.uid,
      email: data['email'] as String? ?? current.email ?? '',
      name: data['name'] as String? ?? 'User',
      role: UserRole.values.firstWhere(
        (item) => item.name == data['role'],
        orElse: () => UserRole.villager,
      ),
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
