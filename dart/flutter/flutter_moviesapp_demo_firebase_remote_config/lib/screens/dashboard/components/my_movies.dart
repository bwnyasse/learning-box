import 'package:flutter_moviesapp_demo_firebase_remote_config/models/RecentMovies.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class MyMovies extends StatelessWidget {
  const MyMovies({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                demoRecentMovies.length,
                (index) => recentFileDataRow(demoRecentMovies[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentMovie fileInfo) {
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
              child: Text(fileInfo.title!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!)),
      DataCell(Text(fileInfo.average!)),
    ],
  );
}
