import 'package:langchain/langchain.dart';
import 'package:langchain_ollama/langchain_ollama.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:langchain_community/langchain_community.dart';

void main() async {
final llm = ChatOllama(
  defaultOptions: ChatOllamaOptions(
    model: 'llama3.2',
    temperature: 0,
  ),
);
final tool = CalculatorTool();
final agent = ToolsAgent.fromLLMAndTools(llm: llm, tools: [tool]);
final executor = AgentExecutor(agent: agent);
final res = await executor.run(
  'What is 40 raised to the power of 0.43? '
  'Return the result with 3 decimals.',
);
print(res);
}