import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) {
  // Directory containing the CSV files
  var dir = Directory('assets');

  var outputData = <List<dynamic>?>[];

  // Header
  outputData.add([
    'Month',
    'Usage cost (\$)',
    'Sustained use discounts (\$)',
    'Free tiers (\$)',
    'Spending based discounts (contractual) (\$)',
    'Cost (\$)',
    'Total credits (discounts, promotional & other credits) (\$)',
    'Subtotal (\$)',
    'GST/HST (5.0%) (\$)',
    'Tax (9.975%) (\$)',
    'Total (\$)'
  ]);

  // Loop through each file in the directory
  for (var file in dir.listSync()) {
    if (file is File && file.path.endsWith('.csv')) {
      var filenameParts = path.basenameWithoutExtension(file.path).split(' ');
      var dateParts = filenameParts[4]
          .split('-'); // Extracts '2022-10' for October 2022, for example.
      var year = dateParts[0];
      var month = dateParts[1];
      var formattedDate = '01/$month/$year';

      var  content = file.readAsStringSync().toString();
      print(content);
      print("----");
      var csvData = CsvToListConverter().convert(content);

      // Assuming first row of CSV is heade   r
      if (csvData.first.length > 1) {
        var dataRow = csvData[1];
        // Adding the month at the beginning
        dataRow.insert(0, formattedDate);
        outputData.add(dataRow);
      } else {
        print('Skipping ${file.path} as it has no data.');
      }
    }
  }

  // Write the combined data to an output CSV
  File('output/output.csv')
      .writeAsStringSync(const ListToCsvConverter().convert(outputData));

  print('CSV processing complete!');
}
