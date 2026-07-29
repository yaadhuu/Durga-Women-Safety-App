import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/colors.dart';

class EvidenceCard extends StatefulWidget {
  const EvidenceCard({super.key});

  @override
  State<EvidenceCard> createState() => _EvidenceCardState();
}

class _EvidenceCardState extends State<EvidenceCard> {

  final ImagePicker picker = ImagePicker();

  Future<void> openCamera() async {
    await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
  }

  Future<void> openVideo() async {
    await picker.pickVideo(
      source: ImageSource.camera,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Row(
            children: [

              Icon(
                Icons.folder_special,
                color: AppColors.navy,
              ),

              SizedBox(width: 10),

              Text(
                "Evidence Collection",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          const SizedBox(height: 25),

          Row(
            children: [

              Expanded(
                child: GestureDetector(
                  onTap: openCamera,
                  child: _card(
                    Icons.photo_camera,
                    "Photo\nEvidence",
                  ),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: GestureDetector(
                  onTap: openVideo,
                  child: _card(
                    Icons.videocam,
                    "Video\nEvidence",
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }

  Widget _card(IconData icon, String text) {
    return Container(
      height: 160,

      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 46,
          ),

          const SizedBox(height: 20),

          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          )

        ],
      ),
    );
  }
}