import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemicates_flutter_app/presentation/home_page.dart';
import 'package:gemicates_flutter_app/presentation/registration_page.dart';
import 'package:gemicates_flutter_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isAuthenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              });
            }

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Image.asset('assets/gemicates.png'),
                  const Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (authProvider.errorMessage != null)
                    Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  authProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              authProvider.login(email, password);
                            }
                          },
                          child: const Text('Login'),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
