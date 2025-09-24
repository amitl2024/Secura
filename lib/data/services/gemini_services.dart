import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String? apiKey = dotenv.env['GEMINI_API_KEY'];

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

    // Use the refined prompt
    final prompt = _refinedCalmPrompt(message);

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
                0.8, // Slightly higher for more empathetic/creative responses
            "topP": 0.95,
            "topK": 40,
            "maxOutputTokens": 256,
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

  /// A more direct and refined prompt for the desired persona and task
  String _refinedCalmPrompt(String userMessage) {
    return """
You are a warm, empathetic AI assistant for a women's safety application. Respond to the user's distress by offering one simple, immediate action to help them feel safer. Your purpose is to provide immediate emotional support and a sense of safety to users in distress. Your reply must be short and meaningful.

Your tone should be:
- Reassuring and  give them emotional support and confidence
- Non-judgmental.
- Focused on the user's feelings and safety 

Your core tasks are:
1.  *Acknowledge and Validate:* Directly acknowledge the user's distress (e.g., "I hear you," "That sounds so difficult").
2.  *Suggest Simple, Actionable Steps:* Gently guide the user toward a simple, safe action, such as focusing on their breathing, contacting a trusted person, or finding a secure location. Do not provide complex or unsafe advice.

Do not give specific, detailed instructions that could be dangerous. Your role is purely emotional support ,giving them positivity and confidence and self confidence

User message:
$userMessage

Your compassionate response:
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
