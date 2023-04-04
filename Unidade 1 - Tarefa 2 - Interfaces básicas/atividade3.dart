import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cervejas',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cervejas'),
        ),
        body: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Nome')),
              DataColumn(label: Text('Estilo')),
              DataColumn(label: Text('IBU')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('La Fin Du Monde')),
                DataCell(Text('Bock')),
                DataCell(Text('65')),
              ]),
              DataRow(cells: [
                DataCell(Text('Sapporo Premium')),
                DataCell(Text('Sour Ale')),
                DataCell(Text('54')),
              ]),
              DataRow(cells: [
                DataCell(Text('Duvel')),
                DataCell(Text('Pilsner')),
                DataCell(Text('82')),
              ]),
              DataRow(cells: [
                DataCell(Text('Guinness Draught')),
                DataCell(Text('Stout')),
                DataCell(Text('45')),
              ]),
              DataRow(cells: [
                DataCell(Text('Heineken')),
                DataCell(Text('Pilsner')),
                DataCell(Text('26')),
              ]),
              DataRow(cells: [
                DataCell(Text('Chimay Blue')),
                DataCell(Text('Belgian Strong Ale')),
                DataCell(Text('70')),
              ]),
              DataRow(cells: [
                DataCell(Text('Brooklyn Lager')),
                DataCell(Text('Lager')),
                DataCell(Text('47')),
              ]),
              DataRow(cells: [
                DataCell(Text('Weihenstephaner Hefeweissbier')),
                DataCell(Text('Hefeweizen')),
                DataCell(Text('14')),
              ]),
              DataRow(cells: [
                DataCell(Text('Brahma Chopp')),
                DataCell(Text('Pale Lager')),
                DataCell(Text('10')),
              ]),
              DataRow(cells: [
                DataCell(Text('Coca-Cola')),
                DataCell(Text('Soft Drink')),
                DataCell(Text('0')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
