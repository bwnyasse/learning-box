import 'package:flutter_moviesapp_demo_firebase_remote_config/src/models/impl/RecentMovies.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class MoviesComponent extends StatelessWidget {
  const MoviesComponent({
    Key? key,
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
              //TODO: RecentFileDataRow to MovieDataRow
              rows: List.generate(
                demoMovies.length,
                (index) => moviesDataRow(demoMovies[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow moviesDataRow(MovieItemInRow movieItem) {
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
              child: Text(movieItem.title!),
            ),
          ],
        ),
      ),
      DataCell(Text(movieItem.date!)),
      DataCell(Text(movieItem.average!)),
    ],
  );
}
