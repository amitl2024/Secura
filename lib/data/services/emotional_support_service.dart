import 'dart:math';

class EmotionalSupportService {
  static final EmotionalSupportService _instance =
      EmotionalSupportService._internal();
  factory EmotionalSupportService() => _instance;
  EmotionalSupportService._internal();

  // Emotional context tracking
  String _currentMood = 'neutral';
  List<String> _recentTopics = [];
  int _conversationLength = 0;

  // Calming responses for different emotional states
  static const Map<String, List<String>> _calmingResponses = {
    'anxious': [
      "Take a deep breath with me, sweetheart. Inhale slowly... hold it... now exhale gently. You're safe here with me. 💜",
      "I can feel your anxiety, dear. Let's focus on this moment together. You're not alone in this. 🌸",
      "Your feelings are completely valid, love. Let's take this one step at a time. I'm right here with you. 🤗",
    ],
    'scared': [
      "I'm here with you, sweetheart. You're safe, and I want you to know that your safety is my priority. 💕",
      "It's okay to feel scared, dear. Let's focus on what you can control right now. I'm holding space for you. 🌟",
      "You're so brave for sharing this with me. Let's work through this together, one gentle step at a time. 💜",
    ],
    'sad': [
      "I can feel your sadness, and I want you to know that it's okay to not be okay. I'm here to listen. 💜",
      "Your feelings matter, sweetheart. Sometimes we need to sit with our sadness, and that's perfectly okay. 🌸",
      "I'm wrapping you in a warm hug right now, dear. You don't have to face this alone. 🤗",
    ],
    'angry': [
      "I can sense your frustration, and that's completely understandable. Let's channel this energy together. 💜",
      "Your anger is valid, sweetheart. Let's take a moment to breathe and find a way forward. 🌸",
      "I'm here to help you process these feelings, dear. You're not alone in this. 💕",
    ],
    'overwhelmed': [
      "I can see you're feeling overwhelmed, love. Let's break this down into smaller, manageable pieces. 💜",
      "Take a moment to breathe with me, sweetheart. We'll tackle this together, one thing at a time. 🌸",
      "You don't have to figure everything out right now, dear. Let's focus on just the next small step. 🤗",
    ],
    'neutral': [
      "How are you feeling today, sweetheart? I'm here to listen and support you. 💜",
      "I'm so glad you're here with me today. What's on your mind, dear? 🌸",
      "You're doing great, love. Is there anything you'd like to talk about? 💕",
    ],
  };

  // Breathing exercises
  static const List<Map<String, dynamic>> _breathingExercises = [
    {
      'name': '4-7-8 Breathing',
      'description': 'Inhale for 4, hold for 7, exhale for 8',
      'steps': [
        'Inhale slowly through your nose for 4 counts',
        'Hold your breath for 7 counts',
        'Exhale slowly through your mouth for 8 counts',
        'Repeat 3-4 times',
      ],
      'benefit': 'Perfect for calming anxiety and stress',
    },
    {
      'name': 'Box Breathing',
      'description': 'Equal counts for inhale, hold, exhale, hold',
      'steps': [
        'Inhale for 4 counts',
        'Hold for 4 counts',
        'Exhale for 4 counts',
        'Hold for 4 counts',
        'Repeat 4-5 times',
      ],
      'benefit': 'Great for grounding and centering yourself',
    },
    {
      'name': 'Gentle Belly Breathing',
      'description': 'Focus on breathing into your belly',
      'steps': [
        'Place one hand on your chest, one on your belly',
        'Breathe slowly into your belly (hand should rise)',
        'Chest should stay relatively still',
        'Exhale slowly and gently',
        'Continue for 5-10 breaths',
      ],
      'benefit': 'Activates your body\'s relaxation response',
    },
  ];

  // Grounding techniques
  static const List<String> _groundingTechniques = [
    "Name 5 things you can see around you right now",
    "Name 4 things you can touch and feel their texture",
    "Name 3 things you can hear in your environment",
    "Name 2 things you can smell",
    "Name 1 thing you can taste",
    "Take 3 deep breaths and notice how your body feels",
    "Wiggle your toes and notice the sensation",
    "Stretch your arms above your head and feel the stretch",
  ];

  // Analyze emotional context from message
  String analyzeEmotionalContext(String message) {
    final lowerMessage = message.toLowerCase();

    // Anxiety indicators
    if (lowerMessage.contains(
      RegExp(r'\b(anxious|worried|nervous|panic|overwhelmed|stressed)\b'),
    )) {
      _currentMood = 'anxious';
    }
    // Fear indicators
    else if (lowerMessage.contains(
      RegExp(r'\b(scared|afraid|frightened|terrified|fear)\b'),
    )) {
      _currentMood = 'scared';
    }
    // Sadness indicators
    else if (lowerMessage.contains(
      RegExp(r'\b(sad|depressed|down|blue|hurt|broken)\b'),
    )) {
      _currentMood = 'sad';
    }
    // Anger indicators
    else if (lowerMessage.contains(
      RegExp(r'\b(angry|mad|furious|frustrated|irritated)\b'),
    )) {
      _currentMood = 'angry';
    }
    // Overwhelmed indicators
    else if (lowerMessage.contains(
      RegExp(r'\b(overwhelmed|too much|cant handle|drowning)\b'),
    )) {
      _currentMood = 'overwhelmed';
    } else if (lowerMessage.contains(
      RegExp(r'\b(happy|good|great|wonderful|amazing|excited)\b'),
    )) {
      _currentMood = 'positive';
    }

    _conversationLength++;
    return _currentMood;
  }

  // Get appropriate calming response
  String getCalmingResponse(String mood) {
    final responses = _calmingResponses[mood] ?? _calmingResponses['neutral']!;
    return responses[Random().nextInt(responses.length)];
  }

  // Get breathing exercise
  Map<String, dynamic> getBreathingExercise() {
    return _breathingExercises[Random().nextInt(_breathingExercises.length)];
  }

  // Get grounding technique
  String getGroundingTechnique() {
    return _groundingTechniques[Random().nextInt(_groundingTechniques.length)];
  }

  // Check if user needs immediate support
  bool needsImmediateSupport(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains(
          RegExp(r'\b(help|emergency|danger|unsafe|hurt|harm)\b'),
        ) ||
        lowerMessage.contains(RegExp(r'\b(kill|die|end|suicide)\b'));
  }

  // Get emergency support message
  String getEmergencySupportMessage() {
    return "Sweetheart, I'm really concerned about you right now. Please know that you're not alone, and there are people who care deeply about you. If you're in immediate danger, please call emergency services or reach out to a trusted person right away. I'm here with you, and we'll get through this together. 💜";
  }

  // Get conversation starter based on mood
  String getConversationStarter() {
    switch (_currentMood) {
      case 'anxious':
        return "I can sense you might be feeling a bit anxious today, dear. Would you like to try a gentle breathing exercise together? 🌸";
      case 'sad':
        return "I'm here to listen if you'd like to talk about what's on your heart, sweetheart. 💜";
      case 'scared':
        return "You're safe here with me, love. Is there something specific that's making you feel scared? 🤗";
      default:
        return "How are you feeling today, dear? I'm here to support you in whatever way you need. 💕";
    }
  }

  // Reset emotional context
  void resetContext() {
    _currentMood = 'neutral';
    _recentTopics.clear();
    _conversationLength = 0;
  }

  // Get current mood
  String get currentMood => _currentMood;

  // Get conversation length
  int get conversationLength => _conversationLength;
}
