# Communication Recovery Toolkit

A comprehensive Flutter application designed to help individuals recovering from communication challenges through various therapeutic tools and exercises.

## Features

### ✅ Implemented
- **AAC Communication Board**: Interactive grid of communication tiles with text-to-speech functionality
- **Category-based Navigation**: Organized tiles by Basic Needs, Feelings, Actions, Questions, etc.
- **Customizable Interface**: Adjustable tile sizes for accessibility
- **Message Building**: Build and speak complete messages using selected tiles
- **Modern UI**: Material 3 design with consistent theming

### 🚧 Coming Soon (Placeholder Screens Ready)
- **Story Sequencer**: Visual story cards for narrative sequence understanding
- **Progress Tracker**: Charts and analytics for communication progress
- **Writing Rebuilder**: Interactive handwriting practice and recognition
- **Conversation Starter**: Guided social conversation scenarios

## Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── app_theme.dart       # Centralized theme and colors
├── models/
│   ├── aac_tile.dart        # AAC tile data model
│   └── communication_message.dart
├── providers/
│   └── aac_provider.dart    # State management for AAC functionality
├── services/
│   └── tts_service.dart     # Text-to-speech service
├── screens/
│   ├── main_navigation.dart
│   ├── aac_board_screen.dart
│   └── [placeholder screens for sub-apps]
└── widgets/
    ├── aac_tile_widget.dart
    └── message_bar.dart
```

### State Management
- Uses **Provider** pattern for state management
- `AACProvider` handles tile selection, message building, and TTS integration
- Persistent settings using `SharedPreferences`

### Design System
- Material 3 design principles
- Consistent color palette with accessibility in mind
- Responsive grid layout that adapts to screen size
- Haptic feedback and smooth animations

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation
```bash
# Clone the repository
git clone [repository-url]
cd communication_recovery_toolkit

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Dependencies
- `provider`: State management
- `flutter_tts`: Text-to-speech functionality
- `google_fonts`: Typography
- `shared_preferences`: Local data storage
- `lottie`: Animations (ready for future use)

## Development Guide

### For Sub-App Developers

Each sub-app has a dedicated placeholder screen with detailed implementation requirements:

1. **Story Sequencer Developer**: See `lib/screens/story_sequencer_screen.dart`
2. **Progress Tracker Developer**: See `lib/screens/progress_tracker_screen.dart`
3. **Writing Rebuilder Developer**: See `lib/screens/writing_rebuilder_screen.dart`
4. **Conversation Starter Developer**: See `lib/screens/conversation_starter_screen.dart`

### Adding Your Implementation
1. Replace the placeholder screen with your implementation
2. Follow the existing Provider pattern for state management
3. Use the established theme system (`AppTheme`)
4. Integrate with existing services (`TTSService`)
5. Follow the suggested folder structure in the placeholder comments

### Key Integration Points
- **TTS Integration**: Use `TTSService()` for all audio output
- **State Management**: Follow the Provider pattern established in `AACProvider`
- **Theming**: Use `AppTheme` constants for consistent colors and styling
- **Models**: Extend or use existing models like `AACTile` and `CommunicationMessage`

## Accessibility Features

- Adjustable tile sizes for different needs
- High contrast color options (ready for implementation)
- Haptic feedback for interaction confirmation
- Screen reader compatible widgets
- Large touch targets for easy interaction

## Future Enhancements

- **ElevenLabs TTS Integration**: Higher quality voice synthesis (noted in `tts_service.dart`)
- **Cloud Sync**: Progress and customization sync across devices
- **Therapist Portal**: Professional monitoring and customization tools
- **Offline Mode**: Full functionality without internet connection
- **Multi-language Support**: Internationalization ready

## Contributing

1. Choose a sub-app placeholder to implement
2. Follow the architecture patterns established
3. Maintain accessibility standards
4. Add comprehensive documentation
5. Test on multiple screen sizes and orientations

## License

[Add your license here]

## Support

For questions and support, please refer to the developer notes in each placeholder screen or create an issue in the repository.