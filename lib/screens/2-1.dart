import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여기서 출발해요!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '출발하는 장소를 작성해주세요.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '장소를 입력하세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '장소를 입력해 주세요';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20), // 버튼과 입력창 사이의 간격
            ElevatedButton(
              onPressed: () {
                // 폼 검증 및 저장 로직
                if (_formKey.currentState!.validate()) {
                  // 검증 성공 시 처리할 내용
                  // 예를 들어, 입력된 장소 출력
                  String location = _locationController.text;
                  print('입력된 장소: $location');
                }
              },
              child: Text('다음 →', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}