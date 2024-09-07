import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // 비밀번호 보이기/숨기기 상태

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      print('로그인 시도 중...'); // 디버깅용

      try {
        await Provider.of<LoginProvider>(context, listen: false)
            .signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        print('로그인 성공, /chat으로 이동'); // 디버깅용
        Navigator.pushReplacementNamed(context, '/chat');
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException 발생: ${e.message}'); // 디버깅용
        String message;
        if (e.code == 'user-not-found') {
          message = '등록된 이메일이 없습니다.';
        } else if (e.code == 'wrong-password') {
          message = '비밀번호가 잘못되었습니다.';
        } else {
          message = '로그인 오류: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        print('예상치 못한 오류 발생: $e'); // 디버깅용
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 중 오류 발생')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        centerTitle: true, // 제목을 중앙에 정렬
        backgroundColor: Color(0xFFffe53b), // 밝은 노란색
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 요소들을 위쪽으로 배치
          children: [
            SizedBox(height: 5), // 상단 여백 추가
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
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
                    controller: _emailController,
                    cursorColor: Colors.black, // 커서 색상
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '이메일을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10), // 입력 필드 간의 간격
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // 포커스 시 밑부분 색상
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), // 비활성화 상태 밑부분 색상
                      ),
                      labelStyle: TextStyle(color: Colors.black), // 라벨 텍스트 색상
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                    obscureText: _obscurePassword, // 비밀번호 입력 시 텍스트 숨김
                    cursorColor: Colors.black, // 커서 색상
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '비밀번호를 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20), // 버튼과 입력 필드 간의 간격
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 배경색
                      foregroundColor: Colors.white, // 텍스트 색상
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Signup'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // 텍스트 색상
              ),
            ),
          ],
        ),
      ),
    );
  }
}
