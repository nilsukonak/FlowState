import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/presentation/providers/login_provider.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';
import 'package:todoapp/presentation/screens/auth/login.dart';
import 'package:todoapp/helpers/app_color.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _SigninState();
}

class _SigninState extends State<LoginPage> {
  TextEditingController emailcont = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailcont.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    final appbarlength = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: appbarlength,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            SizedBox(height: 70),
            Center(
              child: Text(
                'Welcome back!',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.06,

                  child: TextFormField(
                    controller: emailcont,
                    decoration: InputDecoration(
                      labelText: 'Email',

                      // contentPadding: EdgeInsets.only(left: 12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,

                child: TextFormField(
                  controller: passcontroller,
                  obscureText: true, //şifreyi ekranda gizlemek için
                  decoration: InputDecoration(
                    labelText: 'Password',

                    contentPadding: EdgeInsets.only(left: 12),
                  ),
                ),
              ),
              SizedBox(height: 70),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (emailcont.text.isEmpty ||
                              passcontroller.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email ve şifre boş olamaz'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await context.read<LoginProvider>().signIn(
                              emailcont.text.trim(),
                              passcontroller.text.trim(),
                            );

                            if (!mounted) return;
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Giriş başarısız: $e')),
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },

                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login', style: TextStyle(fontSize: 20)),
                ),
              ),

              SizedBox(height: 12),

              Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);

                          try {
                            await context
                                .read<LoginProvider>()
                                .signInWithGoogle();
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Google login failed: $e'),
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  icon: const Icon(Icons.account_circle_outlined, size: 22),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 12),

              Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // zorunlu hale getiriyoruz
                    backgroundColor: AppColors.lightGray,
                  ),
                  onPressed: () {
                    context.router.push(const SigninRoute());
                  },

                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),

              SizedBox(height: 12),

              Container(
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    context.router.push(const ForgotPasswordRoute());
                  },
                  child: Text(
                    'Forget Password',
                    style: TextStyle(color: Colors.black, fontSize: 20),
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
