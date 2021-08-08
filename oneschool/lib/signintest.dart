//import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'rooms.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'main.dart';

class CurrentTheme {
  final String name;
  final ThemeData data;

  const CurrentTheme(this.name, this.data);
}

class LoginDesign5Theme {
  static const _lightFillColor = Colors.black;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
  themeData(lightColorScheme, _lightFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textTheme,
      iconTheme: IconThemeData(color: Colors.white),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      accentColor: colorScheme.primary,
      focusColor: Colors.white,
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFFFF6673),
    primaryVariant: Color(0xFF117378),
    secondary: Color(0xFFEFF3F3),
    secondaryVariant: Color(0xFFFAFBFB),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const _superBold = FontWeight.w900;
  static const _bold = FontWeight.w700;
  static const _semiBold = FontWeight.w600;
  static const _medium = FontWeight.w500;
  static const _regular = FontWeight.w400;
  static const _light = FontWeight.w300;

  static final TextTheme _textTheme = TextTheme(
    headline1: GoogleFonts.roboto(
      fontSize: 96,
      color: Colors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headline2: GoogleFonts.poppins(
      fontSize: 60,
      color: Colors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headline3: GoogleFonts.poppins(
      fontSize: 48,
      color: Colors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headline4: GoogleFonts.poppins(
      fontSize: 34,
      color: Colors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headline5: GoogleFonts.poppins(
      fontSize: 24,
      color: Colors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headline6: GoogleFonts.poppins(
      fontSize: 20,
      color: Colors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    subtitle1: GoogleFonts.poppins(
      fontSize: 16,
      color: Colors.black,
      fontWeight: _semiBold,
      fontStyle: FontStyle.normal,
    ),
    subtitle2: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black,
      fontWeight: _semiBold,
      fontStyle: FontStyle.normal,
    ),
    bodyText1: GoogleFonts.poppins(
      fontSize: 16,
      color: Colors.black,
      fontWeight: _light,
      fontStyle: FontStyle.normal,
    ),
    bodyText2: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black,
      fontWeight: _light,
      fontStyle: FontStyle.normal,
    ),
    button: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black,
      fontStyle: FontStyle.normal,
      fontWeight: _medium,
    ),
    caption: GoogleFonts.poppins(
      fontSize: 12,
      color: Colors.white,
      fontWeight: _regular,
      fontStyle: FontStyle.normal,
    ),
  );
}


class ThemeBloc {
  final Stream<ThemeData> themeDataStream;
  final Sink<CurrentTheme> selectedTheme;

  factory ThemeBloc() {
    final selectedTheme = PublishSubject<CurrentTheme>();
    final themeDataStream = selectedTheme.distinct().map((theme) => theme.data);
    return ThemeBloc._(themeDataStream, selectedTheme);
  }

  const ThemeBloc._(this.themeDataStream, this.selectedTheme);

  CurrentTheme initialTheme() {
    return CurrentTheme('initial', LoginDesign5Theme.lightThemeData);
  }
}


class SignUp4 extends StatefulWidget {
  SignUp4({required this.themeBloc});

  ThemeBloc themeBloc;

  @override
  _SignUp4State createState() => _SignUp4State();
}

customBorder({
  Color color = const Color(0xFF606060),
  double width = 1.0,
  BorderStyle style = BorderStyle.solid,
}) {
  return BorderSide(
    color: color,
    width: width,
    style: style,
  );
}


class CustomButton extends StatelessWidget {
  CustomButton({
    required this.title,
    this.onPressed,
//    this.width = Sizes.WIDTH_150,
    this.height = 50.0,
    this.elevation = 1.0,
    this.borderRadius = 24.0,
    this.color = const Color(0xFF323345),
    this.borderSide = const BorderSide(width: 0, style: BorderStyle.none),
    required this.textStyle,
    required this.icon,
    this.hasIcon = false,
  });

  final Function()? onPressed;
  final double height;
  final double elevation;
  final double borderRadius;
  final String title;
  final Color color;
  final BorderSide borderSide;
  final TextStyle textStyle;
  final Widget icon;
  final bool hasIcon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
//      minWidth: width ?? MediaQuery.of(context).size.width,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSide,
      ),

      height: height,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hasIcon ? icon : Container(),
          hasIcon ? SizedBox(width:8.0) : Container(),
          title != null
              ? Text(
            title,
            style: textStyle,
          )
              : Container(),
        ],
      ),
    );
  }
}

class Decorations {
  static customBoxDecoration({
    double blurRadius = 5,
    Color color = const Color(0xFFD6D7FB),
  }) {
    return BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: blurRadius, color: color)]);
  }
}


class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
        (route)=>false
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
        if (user != null) {
          print(user.email);
          print(user.email!.split('@')[1] == 'iusd.org' ? 'in iusd' : 'outside iusd');
          print(num.tryParse(user.email!.substring(0,2)) != null ? 'student' : 'not student');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MyApp()
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}




class _SignUp4State extends State<SignUp4> {
  @override
  void initState() {
    super.initState();
    widget.themeBloc.selectedTheme.add(_buildLightTheme());
  }

  CurrentTheme _buildLightTheme() {
    return CurrentTheme('light', LoginDesign5Theme.lightThemeData);
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              Spacer(flex: 1),
              Icon(
                Icons.facebook,
                size: 200,
                color: Color(0xFF4045EE),
              ),
              Spacer(flex: 1),
              Text(
                'Sign Up',
                style: theme.textTheme.headline5!.copyWith(
                  color: Colors.black,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child:
                Text(
                  'OneSchool is currently open for popular consumption for students, parents, and coaches attending University High School. An iusd.org Google account is required unless you\'re joining a parent chat.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.subtitle2!.copyWith(
                      color: Color(0xFFA3A3A3), fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(flex: 1),
              Container(
                decoration: Decorations.customBoxDecoration(blurRadius: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                child:

                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return CustomButton(
                        title: 'Continue with Google',
                        elevation: 12.0 ,
                        hasIcon: true,
                        icon: Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        color: Color(0xFF4045EE),
                        textStyle: theme.textTheme.button!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                        onPressed: () {
                          Authentication.signInWithGoogle(context: context);
                        },
                      );
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4045EE),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: CustomButton(
                  title: 'Email sign up coming soon!',
                  elevation: 2.0,
                  color: Colors.white,
                  borderSide: customBorder(width: 1.5),
                  textStyle: theme.textTheme.button!.copyWith(
                      color: Color(0xFF606060),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0),
                  icon: Container(),
                  //onPressed: () => ExtendedNavigator.root.push(Routes.signUpScreen4),
                ),
              ),

              Spacer(flex: 1),
              /*
              InkWell(
                onTap: () => ExtendedNavigator.root.push(Routes.loginScreen4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: StringConst.ALREADY_HAVE_AN_ACCOUNT,
                          style: theme.textTheme.subtitle.copyWith(
                            color: AppColors.greyShade8,
                            fontSize: Sizes.TEXT_SIZE_14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text: StringConst.LOG_IN_2,
                            style: theme.textTheme.subtitle.copyWith(
                              color: AppColors.purple,
                              fontSize: Sizes.TEXT_SIZE_14,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              */
              Spacer(flex: 1),

            ],
          ),
        ),
      ),
    );
  }
}
