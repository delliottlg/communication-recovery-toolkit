import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/aac_tile.dart';
import '../theme/app_theme.dart';

class AACTileWidget extends StatefulWidget {
  final AACTile tile;
  final double size;
  final VoidCallback onTap;

  const AACTileWidget({
    super.key,
    required this.tile,
    required this.size,
    required this.onTap,
  });

  @override
  State<AACTileWidget> createState() => _AACTileWidgetState();
}

class _AACTileWidgetState extends State<AACTileWidget>
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseSize = 80.0 * widget.size;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: baseSize,
              height: baseSize,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _isPressed 
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isPressed 
                      ? AppTheme.primaryColor
                      : theme.colorScheme.outline.withOpacity(0.2),
                  width: _isPressed ? 2 : 1,
                ),
                boxShadow: [
                  AppTheme.cardShadow,
                  if (_isPressed)
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.tile.emoji,
                    style: TextStyle(
                      fontSize: (24 * widget.size).clamp(20, 32),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      widget.tile.text,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: (12 * widget.size).clamp(10, 16),
                        fontWeight: FontWeight.w600,
                        color: _isPressed 
                            ? AppTheme.primaryColor 
                            : theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}