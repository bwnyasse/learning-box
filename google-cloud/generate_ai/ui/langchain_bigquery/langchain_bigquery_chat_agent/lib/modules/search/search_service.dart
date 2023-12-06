import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/model.dart';

class SearchService {
  Future<SearchResponse> searchQueryFake(String prompt) async {
    String fakeJson = '''
{
  "ai": [
    {
      "thought": "Analyzing user data for insights.",
      "action": "data_analysis",
      "action_input": "user_data.csv",
      "observation": "High user engagement in the evenings."
    }
  ],
  "final_answer": "Based on the analysis, user engagement and sales are expected to grow, especially with targeted social media marketing."
}
''';

    return SearchResponse.fromJson(json.decode(fakeJson));
  }

  Future<SearchResponse> searchQuery(String prompt) async {
    final response = await http.post(
      Uri.parse(
          'https://langchain-bigquery-chat-agent-o2f4t6inaa-nn.a.run.app'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'prompt': prompt,
      }),
    );

    if (response.statusCode == 200) {
      String responseBody = response.body;

      // Remove additional quotes if they are wrapping the JSON string
      if (responseBody.startsWith('"') && responseBody.endsWith('"')) {
        responseBody = responseBody.substring(1, responseBody.length - 1);
      }

      // Replace escaped characters if necessary
      responseBody =
          responseBody.replaceAll(r'\n', '\n').replaceAll(r'\"', '"');

      // Replace the sequence of escaped backslash and quote (\\\") with a single backslash followed by a quote (\")
      responseBody = responseBody.replaceAll(r'\\\"', '\"');

// Now replace remaining escaped backslashes
      responseBody = responseBody.replaceAll(r'\\', '\\');

      print(responseBody);
      try {
        return SearchResponse.fromJson(json.decode(responseBody));
      } catch (e) {
        throw Exception('Error parsing JSON: $e');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
