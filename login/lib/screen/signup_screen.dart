import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('비밀번호가 다릅니다.')));
        return;
      }
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        var db = FirebaseFirestore.instance;

        final user = <String, String>{
          "name": _nameController.text,
          "email": _emailController.text,
        };

        credential.user!.sendEmailVerification();

        await db
            .collection("users")
            .doc(credential.user!.uid)
            .set(user)
            .onError((e, _) => print("Error writing document: $e"));
        Navigator.pushNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
        centerTitle: true, // 제목을 중앙에 정렬
        backgroundColor: Color(0xFFffe600), // 밝은 노란색
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 포커스 시 밑부분 색상
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 비활성화 상태 밑부분 색상
                  ),
                  labelStyle: TextStyle(color: Colors.black), // 라벨 텍스트 색상
                ),
                cursorColor: Colors.black, // 커서 색상
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 포커스 시 밑부분 색상
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 비활성화 상태 밑부분 색상
                  ),
                  labelStyle: TextStyle(color: Colors.black), // 라벨 텍스트 색상
                ),
                cursorColor: Colors.black, // 커서 색상
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 포커스 시 밑부분 색상
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 비활성화 상태 밑부분 색상
                  ),
                  labelStyle: TextStyle(color: Colors.black), // 라벨 텍스트 색상
                ),
                obscureText: true,
                cursorColor: Colors.black, // 커서 색상
                validator: (value) {
                  if (value!.isEmpty) {
                    return '패스워드를 입력해주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 포커스 시 밑부분 색상
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // 비활성화 상태 밑부분 색상
                  ),
                  labelStyle: TextStyle(color: Colors.black), // 라벨 텍스트 색상
                ),
                obscureText: true,
                cursorColor: Colors.black, // 커서 색상
                validator: (value) {
                  if (value!.isEmpty) {
                    return '패스워드를 확인해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                child: Text('Signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 배경색
                  foregroundColor: Colors.white, // 텍스트 색상
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}