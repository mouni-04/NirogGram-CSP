import 'package:flutter/foundation.dart';

import '../../../../core/constants/status_constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/app_user.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._authService);

  final AuthenticationService _authService;

  AppUser? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<void> restoreSession() async {
    isLoading = true;
    notifyListeners();

    try {
      currentUser = await _authService.getCurrentUserProfile();
      errorMessage = null;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    notifyListeners();

    try {
      currentUser = await _authService.loginWithEmailPassword(
        email: email,
        password: password,
      );
      errorMessage = null;
      return true;
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.villager,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      currentUser = await _authService.registerWithEmailPassword(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      errorMessage = null;
      return true;
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    currentUser = null;
    notifyListeners();
  }
}
