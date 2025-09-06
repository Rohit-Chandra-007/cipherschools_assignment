import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AddTransactionBottomSheet extends StatelessWidget {
  final VoidCallback onIncomePressed;
  final VoidCallback onExpensePressed;

  const AddTransactionBottomSheet({
    super.key,
    required this.onIncomePressed,
    required this.onExpensePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Add Transaction',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.dark100,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Income Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _TransactionCard(
              icon: Icons.trending_up,
              iconColor: Colors.white,
              iconBackgroundColor: AppColors.violet100,
              title: 'Add Income',
              subtitle: 'Salary, freelance, investments',
              onTap: onIncomePressed,
            ),
          ),

          const SizedBox(height: 16),

          // Expense Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _TransactionCard(
              icon: Icons.trending_down,
              iconColor: Colors.white,
              iconBackgroundColor: AppColors.blue100,
              title: 'Add Expense',
              subtitle: 'Food, transport, shopping',
              onTap: onExpensePressed,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<_TransactionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isPressed ? Colors.grey.shade100 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      _isPressed
                          ? widget.iconBackgroundColor.withValues(alpha: 0.3)
                          : Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow:
                    _isPressed
                        ? []
                        : [
                          BoxShadow(
                            color: Colors.black.withValues( alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
              ),
              child: Row(
                children: [
                  // Icon Container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color:
                          _isPressed
                              ? widget.iconBackgroundColor.withValues(alpha: 0.8)
                              : widget.iconBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(widget.icon, color: widget.iconColor, size: 28),
                  ),

                  const SizedBox(width: 16),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            color: AppColors.dark100,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.dark50),
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 150),
                    turns: _isPressed ? 0.1 : 0,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.dark25,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
