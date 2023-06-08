import 'lesson.dart';

// İkili Dropdown button için derslerin oluşturulması
class Department {
  String? departmentName;
  List<Lesson>? lessons;
  Department({required this.departmentName, required this.lessons});
  static List<Department> departmentButton = [
    Department(departmentName: "X Department", lessons: [
      Lesson('Lesson 1', 1),
      Lesson('Lesson 2', 2),
      Lesson('Lesson 3', 3),
    ]),
    Department(departmentName: "Y Department", lessons: [
      Lesson('Lesson 5', 39),
      Lesson('Lesson 5', 40),
      Lesson('Lesson 6', 41),
    ]),
  ];
  static List<String> itemsLessonName = [
    "Week 1",
    "Week 2",
    "Week 3",
  ];
}
