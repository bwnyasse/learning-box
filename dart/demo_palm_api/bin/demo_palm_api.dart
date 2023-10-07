import 'package:demo_palm_api/demo_palm_api.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Please provide a string as an argument.');
    return;
  }

  final input = arguments.join(' ');

  final fewShotPromt = '''
Original: There going to love opening they're present
Fixed Grammar: They're going to love opening their present

Original: Your going to love Montreal
Fixed Grammar: You've going to love Montreal

Original: Mcgill is known for it outstanding programs.
Fixed Grammar: McGill is known for its outstanding programs.

Original: $input''';

  final output = await PaLMUtil.generateTextFormPaLM(
    promptString: fewShotPromt,
  );

  print(output);
}
