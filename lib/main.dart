import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journalia/Pages/CreatePost/new_post.dart';
import 'package:journalia/Pages/Home/home_page.dart';
import 'package:journalia/Pages/Login/login_page.dart';
import 'package:journalia/Pages/splash_screen.dart';
import 'package:journalia/firebase_options.dart';
import 'package:journalia/log_page.dart';
import 'package:journalia/providers/article_provider.dart';
import 'package:provider/provider.dart';
import 'Pages/Feed/feed_page.dart';
import 'Pages/Profile/profile.dart';
import 'Providers/topic_provider.dart';
import 'Providers/user_provider.dart';
import 'Providers/vote_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
        ChangeNotifierProvider(create: (_) => TopicProvider()),
        ChangeNotifierProvider(create: (_) => VotesProvider()),
        // Add more providers as needed
      ],
      child: MaterialApp(
        
        theme: ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const Splash(), // Specify initial route
        routes: {

          '/login': (context) => const Login(),
          '/home': (context) => const HomePage(),
          '/feed': (context) => const FeedPage(),
          '/createpost': (context) => const CreatePostPage(),
          '/profile': (context) => const Profile(),
          '/Log': (context) =>  LogPage(errorLogs: LogData.errorLogs, debugLogs: LogData.debugLogs)
          // Add more routes as needed
        },
      ),
    );
  }
}
