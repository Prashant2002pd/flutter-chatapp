import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test3/pages/homepage.dart';
import 'package:test3/pages/login.dart';
import 'package:test3/services/authservice.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<StatefulWidget> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final conformpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Signup',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Icon( Icons.lock, size: 100, color: Theme.of(context).colorScheme.secondary),
                 
                  const SizedBox(height: 20),
                 
                  //username textfield
                   TextFormField(
                      controller: usernameController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 5.0),
                        ),
                        labelText: 'Username',
                      ),
                  ),
                      
                  const SizedBox(height: 20),
              
                  //email textfield
                     TextFormField(
                      validator: (value){
              
                         const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                final regex = RegExp(pattern);
              
                        if(value!.isEmpty){
                          return 'Please enter email';
                        }
                        if(!regex.hasMatch(value)){
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: const InputDecoration(
                        border:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 5.0),
                        ),
                        labelText: 'Email',
                      ),
                  ),
                      
                  const SizedBox(height: 20),
              
                  //password textfield
                  TextFormField(
                    validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter password';
                        }
                        if(value.length < 6){
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                    },
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 5.0),
                        ),
                        labelText: 'Password',
                      ),
                  ),
                      
                  const SizedBox(height: 20),
              
                  //conform password textfield
                  TextFormField(
                    validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter password';
                        }
                        if(value != passwordController.text){
                          return 'Password does not match';
                        }
                        return null;
                    },
                      controller: conformpasswordController,
                      decoration: const InputDecoration(
                        border:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 5.0),
                        ),
                        labelText: 'Conform Password',
                      ),
                  ),
                      
                  const SizedBox(height: 20),
              
                
              
                  //Signup button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            UserCredential? userCredential = await AuthService()
                                .signUpWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
              
                            AuthService().createUserDocument(
                                userCredential, usernameController.text);
              
                            await Future.delayed(const Duration(seconds: 1));
              
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()));
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
                          child: const Text("Signup"),
                        )),
                  ),
              
                  const SizedBox(height: 10),
              
                  //already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: const Text('Login'),
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
