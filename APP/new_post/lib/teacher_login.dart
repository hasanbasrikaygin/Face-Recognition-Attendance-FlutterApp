import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:new_post/inquiry_list_view.dart';
import 'package:new_post/show_attendance.dart';

// öğretmen giriş sayfası

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({super.key});

  @override
  State<TeacherLogin> createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  TextEditingController? userName = TextEditingController();
  TextEditingController? userPassword = TextEditingController();
  bool? isPassword = true;
  bool? isUserName = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TeacherInput(
              userName!, "Lütfen kullanıcı adınızı giriniz", isUserName!),
          TeacherInput(userPassword!, "Lütfen şifrenizi giriniz", isPassword!),
          ElevatedButton(
            onPressed: () {
              teacherAuthentication(
                  userName!.text, userPassword!.text, context);
            },
            child: Text("Giriş"),
          ),
        ],
      ),
    );
  }
}

Future<void> teacherAuthentication(
    String name, String password, BuildContext context) async {
  if (name == null || password == null) {
  } else {
    print(name);
    print(password);
    var url = Uri.parse('(url)/teacherAuthentication');
    // isteğin medya türü : json formatındadir
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'password': password,
    });
    // POST isteğinin gönderilmesi. // gönedrilecek veri
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String isTrueUser = data['result'];
      print(isTrueUser);
      print(isTrueUser.runtimeType);

      if (isTrueUser == "true") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowAttendace()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hata'),
            content: Text('Hatalı kullanıcı adı veya şifre'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tamam'),
              ),
            ],
          ),
        );
      }
    } else {
      print('API isteği başarısız oldu. Hata kodu: ${response.statusCode}');
    }
  }
}

TextField TeacherInput(TextEditingController controllerParameter,
    String labelText, bool isPassword) {
  return TextField(
    controller: controllerParameter,
    maxLength: 20,
    obscureText: isPassword,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: labelText,
      labelStyle: TextStyle(color: Color.fromRGBO(9, 154, 75, 1)),
      suffixIcon: Icon(
        Icons.keyboard_arrow_left_sharp,
      ),
    ),
  );
}
