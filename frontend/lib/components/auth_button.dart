import 'package:flutter/material.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';
import 'rounded_button.dart';

class AuthButton extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function(AuthUser) onAuthenticationSuccessfulResult;
  final Function(String) onAuthenticationFailedResult;

  const AuthButton({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onAuthenticationSuccessfulResult,
    required this.onAuthenticationFailedResult,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  Future<void> _authenticateUser(BuildContext context) async {
    try {
      widget.onAuthenticationSuccessfulResult(await AuthService.login(
          widget.usernameController.text, widget.passwordController.text));
    } on Exception catch (e, _) {
      widget.onAuthenticationFailedResult(
          e.toString().replaceAll("Exception: ", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      title: 'Sign In',
      backgroundColour: const Color(0xFFd0bcff),
      textColour: const Color(0xFF381E72),
      onPressed: () => _authenticateUser(context),
    );
  }
}
