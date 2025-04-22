import 'dart:async';
import 'package:flutter/material.dart';
import '../models/timer_model.dart';

class PomodoroController extends ChangeNotifier {
  PomodoroTimer timerModel = PomodoroTimer();
  Duration timeRemaining = const Duration(minutes: 25);
  Timer? _timer;
  bool isRunning = false;

  void toggleMode(bool isWorking) {
    timerModel.isWorking = isWorking;
    timeRemaining = Duration(minutes: timerModel.currentDuration);
    notifyListeners();
  }

  void startTimer() {
    if (isRunning) return;
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.inSeconds == 0) {
        stopTimer();
      } else {
        timeRemaining -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    timeRemaining = Duration(minutes: timerModel.currentDuration);
    notifyListeners();
  }

  void togglePlayPause() {
    isRunning ? stopTimer() : startTimer();
  }

  void updateDurations({int? work, int? rest}) {
    if (work != null) timerModel.workDuration = work;
    if (rest != null) timerModel.restDuration = rest;
    resetTimer();
  }
}
