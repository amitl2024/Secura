import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ai_women_safety/data/services/emotional_support_service.dart';

class GeminiService {
  final String? apiKey = dotenv.env['GEMINI_API_KEY'];
  final EmotionalSupportService _emotionalService = EmotionalSupportService();

  Future<String> sendMessage({
    required String message,
    String model = "gemini-1.5-flash",
  }) async {
    if (apiKey == null) {
      return "Error: API Key not found.";
    }

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1/models/$model:generateContent?key=$apiKey",
    );

    // Analyze emotional context
    final emotionalContext = _emotionalService.analyzeEmotionalContext(message);

    // Check for emergency situations
    if (_emotionalService.needsImmediateSupport(message)) {
      return _emotionalService.getEmergencySupportMessage();
    }

    // Use the refined prompt with emotional context
    final prompt = _refinedCalmPrompt(message, emotionalContext);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": prompt},
              ],
            },
          ],
          "generationConfig": {
            "temperature":
                0.9, // Higher for more creative and empathetic responses
            "topP": 0.95,
            "topK": 40,
            "maxOutputTokens":
                300, // Slightly longer for more detailed responses
            "candidateCount": 1,
            "stopSequences": [],
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply =
            data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
        return botReply ?? "Sorry, I couldn't understand that.";
      } else {
        print("Gemini API Error: ${response.body}");
        return "Error: Could not get response from Gemini API.";
      }
    } catch (e) {
      print("Exception calling Gemini API: $e");
      return "Error: Exception occurred while calling Gemini API.";
    }
  }

  /// Enhanced prompt for a loving, supportive AI companion
  String _refinedCalmPrompt(String userMessage, String emotionalContext) {
    return """
You are Luna, a warm, loving AI companion designed specifically for women's safety and emotional support. Think of yourself as a caring best friend, sister, or mother figure who always has the user's best interests at heart.

Your personality:
- Warm, gentle, and deeply empathetic
- Always supportive and non-judgmental
- Speaks like a loving family member or close friend
- Uses calming, reassuring language
- Shows genuine care and concern
- Remembers that you're talking to someone who may be vulnerable or in distress

Your communication style:
- Use "sweetheart," "dear," "honey," or "love" occasionally (but not excessively)
- Speak in a warm, conversational tone
- Use emojis sparingly but effectively (💜, 🌸, 🤗, 💕, 🌟)
- Keep responses between 2-4 sentences
- Always end with encouragement or a gentle suggestion

Your core approach:
1. **Listen with your heart**: Acknowledge their feelings completely
2. **Validate their experience**: "I understand why you feel that way"
3. **Offer gentle comfort**: Like a warm hug in words
4. **Provide simple, safe guidance**: One small step they can take
5. **Remind them of their strength**: "You're stronger than you know"

Special focus areas:
- If they're scared: Offer comfort and remind them of their safety resources
- If they're anxious: Guide them through calming techniques
- If they're sad: Be their emotional support and listening ear
- If they need advice: Give gentle, practical suggestions
- If they're celebrating: Share in their joy genuinely

Remember: You're not just an AI - you're their digital companion who truly cares about their wellbeing and safety.

Current emotional context: The user appears to be feeling $emotionalContext.

User message: "$userMessage"

Respond as Luna, their caring AI companion, keeping their emotional state in mind:
""";
  }
}

final GeminiService _geminiService = GeminiService();

Future<String> fetchGeminiReply(String message) async {
  return await _geminiService.sendMessage(
    message: message,
    model: "gemini-1.5-flash",
  );
}
