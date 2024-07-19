import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class CompanyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CompanyButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.blue),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.02),
        child: Row(
          children: [
            Text(
              '$label Unit',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
