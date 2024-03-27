// import 'package:flutter_login/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'pages/logged_in.dart';
import 'package:hive_flutter/adapters.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  String username = '';
  bool login = true;
  String state = 'login';
  bool darkMode = false;
  Color bgColor = Colors.white;
  Map<String, Map> text = {
    "login": {
      "title": "Login",
      "toggle": "Not a member?",
      "toggleButton": "Sign Up",
      "error": "Incorrect username or password",
    },
    "signup": {
      "title": "Sign Up",
      "toggle": "Already a member?",
      "toggleButton": "Login",
      "error": "Username already exists",
    }
  };

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initHive();
  }

  // Initialize Hive
  void initHive() async {
    await Hive.initFlutter();
    await Hive.openBox("users");
  }

  bool checkUser(String username, String password) {
    if (Hive.box("users").get(username) == username &&
        Hive.box("users").values.first == password) {
      return true;
    } else {
      return false;
    }
  }

  void signUp(String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      _dialog("Please fill in all fields");
    } else if (Hive.box("users").get(username) == null) {
      Hive.box("users").put(username, password);
      username = usernameController.text;
      usernameController.clear();
      passwordController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoggedIn(
            username: username,
            mode: darkMode,
          ),
        ),
      );
    } else {
      _dialog("${text[state]?['error']}");
    }
  }

  void _darkMode() {
    bgColor = darkMode ? Colors.white : Colors.black;
    setState(() {
      darkMode = !darkMode;
    });
  }

  void _toggle() {
    setState(() {
      state = state == 'login' ? 'signup' : 'login';
    });
  }

  void _login() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _dialog("Please fill in all fields");
    } else if (checkUser(usernameController.text, passwordController.text)) {
      username = usernameController.text;
      usernameController.clear();
      passwordController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoggedIn(
            username: username,
            mode: darkMode,
          ),
        ),
      );
    } else {
      _dialog("${text[state]?['error']}");
    }
  }

  void _dialog(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(103, 80, 164, 1),
        title: const Text(
          'Error',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
        title: Text(
          "${text[state]?['title']}",
          style: TextStyle(
            color: darkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                  )),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              child: TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  darkMode ? Colors.white : Colors.black,
                ),
                foregroundColor: MaterialStateProperty.all(
                  darkMode ? Colors.black : Colors.white,
                ),
              ),
              onPressed: () {
                if (state == 'login') {
                  _login();
                } else {
                  signUp(usernameController.text, passwordController.text);
                }
              },
              child: Text("${text[state]?['title']}"),
            ),
            const SizedBox(height: 50),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(103, 80, 164, 1),
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.all(7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login with:",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          // Google AUTH
                        },
                        child: Image.network(
                          'https://static-00.iconduck.com/assets.00/google-icon-2048x2048-czn3g8x8.png',
                          width: 30,
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Facebook AUTH
                      },
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/1024px-2021_Facebook_icon.svg.png',
                        width: 30,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Github AUTH
                      },
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${text[state]?['toggle']}",
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    usernameController.clear();
                    passwordController.clear();
                    _toggle();
                  },
                  child: Text(
                    "${text[state]?['toggleButton']}",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                Switch(
                  value: darkMode,
                  onChanged: (value) {
                    _darkMode();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
