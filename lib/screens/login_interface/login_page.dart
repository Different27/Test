import 'package:flutter/material.dart';
import 'package:test_project/screens/login_interface/signup.dart';
import '../../widgets/nav_bar.dart';
import 'custom_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String uid;

  Future<bool> loginState(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('players')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Người dùng được tìm thấy
        uid = querySnapshot.docs.first.id;
        print(uid);
        return true;
      } else {
        // Không tìm thấy người dùng
        return false;
      }
    } catch (e) {
      print("Lỗi khi tìm người dùng: $e");
      return false;
    }
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.7,
              width: double.infinity,
              child: _buildInputFields(),
            ),
            _buildSocialLogins(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return ClipPath(
      clipper: CustomClipperWidget(),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.green, Color.fromARGB(218, 239, 92, 135)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Sign in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 60),
              _buildTextField(emailController, Icons.person_outline, "Email"),
              const SizedBox(height: 20),
              _buildTextField(
                  passwordController, Icons.info_outline, "Password",
                  isPassword: true),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text("Sign Up"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //Login Button Pressed
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      print("Email : $email Password : $password");
                      if (passwordController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty) {
                        bool loginResult = await loginState(email, password);

                        if (loginResult) {
                          print("Đăng nhập thành công với ID bản ghi: $uid");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TestBottomNavWithAnimatedIcons(uid: uid),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Email hoặc mật khẩu không đúng"),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("LOGIN"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        const Text(
          "Or sign in with",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/icons/google.png",
                    width: 60, height: 60),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/icons/facebook.png",
                    width: 60, height: 60),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/icons/github.png",
                    width: 60, height: 60),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String hint,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
      obscureText: isPassword,
    );
  }
}
