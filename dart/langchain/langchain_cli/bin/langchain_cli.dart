import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

void main(List<String> arguments) async {
  ///
  /// The API key is stored in the local .env file. Create one if you want to run
  /// this example or replace this apiKey with your own.
  ///
  /// DO NOT PUBLICLY SHARE YOUR API KEY.
  /// .env file should have a line that looks like this:
  ///
  final env = DotEnv(includePlatformEnvironment: true)..load();
  var openAiApiKey = env['OPENAI_API_KEY'];

  if (openAiApiKey == null) {
    stderr.writeln('You need to set your OpenAI key in the '
        'OPENAI_API_KEY environment variable.');
    exit(1);
  }

  final llm = ChatOpenAI(
    apiKey: openAiApiKey,
    temperature: 0.9,
  );

  stdout.writeln('How can I help you Boris?');

  while (true) {
    stdout.writeln();
    stdout.write('> ');
    final query = stdin.readLineSync() ?? '';
    final humanMessage = ChatMessage.humanText(query);
    final aiMessage = await llm.call([humanMessage]);
    stdout.writeln(aiMessage.content.trim());
  }
}
