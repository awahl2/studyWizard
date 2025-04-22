import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pomodoro_controller.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PomodoroController>(context);
    final minutes = controller.timeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = controller.timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${minutes}:${seconds}', style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.toggleMode(true),
                  child: const Text('Work'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => controller.toggleMode(false),
                  child: const Text('Rest'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IconButton(
              iconSize: 60,
              icon: Icon(controller.isRunning ? Icons.pause : Icons.play_arrow),
              onPressed: controller.togglePlayPause,
            )
          ],
        ),
      ),
    );
  }
}
