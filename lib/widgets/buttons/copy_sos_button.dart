import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopySOSButton extends StatelessWidget {
  const CopySOSButton({super.key});

  final String lastSOSMessage =
      "🚨 EMERGENCY!\n"
      "I need immediate help.\n"
      "Live Location:\n"
      "https://maps.google.com/?q=13.0827,80.2707";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          Clipboard.setData(
            ClipboardData(text: lastSOSMessage),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("SOS message copied"),
            ),
          );
        },

        icon: const Icon(
          Icons.copy_outlined,
          color: Color(0xff394867),
        ),

        label: const Text(
          "Copy Last SOS Message",
          style: TextStyle(
            color: Color(0xff394867),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}