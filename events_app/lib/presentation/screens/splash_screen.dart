import 'package:events_app/presentation/screens/admin_homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:events_app/presentation/screens/sign_in_screen.dart';
import 'package:events_app/presentation/screens/events_screen.dart';
import 'package:events_app/utils/auth_utils.dart'; // Ensure this import is correct

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    // Check if user is logged in and navigate accordingly
    bool isLoggedIn = await AuthUtils.isLoggedIn();
    if (isLoggedIn) {
      if (await AuthUtils.getUserRole(AuthUtils.getToken()) == 'admin') {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) =>
                const AdminHomePage())); // Go to events screen if logged in
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) =>
                const EventsScreen())); // Go to events screen if logged in
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) =>
              SignInScreen())); // Go to sign in screen if not logged in
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.purple]),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Taatee',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    )),
                Text('Your event tracker!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    )),
              ],
            )));
  }
}
