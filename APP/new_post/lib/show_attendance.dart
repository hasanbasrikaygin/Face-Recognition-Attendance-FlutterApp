import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:new_post/inquiry_list_view.dart';
import 'package:new_post/week_list_view.dart';
import 'department.dart';

// ders kaydı oluşturma
//oluşturulan ders kayıtlarını görüntüleme
//belirlenen tarihler arası yoklamayı görüntüleme

class ShowAttendace extends StatefulWidget {
  const ShowAttendace({super.key});

  @override
  State<ShowAttendace> createState() => _ShowAttendaceState();
}

class _ShowAttendaceState extends State<ShowAttendace> {
  DateTime dateTime = DateTime(2023, 06, 5, 5, 20);
  DateTime secondDateTime = DateTime(2023, 06, 5, 5, 22);
  DateTime startTime = DateTime(2023, 06, 5, 5, 20);
  DateTime finishTime = DateTime(2023, 06, 5, 5, 22);

  String? textValueLesson;
  String? textValueWeek;
  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerWeek = TextEditingController();
  List<String> items = [];

  @override
  //initState widget'ın başlatılması sırasında çağrılır.
  void initState() {
    for (var department in Department.departmentButton) {
      for (var lesson in department.lessons!) {
        items.add(lesson.name!);
        // ders seçimi için ders adlarının listeye eklenmesi
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    final hoursSecond = secondDateTime.hour.toString().padLeft(2, '0');
    final minutesSecond = secondDateTime.minute.toString().padLeft(2, '0');
    List<String>? attendance = [];

    return Scaffold(
        appBar: AppBar(
          title: Text("Öğretmen"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                        Text("Lütfen Başlangıç ve Bitiş Tarihlerini seçiniz.")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 30.0),
                      child: ElevatedButton(
                          onPressed: pickDateTime,
                          child: Text(
                              "${dateTime.year}/${dateTime.month}/${dateTime.day}-${hours}:${minutes}")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 30.0),
                      child: ElevatedButton(
                          onPressed: pickDateTimeSecond,
                          child: Text(
                              "${secondDateTime.year}/${secondDateTime.month}/${secondDateTime.day}-${hoursSecond}:${minutesSecond}")),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FlutterDropdownSearch(
                    // seçilen ders
                    textController: _controller,
                    // derslerin listesini tutar
                    items: items,
                    dropdownHeight: 300,
                    hintText: "Lütfen ders seçimini yapınız.",
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.all(20),
                            elevation: 5,
                            shadowColor: Color.fromRGBO(9, 154, 75, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          textValueLesson = _controller.text;
                          print(_controller.text);
                          print(textValueLesson.runtimeType);
                          print(startTime.toString());
                          print(finishTime.toString());
                          sendDataToAPI(
                              textValueLesson!, startTime, finishTime);
                        },
                        child: Text(
                          "Yoklama Listesini Görüntüle",
                          style: TextStyle(
                              color: Color.fromRGBO(9, 154, 75, 1),
                              fontSize: 15),
                        ))),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FlutterDropdownSearch(
                    textController: _controllerWeek,
                    items: Department.itemsLessonName,
                    dropdownHeight: 300,
                    hintText: "Lütfen kaçıncı hafta olduğunu seçiniz.",
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(25),
                        elevation: 5,
                        shadowColor: Color.fromRGBO(9, 154, 75, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      textValueLesson = _controller.text;
                      textValueWeek = _controllerWeek.text;
                      print(textValueWeek);
                      print(textValueWeek.runtimeType);
                      print(startTime.toString());
                      print(finishTime.toString());
                      sendLessonDateToAPI(
                        textValueLesson!,
                        textValueWeek!,
                        startTime,
                        finishTime,
                      );
                    },
                    child: Text(
                      "Ders Kaydı Oluştur ve Görüntüle",
                      style: TextStyle(
                          color: Color.fromRGBO(9, 154, 75, 1), fontSize: 15),
                    )),
              ],
            ),
          ),
        ));
  }

//    YOKLAMA SORGUSU
  void sendDataToAPI(
    String textValue,
    DateTime startTime,
    DateTime endTime,
  ) async {
    var url = Uri.parse('(url)/getLessonAttendance');
    // isteğin medya türü : json formatındadir
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'lesson': textValue,
      'startTime': startTime.toString(),
      'endTime': endTime.toString()
    });
    // POST isteğinin gönderilmesi. // gönedrilecek veri
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      //sunucudan dönen JSON verisini kullanılabilir bir formata dönüştürlür
      var attendance = data['attendance_list'];
      print(attendance);
      print(attendance.runtimeType);
      //yeni sayafaya geçiş
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InquiryView(attendance)),
      );
    } else {
      print('API isteği başarısız oldu. Hata kodu: ${response.statusCode}');
    }
  }

//   DERS KAYDI
  void sendLessonDateToAPI(
    String textValue,
    String textValueWeek,
    DateTime startTime,
    DateTime endTime,
  ) async {
    var url = Uri.parse('(url)/postLessonWeek');
    // isteğin medya türü : json formatındadir
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'lesson': textValue,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      'week': textValueWeek,
    });
    // POST isteğinin gönderilmesi. // gönedrilecek veri
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      //sunucudan dönen JSON verisini kullanılabilir bir formata dönüştürlür
      var data = jsonDecode(response.body);
      var weekList = data['lesson_data'];
      weekList = data['lesson_data'];

      print(weekList);
      print(weekList.runtimeType);
      // yeni sayfaya geçiş
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WeekListView(weekList)),
      );
    } else {
      print('API isteği başarısız oldu. Hata kodu: ${response.statusCode}');
    }
  }

  Future pickDateTime() async {
    print("---------");
    print(_controller.runtimeType);
    print("---------");
    DateTime? date = await pickDate(); // tarih seçimi
    if (date == null) return;

    TimeOfDay? time = await pickTime(); // saat seçim işlemi
    if (time == null) return;
    // seçimin sonucu
    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    // widget durumu güncellenir
    setState(() {
      this.dateTime = dateTime;
      startTime = dateTime;
    });
  }

  Future pickDateTimeSecond() async {
    print("---------");
    print(_controller.runtimeType);
    print("---------");
    DateTime? date2 = await pickDate(); // tarih seçimi
    if (date2 == null) return;

    TimeOfDay? time2 = await pickTime(); // saat seçim işlemi
    if (time2 == null) return;

    // seçimin sonucu
    final secondDateTime =
        DateTime(date2.year, date2.month, date2.day, time2.hour, time2.minute);

    // widget durumu güncellenir
    setState(() {
      this.secondDateTime = secondDateTime;
      finishTime = secondDateTime;
    });
  }

  Future<DateTime?> pickDate() async => showDatePicker(
      // tarih seçme
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030));

// saat seçme
  Future<TimeOfDay?> pickTime() async => showTimePicker(
        context: context,
        // başlangıç saati
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}
