import 'package:flutter/material.dart';
import 'package:mp/pertemuan13/pages/forget_password_page.dart';
import 'package:mp/pertemuan13/pages/home_page.dart';
import 'package:mp/pertemuan13/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formLoginKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  Widget _socialIcon(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(assetPath, width: 30, height: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Tombol back
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Colors.white70),
                ),
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1)),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formLoginKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Sign in to continue",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Email
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: Colors.white.withOpacity(0.5)),
                              label: Text('Email',
                                  style: TextStyle(
                                      color:
                                          Colors.white.withOpacity(0.7))),
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.white.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.white.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.purple),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Password
                          TextFormField(
                            obscureText: true,
                            obscuringCharacter: '*',
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: Colors.white.withOpacity(0.5)),
                              label: Text('Password',
                                  style: TextStyle(
                                      color:
                                          Colors.white.withOpacity(0.7))),
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.white.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.white.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.purple),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberPassword,
                                    onChanged: (bool? value) {
                                      setState(() =>
                                          rememberPassword = value!);
                                    },
                                    activeColor: Colors.purple,
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                        color: Colors.white
                                            .withOpacity(0.5)),
                                  ),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                        color: Colors.white
                                            .withOpacity(0.7)),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgetPassword()),
                                  );
                                },
                                child: const Text(
                                  'Forget Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Tombol Login
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formLoginKey.currentState!
                                        .validate() &&
                                    rememberPassword) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text('Login Success')),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                } else if (!rememberPassword) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please agree to the processing of personal data')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text(
                                  'Register with',
                                  style: TextStyle(
                                      color:
                                          Colors.white.withOpacity(0.5)),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              _socialIcon(
                                  'assets/appimages/GoogleLogo.png'),
                              _socialIcon('assets/appimages/FbLogo.png'),
                              _socialIcon(
                                  'assets/appimages/githublogo.png'),
                              _socialIcon(
                                  'assets/appimages/twitterlogo.png'),
                            ],
                          ),

                          const SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterPage()),
                                  );
                                },
                                child: const Text(
                                  ' Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}