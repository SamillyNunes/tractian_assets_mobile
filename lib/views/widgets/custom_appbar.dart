import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final bool hasBackButton;
  final bool hasStrongTitle;

  const CustomAppbar({
    super.key,
    required this.label,
    this.hasBackButton = false,
    this.hasStrongTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      color: AppColors.tractianBlue,
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top * 1.2,
        ),
        child: Stack(
          children: [
            if (hasBackButton)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.white,
                  ),
                ),
              ),
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight:
                      hasStrongTitle ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
