import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/data_service.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  int selectedNumberOfItems = dataService.numberOfItems;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas"),
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (_) => dataService.popMenuItems
                  .map(
                    (num) => PopupMenuItem<int>(
                      value: num,
                      child: Text("Carregar $num itens por vez"),
                    ),
                  )
                  .toList(),
              onSelected: (number) {
                dataService.numberOfItems = number;
              },
            )
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            switch (value['status']) {
              case TableStatus.idle:
                return const Center(child: Text("Toque em algum botão"));

              case TableStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case TableStatus.ready:
                return SingleChildScrollView(
                  child: DataTableWidget(
                    jsonObjects: value['dataObjects'],
                    columnNames: value['columnNames'],
                    propertyNames: value['propertyNames'],
                    sortCallback: dataService.ordenarEstadoAtual,
                  ),
                );

              case TableStatus.error:
                return const Text("Lascou");
            }

            return const Text("...");
          },
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({itemSelectedCallback}) : _itemSelectedCallback = itemSelectedCallback ?? (int) {}

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        state.value = index;
        _itemSelectedCallback(index);
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Compania",
          icon: Icon(Icons.apartment),
        ),
        BottomNavigationBarItem(
          label: "Comércio",
          icon: Icon(Icons.storefront),
        ),
        BottomNavigationBarItem(
          label: "Comida",
          icon: Icon(Icons.restaurant),
        ),
      ],
    );
  }
}


class DataTableWidget extends StatefulWidget {
  final Function(String, bool) sortCallback;
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget({
    this.jsonObjects = const [],
    this.columnNames = const [],
    this.propertyNames = const [],
    required this.sortCallback,
  });

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  int? _sortedColumnIndex;
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: widget.columnNames
          .asMap()
          .map((columnIndex, name) => MapEntry(
                columnIndex,
                DataColumn(
                  onSort: (columnIndex, ascending) {
                    bool isAscending = columnIndex == _sortedColumnIndex ? !_isAscending : true;
                    setState(() {
                      _sortedColumnIndex = columnIndex;
                      _isAscending = isAscending;
                    });
                    widget.sortCallback(widget.propertyNames[columnIndex], isAscending);
                  },
                  label: Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      if (_sortedColumnIndex == columnIndex)
                        Icon(
                          _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              ))
          .values
          .toList(),
      rows: widget.jsonObjects
          .map(
            (obj) => DataRow(
              cells: widget.propertyNames
                  .map((propName) => DataCell(Text('${obj[propName]}')))
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
