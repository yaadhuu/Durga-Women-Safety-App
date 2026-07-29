import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/colors.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({super.key});

  Future<void> callNumber(String number) async {
    final Uri uri = Uri(scheme: "tel", path: number);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget buildButton(
      String title,
      String subtitle,
      String number,
      BuildContext context,
      ) {
    return InkWell(
      onTap: () => callNumber(number),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: AppColors.maroon,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [

            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.call,
                color: AppColors.maroon,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Column(
        children: [

          buildButton(
            "Dial 112 Emergency",
            "National Emergency Number",
            "112",
            context,
          ),

          buildButton(
            "Dial 181 Women Helpline",
            "Women's Safety Helpline",
            "181",
            context,
          ),

        ],
      ),
    );
  }
}