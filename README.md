# Face-Recognition-Attendance-FlutterApp
 This repository aims to develop a face recognition application using Flutter and Flask for student attendance taking and tracking.

# Uygulama ile yapılabilecek özellikler:



## Öğrenciler:
- Yüz tanıma işlemi ile yoklama alabilirler.
- Yüz tanıma işlemi ile sisteme kayıt olabilirler.

| Yokalama Alma Sayfası                         | Kayıt Olma Sayfası                    |
| ---------------------------------- | ---------------------------------- |
| ![attendance](https://github.com/hasanbasrikaygin/Face-Recognition-Attendance-FlutterApp/blob/main/images/attendance_view.jpeg) | ![register](https://github.com/hasanbasrikaygin/Face-Recognition-Attendance-FlutterApp/blob/main/images/register_view.jpeg) |


Öğrencilerin yoklama almak için ; bölüm seçimi , ders seçimi ve fotoğraf yükleme işlemini gerçekleştirdikleri sayfa. | Öğrencilerin sisteme kayıt olmak için bilgilerini girdikleri ve fotoğraf çekimini gerçekleştirdikleri sayfa.


## Öğretmenler:
- Kullanıcı bilgileri ile admin sayfasına giriş yaparak:
  - Belirtilen tarihler arasındaki istenilen dersin yoklama kaydını görüntüleyebilirler.
  - Yeni ders kaydı oluşturup geçmiş ders kayıtlarını görüntüleyebilirler.


| Öğretmen Giriş Sayfası |  Öğretmen Sorgu Sayfası |
| --- | --- |
| ![login](https://github.com/hasanbasrikaygin/Face-Recognition-Attendance-FlutterApp/blob/main/images/teacher_login_view.jpeg) | ![admin](https://github.com/hasanbasrikaygin/Face-Recognition-Attendance-FlutterApp/blob/main/images/teacher_view.jpeg) |

---


| Seçilen tarih ve ders bilgilerine göre dersin yoklama listesinin görüntülendiği ekran. | Seçilen tarih ve ders bilgilerine göre kaydın oluşturulduğu ve derse ait geçmişte bulunan bilgilerin görüntülendiği ekran. |
| --- | --- |
| ![attendance list](https://github.com/hasanbasrikaygin/Face-Recognition-Attendance-FlutterApp/blob/main/images/student_list_view.jpeg) | ![lesson week list](https://github.com/hasanbasrikaygin/Face-Recognition-Attendance-FlutterApp/blob/main/images/lesson_list_view.jpeg) |



# Projede kullanılan teknolojiler:
- Haarcascade : Yüz bulma işlemi için kullanılan önceden eğitilmiş bir görüntü sınıflandırıcısı.
- Facenet : Yüz tanıma işlemi için kullanılan önceden eğitilmiş bir derin öğrenme modeli.
- Flask : API geliştirme için kullanılan Python framework'ü.
- MySQL : Öğrenci, ders ve yoklama bilgilerinin saklandığı tabloları içermektedir.
- HTTP : İstemci-sunucu arasında iletişim için kullanılan protokol.

# Projede kullanılan Python kütüphaneleri:
- flask
- cv2 (OpenCV)
- PIL (Python Imaging Library)
- numpy
- pickle
- keras_facenet
- os

# Projede kullanılan Flutter kütüphaneleri:
- image_picker: ^0.8.7+5
- http: ^0.13.3
- flutter_dropdown_search: ^0.0.2
