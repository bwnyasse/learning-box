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

  Future<SearchOutPut> searchQuery({
    required String prompt,
    required String option,
  }) async {
    final response = await http.post(
      Uri.parse(
          'https://langchain-bigquery-chat-agent-o2f4t6inaa-nn.a.run.app'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'prompt': prompt,
        'option': option,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return SearchOutPut(output: response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
