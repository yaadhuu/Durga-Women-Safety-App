import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../widgets/common/header_widget.dart';
import '../widgets/cards/sos_card.dart';
import '../widgets/cards/contacts_card.dart';
import '../widgets/cards/threat_card.dart';
import '../widgets/cards/location_card.dart';
import '../widgets/cards/evidence_card.dart';
import '../widgets/buttons/emergency_button.dart';
import '../widgets/buttons/copy_sos_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,

      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const HeaderWidget(),

              SosCard(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("🚨 SOS Button Pressed"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),

              const ContactsCard(),

              const ThreatCard(),

              const LocationCard(),

              const EvidenceCard(),

              const EmergencyButton(),

              const SizedBox(height: 15),

              const CopySOSButton(),

              const SizedBox(height: 25),

              const Text(
                "ANDHRA PRADESH REGIONAL MVP V1.2",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 120),

            ],
          ),
        ),
      ),
    );
  }
}