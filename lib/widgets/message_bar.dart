import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class MessageBar extends StatelessWidget {
  final String message;
  final VoidCallback onClear;
  final VoidCallback onSpeak;
  final VoidCallback? onRemoveLast;

  const MessageBar({
    super.key,
    required this.message,
    required this.onClear,
    required this.onSpeak,
    this.onRemoveLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMessage = message.isNotEmpty;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasMessage 
              ? AppTheme.primaryColor.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.2),
          width: hasMessage ? 2 : 1,
        ),
        boxShadow: [
          AppTheme.cardShadow,
          if (hasMessage)
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: hasMessage 
                    ? AppTheme.primaryColor 
                    : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hasMessage ? message : 'Tap tiles to build your message...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: hasMessage 
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: hasMessage ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasMessage) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.volume_up,
                  label: 'Speak',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onSpeak();
                  },
                  isPrimary: true,
                ),
                if (onRemoveLast != null)
                  _ActionButton(
                    icon: Icons.backspace_outlined,
                    label: 'Remove',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onRemoveLast!();
                    },
                  ),
                _ActionButton(
                  icon: Icons.clear,
                  label: 'Clear',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onClear();
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: isPrimary 
          ? AppTheme.primaryColor 
          : theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary 
                    ? Colors.white 
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isPrimary 
                      ? Colors.white 
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}