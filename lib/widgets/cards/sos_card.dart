import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SosCard extends StatelessWidget {

  final VoidCallback onPressed;

  const SosCard({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,

      child: Container(
        height: 210,

        margin: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: AppColors.sosRed,
          borderRadius: BorderRadius.circular(32),
        ),

        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.priority_high,
                color: AppColors.sosRed,
                size: 34,
              ),
            ),

            SizedBox(height: 18),

            Text(
              "SEND SOS ALERT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Instant alert to all trusted contacts",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}