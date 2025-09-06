import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cipherschools_assignment/shared/extensions/transaction_analytics.dart';

class SwipeNavigationWrapper extends StatefulWidget {
  final Widget child;
  final TimeFilter currentFilter;
  final ValueChanged<TimeFilter> onFilterChanged;

  const SwipeNavigationWrapper({
    super.key,
    required this.child,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<SwipeNavigationWrapper> createState() => _SwipeNavigationWrapperState();
}

class _SwipeNavigationWrapperState extends State<SwipeNavigationWrapper>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  final List<TimeFilter> _filters = TimeFilter.values;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize page controller with current filter index
    final initialIndex = _filters.indexOf(widget.currentFilter);
    _pageController = PageController(initialPage: initialIndex);
    
    // Initialize animation controller for smooth transitions
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(SwipeNavigationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update page controller if filter changed externally (e.g., from tabs)
    if (oldWidget.currentFilter != widget.currentFilter && !_isAnimating) {
      final newIndex = _filters.indexOf(widget.currentFilter);
      if (newIndex != _pageController.page?.round()) {
        _pageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index >= 0 && index < _filters.length) {
      final newFilter = _filters[index];
      if (newFilter != widget.currentFilter) {
        // Provide haptic feedback for filter change
        _triggerHapticFeedback();
        
        // Trigger scale animation for visual feedback
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
        
        widget.onFilterChanged(newFilter);
      }
    }
  }

  void _triggerHapticFeedback() {
    try {
      HapticFeedback.selectionClick();
    } catch (e) {
      // Haptic feedback might not be available on all platforms
      debugPrint('Haptic feedback not available: $e');
    }
  }

  void _onPanStart(DragStartDetails details) {
    _isAnimating = true;
  }

  void _onPanEnd(DragEndDetails details) {
    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                // All pages show the same content, but with different filter context
                return widget.child;
              },
            ),
          );
        },
      ),
    );
  }
}