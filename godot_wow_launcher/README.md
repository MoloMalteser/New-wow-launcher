# Godot WoW Launcher

A modern World of Warcraft launcher built with Godot Engine, featuring mobile support with touch joystick and responsive UI.

## Features

### Core Launcher Features
- **Patch Management**: Automatic patch checking and downloading
- **File Verification**: MD5 checksum verification for downloaded files
- **Game Launching**: Direct game execution with proper error handling
- **Configuration Management**: JSON-based configuration system
- **Multi-language Support**: Support for multiple game languages (enUS, frFR)

### Mobile Support
- **Touch Joystick**: Customizable virtual joystick for mobile navigation
- **Responsive UI**: Adaptive interface that works on phones and tablets
- **Touch Gestures**: Swipe, tap, and long-press support
- **Haptic Feedback**: Vibration support for mobile devices
- **Sound Feedback**: Audio feedback for user interactions
- **Auto-optimization**: Automatic settings optimization based on device type

### UI Features
- **Modern Design**: Clean, dark theme with professional appearance
- **Progress Tracking**: Real-time download progress with file details
- **Status Updates**: Clear status messages and error reporting
- **Settings Dialog**: Easy access to launcher configuration
- **Mobile Controls**: Dedicated mobile interface with touch-friendly buttons

## Installation

### Prerequisites
- Godot 4.2 or later
- World of Warcraft installation directory

### Setup
1. Clone or download this repository
2. Open the project in Godot Engine
3. Configure your server settings in `config.json`
4. Build and run the project

## Configuration

Edit `config.json` to configure your launcher:

```json
{
    "host": "your-ftp-server.com",
    "available_language": ["frFR", "enUS"],
    "default_language": "enUS",
    "patchlist_endpoint": "https://your-server.com/api/launcher",
    "end_sound": "completion.mp3",
    "extension": true,
    "mobile_settings": {
        "joystick_size": 100.0,
        "joystick_deadzone": 10.0,
        "button_size": 80.0,
        "enable_vibration": true,
        "enable_sound_feedback": true
    }
}
```

### Configuration Options

#### Server Settings
- `host`: FTP server hostname for file downloads
- `patchlist_endpoint`: HTTP endpoint for patch information
- `available_language`: Array of supported game languages
- `default_language`: Default language for the launcher
- `end_sound`: Sound file to play when download completes
- `extension`: Whether to append `.json` to patch endpoint

#### Mobile Settings
- `joystick_size`: Size of the touch joystick in pixels
- `joystick_deadzone`: Deadzone radius for joystick input
- `button_size`: Size of mobile buttons in pixels
- `enable_vibration`: Enable haptic feedback
- `enable_sound_feedback`: Enable audio feedback

## Project Structure

```
godot_wow_launcher/
├── scenes/
│   └── Main.tscn          # Main UI scene
├── scripts/
│   ├── LauncherManager.gd # Core launcher functionality
│   ├── MainUI.gd          # Main UI controller
│   ├── TouchJoystick.gd   # Mobile joystick component
│   └── MobileSettings.gd  # Mobile settings manager
├── assets/
│   ├── textures/          # UI textures and icons
│   ├── fonts/            # Custom fonts
│   └── sounds/           # Audio files
├── config.json           # Launcher configuration
└── project.godot        # Godot project file
```

## Building for Mobile

### Android
1. Install Android SDK and configure Godot for Android export
2. Set up signing keys in Project Settings
3. Export as Android APK or AAB

### iOS
1. Install Xcode and configure Godot for iOS export
2. Set up Apple Developer account and certificates
3. Export as iOS app

## Usage

### Desktop
1. Launch the application
2. Click "Check Patches" to check for updates
3. Wait for downloads to complete
4. Click "Launch Game" to start World of Warcraft

### Mobile
1. Launch the app on your mobile device
2. Use the touch joystick for navigation
3. Tap "Check Patches" to check for updates
4. Use mobile-optimized buttons for all functions
5. Enjoy haptic feedback and sound effects

## Development

### Adding New Features
1. Create new scripts in the `scripts/` directory
2. Add UI elements to `scenes/Main.tscn`
3. Update configuration schema in `config.json`
4. Test on both desktop and mobile platforms

### Mobile Optimization
- Use `MobileSettings.optimize_for_device()` for automatic optimization
- Test on various screen sizes and orientations
- Ensure touch targets are at least 44x44 pixels
- Implement proper gesture handling

### Performance Tips
- Use texture compression for mobile builds
- Implement proper memory management
- Optimize network requests
- Use efficient UI layouts

## Troubleshooting

### Common Issues
1. **Download fails**: Check server configuration and network connectivity
2. **Game won't launch**: Verify WoW executable path and permissions
3. **Mobile controls not working**: Ensure mobile features are enabled
4. **Performance issues**: Check device optimization settings

### Debug Mode
Enable debug logging by setting `OS.is_debug_build()` to true in the launcher manager.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple platforms
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original Vue.js launcher by the WoW community
- Godot Engine team for the excellent game engine
- Mobile gaming community for inspiration and feedback

