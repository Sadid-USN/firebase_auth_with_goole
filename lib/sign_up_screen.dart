import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_with_firebase/main.dart';

class SigneUpScreen extends StatefulWidget {
  const SigneUpScreen({Key? key}) : super(key: key);

  @override
  State<SigneUpScreen> createState() => _SigneUpScreenState();
}

class _SigneUpScreenState extends State<SigneUpScreen> {
  late UserCredential userCredential;
  String? password, email;
  // GlobalKey<FormState> userNameFormState = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> emailFormState = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormState = GlobalKey<FormState>();
  signeUp() async {
    var emailFormData = emailFormState.currentState;
    var passwordFormData = passwordFormState.currentState;
    if (emailFormData!.validate()) {
      emailFormData.save();
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {}
      } catch (e) {
        print(e);
      }
    }

    if (passwordFormData!.validate()) {
      passwordFormData.save();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          // User name
          // Form(
          //   key: userNameFormState,
          //   child: Container(
          //     padding: const EdgeInsets.all(20),
          //     child: TextFormField(
          //       onSaved: (val) {
          //         userName = val;
          //       },
          //       validator: (val) {
          //         if (val!.length > 32) {
          //           return 'Username cannot be more than 32 characters';
          //         }
          //         if (val.isEmpty) {
          //           'this is a required field, it cannot be empty';
          //         }
          //         if (val.length < 3) {
          //           return 'Username cannot be less than 3 characters';
          //         }
          //         return null;
          //       },
          //       decoration: InputDecoration(
          //           hintText: 'User name',
          //           border: OutlineInputBorder(
          //               borderSide:
          //                   const BorderSide(color: Colors.white, width: 2),
          //               borderRadius: BorderRadius.circular(12.0)),
          //           prefixIcon: const Icon(Icons.person)),
          //       keyboardType: TextInputType.text,
          //     ),
          //   ),
          // ),

          //Email
          Form(
            key: emailFormState,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: emailController,
                onSaved: (val) {
                  email = val;
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    'this is a required field, it cannot be empty';
                  }
                  if (val.length > 32) {
                    return 'Email cannot be more than 32 characters';
                  }

                  if (val.length < 4) {
                    return 'Email cannot be less than 4 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12.0)),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ),

          // Password
          Form(
            key: passwordFormState,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: passwordController,
                onSaved: (val) {
                  password = val;
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    'this is a required field, it cannot be empty';
                  }
                  if (val.length > 32) {
                    return 'Password cannot be more than 32 characters';
                  }
                  if (val.length < 4) {
                    return 'Password cannot be less than 4 characters';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12.0)),
                  prefixIcon: const Icon(Icons.remove_red_eye),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('If you have an account',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: 'Click here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ))
                    ]))),
              ],
            ),
          ),

          // BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: MaterialButton(
              colorBrightness: Brightness.light,
              color: Colors.blue,
              onPressed: () async {
                UserCredential response = await signeUp();
                // ignore: avoid_print
                print('====================');
                Navigator.of(context).pushNamed('loginScreen');
                print('====================');
              },
              child: const Text('Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
