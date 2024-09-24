void main() {
  basics();
  utc();
  now();
  comparison();
  toUtcToLocal();
}

void basics() {
  final date = DateTime(

    /// 년
      1992,

      /// 월
      11,

      /// 일
      23,

      /// 시
      1,

      /// 분
      23,

      /// 초
      25,

      /// 밀리 초
      30,

      /// 마이크로 초
      5);
}

void utc() {
  final date = DateTime.utc(

    /// 년
      1992,

      /// 월
      11,

      /// 일
      23,

      /// 시
      1,

      /// 분
      23,

      /// 초
      25,

      /// 밀리 초
      30,

      /// 마이크로 초
      5);
}

void now() {
  final now = DateTime.now(); // 코드가 실행되는 순간의 날자와 시간을 알려준다.

  /// 현재 날짜와 시간이 출력됨
  print(now);
}

void duration() {
  final duration = Duration(
    /// 날
    days: 1,

    /// 시
    hours: 1,

    /// 분
    minutes: 1,

    /// 초
    seconds: 1,

    /// 밀리 초
    milliseconds: 1,

    /// 마이크로 초
    microseconds: 1,
  );
}

void dateCalc() {
  final date = DateTime(
    1992,
    11,
    23,
  );

  final duration = Duration(
    days: 1,
  );

  print(date.add(duration)); //duration 기간만큼 기간을 늘릴 수 있다.
  print(date.subtract(duration)); //duration 기간만큼 기간을 줄일 수 있다.
}

void comparison(){
  final date1 = DateTime(
    1992,
    11,
    23,
  );

  final date2 = DateTime(
      2023,
      11,
      23
  );

  print(date1.isAfter(date2)); //이후의 날짜면 true 반환
  print(date1.isBefore(date2)); // 이전의 날짜면  true 반환
  print(date1.isAtSameMomentAs(date2)); // 같은 날짜면 true 반환 (년, 월, 날, 시간, 분, 초, 마이크로 초, 밀리초 모두 맞아야 함)
}

void toUtcToLocal() {
  final date = DateTime(
      1992,
      11,
      23
  );

  final utcDate = date.toUtc();

  /// 1992-11-23 00:00:00.000
  print(date);

  /// 1992-11-22 15:00:00.000Z (Z가 끝에 있으면 UTC기준이라는 의미)
  print(utcDate);

  /// 1992-11-23 00:00:00.000
  print(utcDate.toLocal()); // UTC 기준 날짜를 현지 날짜로 수정

}