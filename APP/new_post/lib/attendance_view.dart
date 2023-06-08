import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_post/Widget/loading_widget.dart';
import 'main.dart';

// Yoklama alma işlemi için ders - tarih - öğrenci fotoğrafı bilgileriini post eder

class AttendanceView extends StatefulWidget {
  int? selectedLessonId;

  AttendanceView({Key? key, this.selectedLessonId}) : super(key: key);

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  final _url = "https://5ebd-88-227-94-145.eu.ngrok.io/upload";
  File? selectedImage;
  String? message = "";
  bool isLoading = false;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isLoading
              ? LoadingWidget()
              : ElevatedButton.icon(
                  onPressed: uploadImage,
                  label: Text("Yoklama Al"),
                  icon: Icon(Icons.camera_alt_outlined),
                ),
          SizedBox(height: 10),
          Center(child: Text(message ?? "")),
        ],
      ),
    );
  }

  Future<void> uploadImage() async {
    // kamera butonuna basmadan önce ders seçimi kontrolü sağlanır
    if (widget.selectedLessonId == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Lütfen bölümünüzü ve dersinizi seçiniz.'),
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
      print(now);
      print("+++++");
      print(widget.selectedLessonId);
      print("+++++");
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      //Kullanıcının kameradan bir resim seçmesini bekler
      // seçilen resmi pickedImage değişkenine atar.
      if (pickedImage != null) {
        setState(() {
          // seçilen resmin değişkene atanması
          selectedImage = File(pickedImage.path);
          message = "";
          isLoading = true;
        });
      }

      if (selectedImage == null) {
        //
        setState(() {
          message = "Lütfen yeniden fotoğraf çekiniz";
        });
        return;
      }

      setState(() {
        message = "Yoklama işlemi gerçekleştiriliyor . Lütfen bekleyiniz .";

        print(widget.selectedLessonId);
      });

      // belirtilen URL'ye çok parçalı bir bir HTTP isteği
      //göndermek için kullanılır
      final request = http.MultipartRequest("POST", Uri.parse(_url));
      // çekilen fotoğrafı request nesnesine ekler
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        selectedImage!.path,
      ));
      // ders_id si ve yoklamanın alındığı zamanın eklenmesi
      request.fields['lessonNumber'] = widget.selectedLessonId.toString();
      request.fields['attendanceTime'] = now.toString();

      try {
        final response = await request.send();
        // sunucudan dönen yanıt başarılıysa
        if (response.statusCode == 200) {
          print(widget.selectedLessonId);
          //Sunucudan dönen yanıtın içeriği alnır
          //bytesToString() ile yanıtın
          //byte verilerini alır ve bunları bir dizeye dönüştürülür.
          final resJson = jsonDecode(await response.stream.bytesToString());
          setState(() {
            message = resJson['message'];
            isLoading = false;
          });
        } else {
          setState(() {
            message =
                "Resim yükleme hatası oluştu. Status code: ${response.statusCode}";
          });
        }
      } catch (error) {
        setState(() {
          message = "Resim yükleme hatası oluştu : $error";
        });
      }
    }
  }
}
