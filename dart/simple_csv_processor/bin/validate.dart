import 'package:csv/csv.dart';

void main(List<String> args) {
  var value = """Usage cost ;Sustained use discounts ;Free tiers ;Spending based discounts (contractual) ;Cost ;Total credits (discounts, promotional & other credits) ;Subtotal ;GST/HST (5.0%) ;Tax (9.975%) ;Total
27,957.02;-2,434.68;-29.34;-4.11;27,957.02;-2,468.13;25,488.89;1,274.44;2,542.52;29,305.85""";
        var rowsAsListOfValues = CsvToListConverter().convert(value);
      print(rowsAsListOfValues.first);
      // Assuming first row of CSV is heade   r
      if (rowsAsListOfValues.first.length > 1) {
      } else {
        print('Skipping as it has no data.');
      }
}