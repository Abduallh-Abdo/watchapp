class SavedAlarmClock {
  String timeClock;
  bool isActiveClock;

  SavedAlarmClock({
    required this.timeClock,
    required this.isActiveClock,
  });

  SavedAlarmClock.fromMap(Map<String, dynamic> map)
      : timeClock = map["timeClock"],
        isActiveClock = map["isActiveClock"];

  Map<String, dynamic> toMap() {
    return {
      "timeClock": timeClock,
      "isActiveClock": isActiveClock,
    };
  }
}