import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:new_post/attendance_view.dart';
import 'package:new_post/department.dart';
import 'package:new_post/teacher_login.dart';
import 'package:new_post/user_register.dart';
import 'lesson.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(
        title: 'Mobil Yoklama Sistemi',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static bool? isactivate;
  String? selectedDepartment;
  String? selectedLesson;
  List<String> lesson = [];
  int? selectedLessonId;
  bool? selectedLessonIsActivate;
  TextEditingController? userName = TextEditingController();
  TextEditingController? password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        // TabBar ve TabBarView widget'larını birleştirir.
        // Bu sayede alt tab çubuğu ve alt tab içerikleri oluşturulur.
        length: 3,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                widget.title,
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
            ),
            bottomNavigationBar: const BottomAppBar(
                // alt tab çubuğunu oluşturur.
                child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: Color.fromRGBO(9, 154, 75, 1),
              ),
              tabs: [
                Tab(
                  child: Text(
                    "Yoklama",
                  ),
                ),
                Tab(
                  child: Text(
                    "Kayıt",
                  ),
                ),
                Tab(
                  child: Text(
                    "Öğretmen",
                  ),
                ),
              ],
            )),
            body: TabBarView(
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/kou.png",
                      width: 300,
                      height: 400,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        color: Color.fromRGBO(9, 154, 75, 1),
                        width: 300,
                        height: 50,
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 50,
                            child: Center(
                              child: DropdownButton<String>(
                                hint: Text(
                                  "Lütfen bölümünüzü seçiniz",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                menuMaxHeight:
                                    200, // açılır menü max yüksekliği
                                itemHeight: 50, // öğe yüksekliği
                                elevation: 8, // gölge
                                value: selectedDepartment, // seçili olan değer
                                onChanged: (String? value) {
                                  setState(() {
                                    // değişikliğin arayüze yansımasını sağlar
                                    selectedDepartment =
                                        value!; // seçili bölüm değerini oluşturur
                                    selectedLesson = null;
                                  });
                                },
                                style: const TextStyle(
                                    color: Color.fromRGBO(9, 154, 75, 1)),
                                selectedItemBuilder: (BuildContext context) {
                                  // Her bir bölüm öğesi için bir Widget döndürür.
                                  return Department.departmentButton
                                      .map((Department department) {
                                    //  liste üzerinde işlem yapmak için kullanılır.
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        department.departmentName!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: Department.departmentButton.map<
                                        DropdownMenuItem<String>>(
                                    //her bir bölüm için bir DropdownMenuItem<String> öğesi oluşturur
                                    (Department department) {
                                  return DropdownMenuItem<String>(
                                    value: department.departmentName,
                                    child: Text(department.departmentName!),
                                    // bölümün adını kullanıcıya gösterir.
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 55),
                      child: Container(
                        color: Color.fromRGBO(9, 154, 75, 1),
                        width: 300,
                        height: 50,
                        child: Center(
                          child: Container(
                            width: 400,
                            height: 150,
                            child: Center(
                              child: DropdownButton<String>(
                                hint: Text(
                                  "Lütfen dersinizi seçiniz",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                                menuMaxHeight: 200,
                                itemHeight: 50,
                                elevation: 8,
                                value: selectedLesson, // seçili olan ders
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedLesson =
                                        value; // seçili olan ders ataması

                                    if (selectedDepartment != null &&
                                        selectedLesson != null) {
                                      final selectedDepartmentObj = Department
                                          .departmentButton
                                          .firstWhere((department) =>
                                              department.departmentName ==
                                              selectedDepartment);
                                      // Seçilen bölüm adına göre
                                      // listedeki ilgili bölüm nesnesi
                                      // bulunur ve selectedDepartmentObj değişkenine atanır.
                                      final selectedLessonObj =
                                          selectedDepartmentObj.lessons!
                                              .firstWhere((lesson) =>
                                                  lesson.name ==
                                                  selectedLesson);
                                      selectedLessonId =
                                          selectedLessonObj.lessonId;
                                      // seçilenj dersin lessonId si değerrini tanımlar
                                      selectedLessonIsActivate =
                                          selectedLessonObj.isActive;
                                      print(selectedLessonId);
                                    } else {
                                      //Seçili bir bölüm veya ders olmadığında
                                      //aşağıdaki işlemler gerçekleştirilir:
                                      selectedLessonId =
                                          null; // Değerleri sıfırla
                                      selectedLessonIsActivate = false;
                                    }
                                  });
                                },
                                style: const TextStyle(
                                    color: Color.fromRGBO(9, 154, 75, 1)),
                                // seçilen öğeyi görselleştirmek için bir yapı oluşturur
                                selectedItemBuilder: (BuildContext context) {
                                  if (selectedDepartment != null) {
                                    // Department.departmentButton listesinde,
                                    //seçilen bölüm adına (selectedDepartment) sahip
                                    //bölüm nesnesini (Department objesi) bulur
                                    // ve selectedDepartmentObj değişkenine atar.
                                    final selectedDepartmentObj = Department
                                        .departmentButton
                                        .firstWhere((department) =>
                                            department.departmentName ==
                                            selectedDepartment);
                                    return selectedDepartmentObj.lessons!
                                        .map((Lesson lesson) {
                                      return Align(
                                        // döngüyle her ders için görünümü sağlar
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          lesson.name!,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    }).toList();
                                  } else {
                                    return const [];
                                  }
                                },
                                items: selectedDepartment != null
                                    // seçilen her bölüme ait bölüm nesnesini bulur
                                    ? Department.departmentButton
                                        .firstWhere((department) =>
                                            department.departmentName ==
                                            selectedDepartment)
                                        // bölümün lesson özelliğine erişir
                                        .lessons!
                                        // ders adına göre DropdownMenuItem oluşturur
                                        .map<DropdownMenuItem<String>>(
                                            (Lesson lesson) {
                                        return DropdownMenuItem<String>(
                                          value: lesson.name,
                                          child: Text(lesson.name!),
                                        );
                                      }).toList()
                                    : const [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AttendanceView(
                      selectedLessonId: selectedLessonId,
                    )
                  ],
                ),
                UserRegister(),
                TeacherLogin(),
              ],
            )));
  }
}
