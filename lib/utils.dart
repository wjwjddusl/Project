import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event { //이벤트 객체정의
  final String title;
  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>( //마커
  equals: isSameDay, //isSameDay함수 실행으로 equal여부를 판단하도록 정의.
  hashCode: getHashCode,
)..addAll(_kEventSource); //객체생성과 동시에 addAll메소드 실행

//List.gernerate() - 인덱스를 호출해 리스트 생성.
// 데이터베이스 내용 불러오기
final _kEventSource = { for (var item in List.generate(50, (index) => index)) DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5) : List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')) }
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) { //날짜에 관한것으로 수정 필요X
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.


final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year , kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year , kToday.month + 12, kToday.day);