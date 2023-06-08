import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WeekListView extends StatelessWidget {
  final List<dynamic>? weekList;

  WeekListView(this.weekList);

// kayıtlı dersleri görüntüleme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kayıtlı Ders Tarihleri')),
      body: Container(
        //dinamik olarak bir liste oluşturmak için  kullanılır
        child: ListView.builder(
          itemCount: weekList!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                      color: Color.fromRGBO(9, 154, 75, 1), width: 2)),
              title: Text(
                weekList![index].toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(9, 154, 75, 1),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
