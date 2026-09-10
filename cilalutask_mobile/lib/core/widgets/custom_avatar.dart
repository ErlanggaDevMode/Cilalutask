import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  final String imageUrl;
  final String fallbackText;
  final double radius;
  final bool hasBorder;
  final Color borderColor;
  final int? teamCount;

  const CustomAvatar({
    super.key,
    required this.imageUrl,
    required this.fallbackText,
    this.radius = 18,
    this.hasBorder = true,
    this.borderColor = AppColors.border,
    this.teamCount,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarCircle = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasBorder ? Border.all(color: borderColor, width: 1.5) : null,
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            final initials = fallbackText.isNotEmpty
                ? fallbackText.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
                : 'U';
            return Container(
              color: AppColors.primaryLight,
              alignment: Alignment.center,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: radius * 0.7,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.surfaceSecondary,
              child: const Center(
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              ),
            );
          },
        ),
      ),
    );

    if (teamCount != null && teamCount! > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          avatarCircle,
          Positioned(
            right: -4,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: Text(
                '+$teamCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return avatarCircle;
  }
}
