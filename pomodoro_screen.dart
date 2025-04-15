import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  bool isRunning = false;
  bool isWorkMode = true;
  int workDuration = 1500; // 25 minutes
  int restDuration = 300;  // 5 minutes
  int remainingTime = 1500;
  Timer? _timer;

  void _toggleTimer() {
    if (isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingTime == 0) {
          timer.cancel();
          setState(() {
            isRunning = false;
          });
        } else {
          setState(() {
            remainingTime--;
          });
        }
      });
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  void _switchMode(bool toWork) {
    setState(() {
      isWorkMode = toWork;
      remainingTime = toWork ? workDuration : restDuration;
      _timer?.cancel();
      isRunning = false;
    });
  }

  void _showDurationPopup() {
    int tempWork = workDuration ~/ 60;
    int tempRest = restDuration ~/ 60;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAF9F7),
          title: const Text("Set Durations"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _durationField("Work (minutes)", tempWork, (val) {
                tempWork = int.tryParse(val) ?? tempWork;
              }),
              const SizedBox(height: 12),
              _durationField("Rest (minutes)", tempRest, (val) {
                tempRest = int.tryParse(val) ?? tempRest;
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  workDuration = tempWork * 60;
                  restDuration = tempRest * 60;
                  remainingTime = isWorkMode ? workDuration : restDuration;
                  isRunning = false;
                  _timer?.cancel();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _durationField(String label, int value, Function(String) onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: value.toString(),
        border: const OutlineInputBorder(),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (remainingTime / (isWorkMode ? workDuration : restDuration));

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFD2BAA4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'POMODORO',
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFC8B7A6),
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFFD2BAA4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 6),
                    color: Colors.black26,
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: const Color(0xFFE9DBD0),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF7A5C3D)),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(remainingTime),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _toggleTimer,
                        child: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchMode(true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isWorkMode ? const Color(0xFFD2BAA4) : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text("work", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchMode(false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isWorkMode ? const Color(0xFFD2BAA4) : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text("rest", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _showDurationPopup,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFC8B7A6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.add, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
