import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/aac_provider.dart';
import '../widgets/aac_tile_widget.dart';
import '../widgets/message_bar.dart';
import '../models/aac_tile.dart';
import '../theme/app_theme.dart';

class AACBoardScreen extends StatelessWidget {
  const AACBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'AAC Communication Board',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              final provider = context.read<AACProvider>();
              switch (value) {
                case 'size_up':
                  provider.increaseTileSize();
                  break;
                case 'size_down':
                  provider.decreaseTileSize();
                  break;
                case 'size_reset':
                  provider.resetTileSize();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'size_up',
                child: Row(
                  children: [
                    Icon(Icons.zoom_in),
                    SizedBox(width: 8),
                    Text('Larger Tiles'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'size_down',
                child: Row(
                  children: [
                    Icon(Icons.zoom_out),
                    SizedBox(width: 8),
                    Text('Smaller Tiles'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'size_reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Reset Size'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<AACProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              MessageBar(
                message: provider.currentMessage,
                onClear: provider.clearMessage,
                onSpeak: provider.speakMessage,
                onRemoveLast: provider.removeLastTile,
              ),
              
              // Category Filter
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.getAvailableCategories().length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _CategoryChip(
                        label: 'All',
                        emoji: '📂',
                        isSelected: provider.selectedCategory == null,
                        onTap: () => provider.selectCategory(null),
                      );
                    }
                    
                    final category = provider.getAvailableCategories()[index - 1];
                    return _CategoryChip(
                      label: category.displayName,
                      emoji: category.emoji,
                      isSelected: provider.selectedCategory == category,
                      onTap: () => provider.selectCategory(category),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 8),
              
              // AAC Tiles Grid
              Expanded(
                child: provider.tiles.isEmpty
                    ? const Center(
                        child: Text('No tiles available for this category'),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(context, provider.tileSize),
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: provider.tiles.length,
                        itemBuilder: (context, index) {
                          final tile = provider.tiles[index];
                          return AACTileWidget(
                            tile: tile,
                            size: provider.tileSize,
                            onTap: () => provider.selectTile(tile),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context, double tileSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = 80 * tileSize + 16; // tile width + margins
    final crossAxisCount = (screenWidth / tileWidth).floor().clamp(2, 6);
    return crossAxisCount;
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: isSelected 
            ? AppTheme.primaryColor 
            : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected 
                        ? Colors.white 
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}