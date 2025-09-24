# 🌸 AI Women's Safety App

A comprehensive Flutter application designed to provide safety, support, and peace of mind for women through AI-powered assistance, emergency features, and emotional support.

## ✨ Features

### 🛡️ **Safety & Emergency Features**
- **SOS Emergency Alert**: One-tap emergency alert system with location sharing
- **Fake Call Feature**: Simulate incoming calls with realistic ringtone and vibration
- **Emergency Contacts**: Quick access to trusted contacts with one-tap calling
- **Location Sharing**: Real-time location sharing with emergency contacts
- **Safety Tips**: Comprehensive safety guidelines and self-defense advice

### 🤖 **AI-Powered Support**
- **Luna AI Companion**: Empathetic AI chatbot with emotional intelligence
- **Emotional Support**: Context-aware responses for different emotional states
- **Breathing Exercises**: Interactive calming techniques and relaxation methods
- **Mental Health Support**: 24/7 emotional support and crisis intervention
- **Personalized Care**: Tailored responses based on user's emotional context

### 📱 **User Experience**
- **Beautiful UI**: Modern, calming design with gradient backgrounds
- **Intuitive Navigation**: Easy-to-use interface with quick actions
- **Real-time Updates**: Live location tracking and emergency notifications
- **Offline Support**: Core features work without internet connection
- **Privacy First**: Secure data handling and user privacy protection

## 🚀 **Quick Start**

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Android Studio / VS Code
- Android device or emulator
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ai_women_safety.git
   cd ai_women_safety
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` to `android/app/`
   - Update Firebase configuration in `lib/main.dart`

4. **Set up environment variables**
   - Create `.env` file in the root directory
   - Add your Gemini API key:
     ```
     GEMINI_API_KEY=your_gemini_api_key_here
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ **Project Structure**

```
lib/
├── data/
│   ├── models/           # Data models
│   └── services/         # Business logic services
│       ├── auth_service.dart
│       ├── gemini_services.dart
│       ├── emotional_support_service.dart
│       ├── fake_call_service.dart
│       ├── ringtone_service.dart
│       └── location_service.dart
├── Ui/
│   ├── screens/
│   │   ├── auth/         # Authentication screens
│   │   ├── home/         # Main app screens
│   │   ├── chat/         # AI chat interface
│   │   └── fake_call/    # Fake call features
│   └── widgets/          # Reusable UI components
└── main.dart             # App entry point
```

## 🔧 **Configuration**

### Firebase Setup
1. Create a Firebase project
2. Enable Authentication, Firestore, and Cloud Functions
3. Download `google-services.json` and place in `android/app/`
4. Configure authentication providers (Email/Password, Google Sign-In)

### API Keys
- **Gemini AI**: Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
- **Google Maps**: Add your Maps API key for location features

### Permissions
The app requires the following permissions:
- `ACCESS_FINE_LOCATION` - For location tracking
- `SEND_SMS` - For emergency SMS alerts
- `CALL_PHONE` - For emergency calls
- `VIBRATE` - For haptic feedback
- `RECEIVE_SMS` - For SMS notifications

## 🎯 **Key Features Explained**

### AI Companion (Luna)
- **Emotional Intelligence**: Analyzes user's emotional state and responds accordingly
- **Context Awareness**: Remembers conversation history and emotional patterns
- **Crisis Intervention**: Detects emergency situations and provides immediate support
- **Breathing Exercises**: Interactive relaxation techniques with step-by-step guidance

### Fake Call Feature
- **Realistic Simulation**: Full-screen incoming call interface with animations
- **Customizable Callers**: Predefined caller profiles (Mom, Dad, Sister, etc.)
- **Ringtone & Vibration**: Realistic phone call experience with haptic feedback
- **Quick Access**: Available from home screen for rapid deployment

### Emergency System
- **One-Tap SOS**: Instant emergency alert with location sharing
- **Contact Management**: Add and manage emergency contacts
- **Location Tracking**: Real-time location sharing during emergencies
- **SMS Alerts**: Automatic SMS notifications to emergency contacts

## 🛠️ **Development**

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

### Code Analysis
```bash
flutter analyze
```

## 📱 **Screenshots**

| Home Screen | AI Chat | Fake Call | Emergency Contacts |
|-------------|---------|-----------|-------------------|
| ![Home](screenshots/home.png) | ![Chat](screenshots/chat.png) | ![Fake Call](screenshots/fake_call.png) | ![Contacts](screenshots/contacts.png) |

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- **Flutter Team** - For the amazing framework
- **Google AI** - For Gemini AI integration
- **Firebase** - For backend services
- **Open Source Community** - For various packages and inspiration

## 📞 **Support**

If you have any questions or need help:

- 📧 Email: support@aiwomensafety.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/ai_women_safety/issues)
- 📖 Documentation: [Wiki](https://github.com/yourusername/ai_women_safety/wiki)

## ⚠️ **Important Notes**

- This app is designed for safety and should not replace professional emergency services
- Always call 911 or your local emergency number in life-threatening situations
- The AI companion provides emotional support but is not a replacement for professional mental health care
- Location data is only shared with your designated emergency contacts

## 🔮 **Future Roadmap**

- [ ] Voice recognition for hands-free operation
- [ ] Integration with smart home devices
- [ ] Community safety features
- [ ] Advanced AI personality customization
- [ ] Multi-language support
- [ ] Apple Watch companion app

---

**Made with 💜 for women's safety and empowerment**

*Remember: You are strong, you are capable, and you deserve to feel safe.*