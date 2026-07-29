import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class ThreatCard extends StatefulWidget {
  const ThreatCard({super.key});

  @override
  State<ThreatCard> createState() => _ThreatCardState();
}

class _ThreatCardState extends State<ThreatCard> {
  final TextEditingController controller = TextEditingController();

  String risk = "Low Risk";
  Color riskColor = Colors.green;

  void analyzeThreat() {
    String text = controller.text.toLowerCase();

    if (text.contains("help") ||
        text.contains("danger") ||
        text.contains("attack") ||
        text.contains("follow") ||
        text.contains("threat") ||
        text.contains("harass")) {
      setState(() {
        risk = "High Risk";
        riskColor = Colors.red;
      });
    } else if (text.isEmpty) {
      setState(() {
        risk = "Low Risk";
        riskColor = Colors.green;
      });
    } else {
      setState(() {
        risk = "Medium Risk";
        riskColor = Colors.orange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology_alt,
                color: AppColors.navy,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Threat Analysis",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "AI ENGINE",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
              "Describe situation or type keywords like\n'Help', 'Threat', 'Followed'",
              filled: true,
              fillColor: const Color(0xffF5F7FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: analyzeThreat,
              icon: const Icon(Icons.search),
              label: const Text(
                "Analyze Threat Pattern",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xffF6F8FC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text(
                  "Current Risk Score:",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  risk,
                  style: TextStyle(
                    color: riskColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}