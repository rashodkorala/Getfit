import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGPTService {
  Future<String> sendPromptToOpenAI(String prompt) async {
    final String apiKey = "YOUR_API_KEY";
    final Uri url = Uri.parse(
        "https://api.openai.com/v1/engines/gpt-3.5-turbo-instruct/completions");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': prompt,
          'max_tokens': 3000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['choices'][0]['text'];
      } else {
        throw Exception('Failed to get response from OpenAI: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending prompt to OpenAI: $e');
    }
  }
}
