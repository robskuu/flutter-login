import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/main.dart';
import 'package:hive_flutter/adapters.dart';

class LoggedIn extends StatefulWidget {
  final String username;
  final bool mode;
  const LoggedIn({super.key, required this.username, required this.mode});

  @override
  State<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  bool darkMode = false;
  Color bgColor = Colors.white;
  @override
  void initState() {
    super.initState();
    initHive();
    darkMode = widget.mode;
    bgColor = darkMode ? Colors.black : Colors.white;
  }

  // Initialize Hive
  void initHive() async {
    await Hive.initFlutter();
    await Hive.openBox("users");
  }

  void deleteAccount() async {
    var box = Hive.box("users");
    box.delete(widget.username);
    Navigator.pop(context);
  }

  void _darkMode() {
    bgColor = darkMode ? Colors.white : Colors.black;
    setState(() {
      darkMode = !darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Logged In',
          style: TextStyle(
            color: darkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Welcome ${widget.username}!",
              style: TextStyle(
                color: darkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(context);
              },
              child: const Text('Log out'),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                deleteAccount();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const SizedBox(
                width: 170,
                child: Row(
                  children: [
                    Expanded(
                      child: Text("Delete Account"),
                    ),
                    Expanded(
                      flex: 0,
                      child: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
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
