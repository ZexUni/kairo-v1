import 'package:flutter/material.dart';

import 'package:kairo/core/services/auth_service.dart';
import 'package:kairo/features/onboarding/presentation/screens/identity_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService authService = AuthService();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLogin = true;
  bool loading = false;

  Future<void> submit() async {
    try {
      setState(() => loading = true);

      if (isLogin) {
        await authService.signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await authService.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const IdentityScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),

      filled: true,
      fillColor: const Color(0xFF111A33),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF4E8CFF),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B1D),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),

              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4E8CFF),
                          Color(0xFF7B61FF),
                        ],
                      ),
                    ),

                    child: const Icon(
                      Icons.psychology,
                      color: Colors.black,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'KAIRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    isLogin
                        ? 'Sign in to continue'
                        : 'Create your account',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: emailController,
                    decoration: inputDecoration(
                      'Email',
                      Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: inputDecoration(
                      'Password',
                      Icons.lock_outline,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      onPressed: loading ? null : submit,

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF4E8CFF),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),

                      child: Text(
                        loading
                            ? 'Loading...'
                            : isLogin
                                ? 'LOGIN'
                                : 'CREATE ACCOUNT',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },

                    child: Text(
                      isLogin
                          ? 'Need an account? Sign Up'
                          : 'Already have an account? Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}