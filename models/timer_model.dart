class PomodoroTimer {
  int workDuration; // in minutes
  int restDuration; // in minutes
  bool isWorking;

  PomodoroTimer({
    this.workDuration = 25,
    this.restDuration = 5,
    this.isWorking = true,
  });

  int get currentDuration => isWorking ? workDuration : restDuration;
}
