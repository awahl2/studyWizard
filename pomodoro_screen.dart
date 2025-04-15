import 'package:flutter/material.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F7),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFFD2BAA4),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              decoration: BoxDecoration(
                color: Color(0xFFD2BAA4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 6),
                    color: Colors.black.withOpacity(0.15),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                "10:00",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFD2BAA4), // filled portion
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text("work", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("rest", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFC8B7A6),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.edit, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
