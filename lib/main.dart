import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signin_with_firebase/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "loginScreen": (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> emailFormState = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormState = GlobalKey<FormState>();
  String? email;
  String? password;
  signInWithEmail() async {
    var emailFormData = emailFormState.currentState;
    var passwordFormData = passwordFormState.currentState;
    if (emailFormData!.validate()) {
      emailFormData.save();
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            body: const Center(
              child: Text(
                'Пользователь с этим лектронным\nадресом не найден',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'ptSerif'),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.ERROR,
            body: const Center(
              child: Text(
                'Вы ввели неверный пароль',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          ).show();
          print('Wrong password provided for that user.');
        }
      }
    }
    if (passwordFormData!.validate()) {
      passwordFormData.save();
    } else {
      print(userCredential!.user!.email);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  UserCredential? userCredential;
  bool _rememberMe = false;
  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Form(
          key: emailFormState,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60,
            child: TextFormField(
              controller: emailController,
              onSaved: (val) {
                email = val;
              },
              validator: (val) {
                if (val!.length > 32) {
                  return 'Email cannot be more than 32 characters';
                }
                if (val.isEmpty) {
                  'this is a required field, it cannot be empty';
                }
                if (val.length < 4) {
                  return 'Password cannot be less than 4 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.white60),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
              ),
              keyboardType: TextInputType.text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Form(
          key: passwordFormState,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60,
            child: TextFormField(
              controller: passwordController,
              onSaved: (val) {
                password = val;
              },
              validator: (val) {
                if (val!.length > 32) {
                  return 'Password cannot be more than 32 characters';
                }
                if (val.isEmpty) {
                  'this is a required field, it cannot be empty';
                }
                if (val.length < 4) {
                  return 'Password cannot be less than 3 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.white60),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: MaterialButton(
          padding: const EdgeInsets.only(right: 0.0),
          onPressed: () {},
          child: const Text(
            'Forgot Password?',
            style: kLabelStyle,
          )),
    );
  }

  Widget _buildRememberCheckbox() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 20.0,
      child: Row(
        children: [
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _rememberMe,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value!;
                  });
                },
              )),
          const Text(
            'Remember me',
            style: kLabelStyle,
          )
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: MaterialButton(
        color: Colors.white,
        elevation: 5.0,
        // ignore: void_checks
        onPressed: () async {
          await signInWithEmail();

          return AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.INFO_REVERSED,
            body: const Center(
              child: Text(
                'Вход успешно завершён',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            title: 'This is Ignored',
            desc: 'This is also Ignored',
            btnOkOnPress: () {},
          ).show();
        },
        padding: const EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: const Text(
          'LOGIN ',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color(0xFF527DAA)),
        ),
      ),
    );
  }

  Widget _buildSignWith() {
    return Column(
      children: const [
        Text(
          '- OR -',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Sign in with',
          style: kLabelStyle,
        )
      ],
    );
  }

  _buildSignUpWithGoogle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              userCredential = await FirebaseAuth.instance.signInAnonymously();
              print(userCredential!.user!.uid);
            },
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  image: DecorationImage(
                      image: AssetImage('images/anonymous.png'))),
            ),
          ),
          GestureDetector(
            onTap: () async {
              userCredential = await signInWithGoogle();
              print(userCredential);
            },
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  image:
                      DecorationImage(image: AssetImage('images/google.jpg'))),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('Login with Facebook');
            },
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  image: DecorationImage(
                      image: AssetImage('images/facebook.jpg'))),
            ),
          ),
          GestureDetector(
            onTap: () => print('Login with Twitter'),
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                  image:
                      DecorationImage(image: AssetImage('images/twitter.png'))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp() {
    return GestureDetector(
        onTap: () async {
          try {
            userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: "ulamuyaman@gmail.com", password: "123459090123");
            // print(userCredential);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              User? user = FirebaseAuth.instance.currentUser;
              if (userCredential!.user!.emailVerified == false) {
                await user!.sendEmailVerification();
                print(userCredential!.user!.email);
              }
            } else if (e.code == 'email-already-in-use') {}
          } catch (e) {
            print(e);
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Dont\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              )),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SigneUpScreen();
              }));
            },
            child: const Text('Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                        stops: [
                      0.1,
                      0.4,
                      0.7,
                      0.9
                    ])),
              ),
              // ignore: sized_box_for_whitespace
              Container(
                // color: Colors.lime,
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          //fontFamily: 'OpenSans'
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildEmail(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildPassword(),
                      _buildForgotPassword(),
                      _buildRememberCheckbox(),
                      _buildLoginButton(),
                      _buildSignWith(),
                      _buildSignUpWithGoogle(),
                      _buildSignUp(),
                    ],
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

// CONSTANS FILE

const kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
