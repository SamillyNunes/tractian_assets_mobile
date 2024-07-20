import 'package:flutter/material.dart';
import 'package:tractian_assets_mobile/core/app_colors.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPressed;

  const FilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: isPressed ? AppColors.blue : null,
          border: Border.all(
            color: isPressed ? AppColors.blue : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              child: Icon(
                icon,
                color: isPressed ? Colors.white : Colors.grey.shade400,
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isPressed ? Colors.white : Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
