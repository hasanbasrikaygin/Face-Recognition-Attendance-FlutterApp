import 'package:flutter/material.dart';

class InquiryView extends StatelessWidget {
  final List<dynamic>? attendance;
// Belirtilen tarihler arası yoklamayı gösterir
  InquiryView(this.attendance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yoklama listesi')),
      body: Container(
        //dinamik olarak bir liste oluşturmak için  kullanılır
        child: ListView.builder(
          itemCount: attendance!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                      color: Color.fromRGBO(9, 154, 75, 1), width: 3)),
              title: Text(
                attendance![index].toString(),
              ),
            );
          },
        ),
      ),
    );
  }
}
