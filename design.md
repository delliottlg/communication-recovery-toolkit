# VISUAL DESIGN SYSTEM

## Color Palette

```dart
// Primary Colors - Calming & Professional
primary: Color(0xFF6B5B95)      // Soft purple
secondary: Color(0xFF88B0D3)    // Sky blue
tertiary: Color(0xFF82C09A)     // Mint green

// Accent Colors
success: Color(0xFF52C41A)      // Green
warning: Color(0xFFFAAD14)      // Amber
error: Color(0xFFFF6B6B)        // Soft red
info: Color(0xFF1890FF)         // Blue

// Neutrals
background: Color(0xFFF8FAFB)   // Off-white
surface: Color(0xFFFFFFFF)      // Pure white
surfaceVariant: Color(0xFFF3F4F6)
textPrimary: Color(0xFF2C3E50)  // Dark blue-gray
textSecondary: Color(0xFF64748B)

// Gradients
gradient1: LinearGradient(
  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
)
gradient2: LinearGradient(
  colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
)
```

## Typography

```dart
// Font Family: Use Google Fonts
// Primary: 'Poppins' or 'Inter' for headings
// Secondary: 'Open Sans' or 'Roboto' for body text

TextTheme(
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  ),
  headlineMedium: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  ),
  bodyLarge: TextStyle(
    fontSize: 18,
    height: 1.6,
  ),
)
```

## Component Design Patterns

### 1. Cards with Depth

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 30,
        offset: Offset(0, 10),
      ),
    ],
  ),
)
```

### 2. Neumorphic Buttons

```dart
Container(
  decoration: BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      // Bottom right - dark shadow
      BoxShadow(
        color: Colors.grey.shade400,
        offset: Offset(4, 4),
        blurRadius: 15,
        spreadRadius: 1,
      ),
      // Top left - light shadow
      BoxShadow(
        color: Colors.white,
        offset: Offset(-4, -4),
        blurRadius: 15,
        spreadRadius: 1,
      ),
    ],
  ),
)
```

### 3. Glassmorphism Effects

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.2),
        Colors.white.withOpacity(0.1),
      ],
    ),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: 1.5,
    ),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: content,
  ),
)
```

## Screen-Specific Designs

### AAC Board (Home)

```dart
// Tile Design
- Rounded corners (radius: 16px)
- Subtle gradient background
- Icon size: 48px with 8px padding
- Text: 14px, semi-bold
- Hover/Press effect: Scale to 0.95 with spring animation
- Selected state: Glow effect with primary color
```

### Story Sequencer

```dart
// Card Design
- Aspect ratio: 4:3
- White background with soft shadows
- Dragging: Add blue glow and slight rotation
- Correct position: Green checkmark animation
- Wrong position: Gentle shake animation
- Use Lottie animations for success
```

### Progress Tracker

```dart
// Charts Design
- Gradient fills for chart areas
- Smooth curved lines
- Interactive tooltips with glassmorphism
- Animated transitions between data points
- Achievement badges: Gold/Silver/Bronze gradients
```

### Writing Rebuilder

```dart
// Writing Canvas
- Paper texture background (subtle)
- Blue guide lines like notebook paper
- Traced letters: Gradient stroke
- Success particles animation
- Handwriting font for examples
```

### Conversation Starter

```dart
// Topic Cards
- Card stack with peek of next cards
- Swipe animations (Tinder-style)
- Category colors as accent borders
- Profile-style layout for scenarios
- Speech bubbles for dialogue
```

## Animations & Micro-interactions

```dart
// Page Transitions
PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 500),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    var tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOutCubic));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  },
)

// Button Animations
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
)

// Success Animations
- Confetti burst
- Ripple effects
- Bounce animations
- Progress ring fills
```

## Accessibility Features

```dart
// High Contrast Mode Toggle
ThemeData getHighContrastTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    backgroundColor: Colors.white,
    // Increased contrast ratios
  );
}

// Text Size Adjustment
class TextSizeProvider extends ChangeNotifier {
  double scaleFactor = 1.0;
  
  void increaseSize() {
    scaleFactor = min(scaleFactor + 0.1, 2.0);
    notifyListeners();
  }
}

// Focus Indicators
FocusableActionDetector(
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: hasFocus ? Colors.blue : Colors.transparent,
        width: 3,
      ),
    ),
  ),
)
```

## Loading States & Feedback

```dart
// Skeleton Screens
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    height: 100,
    color: Colors.white,
  ),
)

// Progress Indicators
CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(
    Theme.of(context).primaryColor,
  ),
  strokeWidth: 3,
)

// Success/Error Toasts
SnackBar(
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.green,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  content: Row(
    children: [
      Icon(Icons.check_circle, color: Colors.white),
      SizedBox(width: 10),
      Text('Success!'),
    ],
  ),
)
```

## App Icon & Splash Screen

```dart
// App Icon Design
- Gradient background (purple to blue)
- White communication symbol (speech bubble + heart)
- Rounded square shape
- Multiple sizes for different platforms

// Splash Screen
- Animated logo (scale and fade in)
- Subtle particle effects
- Loading progress bar at bottom
- Motivational quote that changes
```

## Custom Widgets Library

```dart
// PrimaryButton
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: isLoading 
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
```

## Implementation Tips

1. Use Hero Animations for seamless transitions between screens
2. Implement Dark Mode with proper color adjustments
3. Add Haptic Feedback for all interactions (`HapticFeedback.lightImpact()`)
4. Use Cached Images with placeholder shimmer effects
5. Implement Pull-to-Refresh with custom animations
6. Add Easter Eggs - fun animations after streaks or achievements
7. Use Custom Painters for unique visual elements
8. Implement Parallax Scrolling for depth
9. Add Sound Effects (optional) for positive feedback
10. Create Onboarding Flow with beautiful illustrations

## Package Recommendations

```yaml
dependencies:
  # Animations
  lottie: ^2.6.0
  animations: ^2.0.8
  shimmer: ^3.0.0
  
  # UI Enhancement
  flutter_neumorphic: ^3.2.0
  glassmorphism: ^3.0.0
  google_fonts: ^6.1.0
  
  # Charts & Visualization
  fl_chart: ^0.65.0
  percent_indicator: ^4.2.3
  
  # Effects
  confetti: ^0.7.0
  particle_field: ^1.0.0
  
  # Utilities
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
```