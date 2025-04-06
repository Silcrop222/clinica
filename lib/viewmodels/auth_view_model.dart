import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Actualiza el estado de carga y notifica
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Registrar usuario
  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.signUp(email, password);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Iniciar sesión
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.signIn(email, password);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Obtener usuario actual
  void getCurrentUser() {
    try {
      _user = _authService.getCurrentUser();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
