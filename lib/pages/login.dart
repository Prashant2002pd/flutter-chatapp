import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test3/pages/signup.dart';
import 'package:test3/pages/homepage.dart';
import 'package:test3/services/authservice.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<StatefulWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

//dialog box for invalid login
  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Invalid email or password'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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
     
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20),

                  Icon( Icons.lock, size: 100, color: Theme.of(context).colorScheme.secondary),

                  const SizedBox(height: 20),

                   TextFormField(
                      controller: emailController,
                      validator: (value) {
              
                        
                         const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                final regex = RegExp(pattern);
              
              
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
              
                        if (!regex.hasMatch(value)) {
                          return 'Please enter valid email';
                        }
              
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 5.0),
                        ),
                        labelText: 'Email',
                      ),
                  ),
              
                  const SizedBox(height: 20),
              
                  TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter password';
                        }
                        if(value.length < 6){
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 5.0),
                        ),
                        labelText: 'Password',
                      ),
                  ),
              
                  const SizedBox(height: 1),
                      
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          //forgot password screen
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                      
                  const SizedBox(height: 20),
                      
              
                  //login button
                  SizedBox(
                    width: double.infinity,
                      
                    child: ElevatedButton(
                        onPressed: () async {
                        
                          if(_formKey.currentState!.validate()){
                            try {
                            UserCredential? userCredential= await AuthService().signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                            if(UserCredential != null){
                            print("Login Success");
                             await Future.delayed(const Duration(seconds: 1));
                              
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Homepage()));
                          }
                          } catch (e) {
                            _showMyDialog();
                          }
                          }
                           
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textStyle:
                                const TextStyle(color: Colors.white, fontSize: 20),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text("Login"),
                        )
                      ),
                  ),
                      
                  const SizedBox(height: 10),
                      
                  //already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          //signup screen
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Signup()));
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                      
                ],
              ),
            ),
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
