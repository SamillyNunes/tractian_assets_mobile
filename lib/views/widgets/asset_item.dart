import 'package:flutter/material.dart';

class AssetItem extends StatelessWidget {
  final String label;
  final String iconUrl;

  const AssetItem({
    super.key,
    required this.label,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.keyboard_arrow_down,
          ),
          Image.asset(
            iconUrl,
            height: 25,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
