import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool show = true;
  Color color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (show) GestureDetector(
              onTap: (){
                setState(() {
                  color = color == Colors.blue ? Colors.red : Colors.blue;
                });
              },
              child: TestWidget(
                color: color,
              ),
            ), //'show' 값이 true일 때만 TestWidget을 보여줌
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // show = show == true ? falase : true;
                  show = !show; // 위 코드를 간단하게 true/false 전환으로 수정
                });
              },
              child: Text('보이기/안 보이기'),
            ),
          ],
        ),
      ),
    );
  }
}

class TestWidget extends StatefulWidget {
  final Color color;

  TestWidget({
    required this.color,
      super.key}) {
    print('1) Stateful Widget Constructor');
  }

  @override
  State<TestWidget> createState() {
    print('2) Stateful Widget Create State');
    return _TestWidgetState();
  }
}

class _TestWidgetState extends State<TestWidget> {

  @override
  void initState() {
    print('3) Stateful Widget initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('4) Stateful Widget didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('5) Stateful Widget build');
    return Container(
      color: widget.color,
      width: 50,
      height: 50,
    );
  }

  @override
  void deactivate() {
    print('6) Stateful Widget deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('7) Stateful Widget dispose');
    super.dispose();
  }
}
