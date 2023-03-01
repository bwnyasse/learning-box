import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../models/models.dart';

class MoviesComponent extends StatelessWidget {
  final List<Movie> movies;
  const MoviesComponent({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              minWidth: 600,
              columns: const [
                DataColumn2(
                  label: Text("Movie's title"),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text("Release Date"),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text("Avg"),
                  size: ColumnSize.S,
                ),
              ],
              rows: List.generate(
                movies.length,
                (index) => moviesDataRow(movies[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow moviesDataRow(Movie item) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(item.title),
            ),
          ],
        ),
      ),
      DataCell(Text(item.releaseDate)),
      DataCell(Text("${item.voteAverage}")),
    ],
  );
}
