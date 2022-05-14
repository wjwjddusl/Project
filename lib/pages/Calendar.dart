import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_tutorial/login/login_main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';
import 'todo_list.dart';


class TableEventsExample extends StatefulWidget {
  //statefulWidget => http 호출이나 사용자와 상호작용으로 받은 데이터 기반으로 동적 변경 가능.
  const TableEventsExample({Key? key}) : super(key: key);


  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  @override
  void initState() { //앱상태변경 이벤트 등록
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() { //앱 상태변경 이벤트 해제
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) { //값이 있으면 마커표시
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  //마커 표시 커스텀
  Widget _buildEventsMarkerNum(List events){
    return buildCalendarDayMarker(
      text: '${events.length}',
    );
  }

  AnimatedContainer buildCalendarDayMarker({
    required String text,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape:  BoxShape.rectangle,
        color: Colors.teal[300],
      ),
      width: 47,
      height: 12,
      child:Center(
        child: Text(
          text,
          style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: 10.0
          ),
        ),),
    );
  }

  int selectIndex =0; //bottom navigation bar
 // final List<Widget> _children = [TableEventsExample()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false, //디버그 배너 없애기
      title: 'calendar',
      theme: ThemeData( //버튼 누를때 효과 없애기 (앱 전체에 적용)
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/back3.png'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal, //오버플로우 방지
              child:Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logoCal.png',width: 160,height: 100,)
                ],
              ),),
            toolbarHeight: 50,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Column(
            children: <Widget>[
              TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay, //이벤트
                startingDayOfWeek: StartingDayOfWeek.sunday, //시작날짜

                locale: 'ko-KR', //한국어로 변경
                daysOfWeekHeight: 30, //간격조절
                headerStyle: HeaderStyle( //캘린더 헤더
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: true,
                  rightChevronVisible: true,
                ),
                calendarStyle: CalendarStyle( //캘린더 스타일
                  weekendTextStyle: TextStyle(color: Colors.blueGrey),
                  todayDecoration: BoxDecoration(
                      color: Colors.transparent
                  ),
                  todayTextStyle: TextStyle(
                      color: Colors.teal.shade300,
                      fontWeight: FontWeight.bold
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.teal.shade300, width: 1.5),
                  ),
                  selectedTextStyle: TextStyle(
                      color: Colors.black
                  ),
                  outsideDaysVisible: false, //이전달의 날짜 보여주기
                ),
                calendarBuilders: CalendarBuilders(
                  //마커
                  markerBuilder: (context, day, events) {
                    return events.isNotEmpty? _buildEventsMarkerNum(events) : Container();
                  },

                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 27.0),
              Row( //목록 타이틀
                children: [
                  TextButton.icon(onPressed: (){ //투두리스트 페이지로 이동
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Todolist(_focusedDay,selectIndex))); //데이터 넘기기Navigator.of(context).pushNamed('/todolist');
                  }, //클릭하면 투두리스트 페이지로
                    icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 19,),
                    //날짜 포맷 바꾸기.
                    label: Text(DateFormat('MM-dd').format(_focusedDay), style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),),
                    style: TextButton.styleFrom(
                      primary: Colors.teal,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) { //이벤트 내용 불러오기
                    return ListView.builder(
                      itemCount: value.length, //리스트 개수
                      itemBuilder: (context, index) { //리스트 반복문 항목
                        return Container(
                          height: 35,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 3.0,
                          ),
                          decoration: BoxDecoration(
                              border: Border(left: BorderSide(color: Colors.blueGrey, width: 4.0,),),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29292B17),
                                  offset: Offset(1.0,1.0),
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                )
                              ]
                          ),
                          child: ListTile(
                            //leading: Icon(Icons.check_box),
                              title: SizedBox(
                                child:Text('${value[index]}',
                                  style: TextStyle(fontSize: 14,
                                  ),
                                ),
                                height: 50,)
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar:BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: selectIndex, //현재 인덱스 저장
            //인덱스 변경
            onTap: (index) =>{
              setState((){
                selectIndex=index; //클릭한 인덱스 번호를 현재 인덱스로 설정.
                switch (index){
                  case 0:
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (BuildContext context) => TableEventsExample()), (route) => false);
                    break;
                  case 1:
                    Navigator.push(context, PageTransition(child: Todolist(_focusedDay,selectIndex), type: PageTransitionType.fade ));
                    break;
                  case 2:
                    break;
                  case 3:
                    Navigator.push(context, PageTransition(child:Login(), type: PageTransitionType.fade ));
                    break;
                }
              })
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.grey[600]), label: 'Home' ),
              BottomNavigationBarItem(icon: Icon(Icons.article_outlined, color: Colors.grey[600]), label: 'To-do' ),
              BottomNavigationBarItem(icon: Icon(Icons.tour_sharp, color: Colors.grey[600]), label: 'challenge' ),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded, color: Colors.grey[600]), label: 'My Page' ),
            ],
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
            selectedItemColor: Colors.teal[300],
          ),
        ),
      ),
    );
  }
}
