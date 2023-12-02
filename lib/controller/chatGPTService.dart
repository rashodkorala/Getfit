import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGPTService {
  Future<String> sendPromptToOpenAI(String prompt) async {
    const String apiKey = "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";
    final Uri url = Uri.parse(
        "https://api.openai.com/v1/engines/text-davinci-003/completions");

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
