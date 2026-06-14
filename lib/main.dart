import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timeago_flutter/timeago_flutter.dart' as timeago;
import 'package:tourism_app/Constans.dart';
import 'package:tourism_app/Screens/splash_screen.dart';
import 'package:tourism_app/cubits/ChangeLanguagCubit.dart';
import 'package:tourism_app/cubits/Favourite_screen_cubit.dart/Favourite_screen_cubit.dart';
import 'package:tourism_app/cubits/Feed_screen_cubit/Feed_screen_cubit.dart';
import 'package:tourism_app/cubits/likeCommentCubit.dart';
import 'package:tourism_app/firebase_options.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider(create: (_) => Likecommentcubit()..setplaces()),
        BlocProvider(create: (_) => Changelanguagcubit()),

        //  Add more cubits here later
        // BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Changelanguagcubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          locale: locale,
          debugShowCheckedModeBanner: false,

          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: ThemeData(
            fontFamily: 'Cairo',

            ///  Main brand color
            primaryColor: primaryColor,

            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              primary: primaryColor,
            ),

            ///  Cursor + selection colors
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: primaryColor,
              selectionColor: Color(0x552E7D32), // light green highlight
              selectionHandleColor: primaryColor,
            ),

            ///  Input fields theme (VERY IMPORTANT)
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              floatingLabelStyle: TextStyle(color: primaryColor),
            ),

            ///  Optional consistency (loading indicators)
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: primaryColor,
            ),

            ///  Optional buttons consistency
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            ),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}
