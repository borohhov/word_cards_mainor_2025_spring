import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'views/connectivity_banner.dart';
import 'views/home_page.dart';
import 'providers/word_card_list_provider.dart';   // <-- ADD THIS
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Tell Firebase UI which auth flows you want.
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),          // <-- email + password
    // GoogleProvider(clientId: ‘…’),  // add more when you need them
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => WordCardListProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Cards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // StreamBuilder decides whether to show the sign-in UI or your app.
      home: ConnectivityBanner(child:  AuthGate()),
    );
  }
}

/// Shows [SignInScreen] until the user is authenticated.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Not signed in → present the pre-built email/password screen.
          return SignInScreen(
            providers: [EmailAuthProvider()],
          );
        }
        // Signed in → continue to your real UI.
        return const HomePage();
      },
    );
  }
}
