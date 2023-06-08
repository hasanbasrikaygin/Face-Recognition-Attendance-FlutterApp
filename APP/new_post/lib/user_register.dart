import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_post/Widget/loading_widget.dart';
import 'dart:convert';
import 'main.dart';

// ad , soyad , numara ve fotoğraf bilgilerine göre öğrenci kayıt sayfası

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _url = "(url)/createUser";
  File? selectedImage;
  String? message = "";
  bool isLoading = false;
  TextEditingController? number = TextEditingController();
  TextEditingController? name = TextEditingController();
  TextEditingController? surname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/kou.png",
          width: 150,
          height: 250,
        ),
        Center(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 8, left: 8, right: 8),
                    child: UserInput(name!, "Lütfen adınızı giriniz"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserInput(surname!, "Lütfen soyadınızı giriniz"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 8, left: 8, right: 8),
                    child: UserInput(number!, "Lütfen okul numaranızı giriniz"),
                  ),
                  isLoading
                      ? LoadingWidget()
                      : ElevatedButton.icon(
                          onPressed: () {
                            if (name!.text.isEmpty ||
                                surname!.text.isEmpty ||
                                number!.text.isEmpty ||
                                int.tryParse(number!.text) == null ||
                                number!.text.length != 9) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Hata'),
                                    content: Text(
                                        'Lütfen tüm alanları eksiksiz doldurun.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Tamam'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              uploadUser();
                            }
                          },
                          label: Text("Yüz Kayıt"),
                          icon: Icon(Icons.camera_alt_outlined),
                        ),
                  SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text(message ?? "")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextField UserInput(
      TextEditingController controllerParameter, String labelText) {
    return TextField(
      controller: controllerParameter,
      maxLength: 20,
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

  Future<void> getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
        message = "";
      });
    }
  }

  int _selectedIndex = 0;
  String kullaniciSecimi = "";
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> uploadUser() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
        message = "";
        isLoading = true;
      });
    }

    if (selectedImage == null || name == null || surname == null) {
      setState(() {
        message = "Lütfen gerekli bilgileri tam doldurunuz";
      });
      return;
    }

    setState(() {
      message =
          "Kullanıcı kayıt işlemi geçekleştiriliyor . Lütfen bekleyiniz . ";
    });
    // belirtilen URL'ye çok parçalı bir bir HTTP isteği
    //göndermek için kullanılır
    final request = http.MultipartRequest("POST", Uri.parse(_url));
    // çekilen fotoğrafı request nesnesine ekler
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      selectedImage!.path,
    ));
    // Metin verilerini isteğe ekler
    request.fields['name'] = name!.text;
    request.fields['surname'] = surname!.text;
    request.fields['number'] = number!.text;
    try {
      final response = await request.send();
      // sunucudan dönen yanıt başarılıysa
      if (response.statusCode == 200) {
        final resJson = jsonDecode(await response.stream.bytesToString());
        //bytesToString() ile yanıtın
        //byte verilerini alır ve bunları message değişkenine atar  .
        setState(() {
          message = resJson['message'];
          isLoading = false;
        });
      } else {
        setState(() {
          message =
              "Resim yükleme hatası oluştu Status code: ${response.statusCode}";
        });
      }
    } catch (error) {
      setState(() {
        message = "Resim yükleme hatası oluştu $error";
      });
    }
  }
}
