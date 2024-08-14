abstract class ClockStates {}

class ClockInitial extends ClockStates {}

class ChangeCurrentIndexState extends ClockStates {}

class LodaingDeviceState extends ClockStates {}

class ConnectionDeviceState extends ClockStates {}

class StartDiscoveryState extends ClockStates {}

class SendDataState extends ClockStates {}

class StopButtonState extends ClockStates {}

class StartButtonState extends ClockStates {}

class ResetButtonState extends ClockStates {}

class AddButtonState extends ClockStates {}

class SelectTimeState extends ClockStates {}

class UpdateAMtimerState extends ClockStates {}

class UpdateNumberPickerState extends ClockStates {}

class UpdateTimerState extends ClockStates {}

class SharedprefState extends ClockStates {}

class UpdateDataAlarmClockstate extends ClockStates {}

class ClockTickState extends ClockStates {
  final Duration remainingClock;
  ClockTickState({required this.remainingClock});
}
