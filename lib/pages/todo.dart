import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 리스트
class CheckBoxListView extends StatefulWidget {

  final DateTime _focusedDay;
  final String title;

  const CheckBoxListView(this._focusedDay, this.title);

  @override
  _CheckBoxListViewState  createState() => _CheckBoxListViewState();
}

class _CheckBoxListViewState extends State<CheckBoxListView> {

  List<String> _texts =[ //예시
    "장 보기",
    "책 읽기",
    "방 청소하기",
  ];

  late List<bool> _isChecked;

  @override
  void initState(){
    super.initState();
    _isChecked = List<bool>.filled(_texts.length, false); //체크된 값
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: _texts.length,
            itemBuilder: (context,index){
            return Card(
              child: CheckboxListTile(
                title: Text(_texts[index]),
                subtitle: Text(DateFormat('MM.dd').format(widget._focusedDay),
                  style: TextStyle(fontSize: 12),),
                checkColor: Colors.black,
                activeColor: Colors.transparent,
                secondary: Icon(Icons.add_box,color: Colors.teal[300],),
                controlAffinity: ListTileControlAffinity.leading, //체크 박스 위치
                value:  _isChecked[index],
                onChanged: (value){
                  setState(() {
                    _isChecked[index] = value!;
                    print(index);
                  });
                },
              ),
            );
            }),
      ),
    );
  }

}