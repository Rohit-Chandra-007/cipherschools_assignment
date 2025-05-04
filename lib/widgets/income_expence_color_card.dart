import 'package:cipherschools_assignment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeExpanseColorCard extends StatelessWidget {
  const IncomeExpanseColorCard({
    super.key,
    required this.title,
    required this.amount,
    required this.iconSvgPath,

    required this.cardColor,
  });

  final String title;
  final String amount;
  final String iconSvgPath;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.light100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: SvgPicture.asset(iconSvgPath, height: 32, width: 32),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),

                const SizedBox(height: 2),
                Text(amount, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
