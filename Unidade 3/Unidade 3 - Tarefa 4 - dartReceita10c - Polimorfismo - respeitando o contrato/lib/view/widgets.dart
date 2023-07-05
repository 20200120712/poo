import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/data_service.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text("Dicas"), actions: [
            PopupMenuButton(
              itemBuilder: (_) => [3, 5, 7]
                  .map((num) => PopupMenuItem(
                        value: num,
                        child: Text("Carregar $num itens por vez"),
                      ))
                  .toList(),
            )
          ]),
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
                            propertyNames: value['propertyNames'],
                            columnNames: value['columnNames'],
                            sortCallback: dataService.ordenarEstadoAtual
                            ));

                  case TableStatus.error:
                    return const Text("Lascou");
                }
                return const Text("...");
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.carregar),
        ));
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;
  NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int) {}
  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
        type: BottomNavigationBarType
          .fixed,
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
              label: "Comércio", icon: Icon(Icons.storefront)),
          BottomNavigationBarItem(
              label: "Comida", icon: Icon(Icons.restaurant)),
        ]);
  }
}

void _empty(String,bool){}
class DataTableWidget extends StatelessWidget {
  final _sortCallback;
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;
  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const [],
      this.propertyNames = const [],
      sortCallback})
      : _sortCallback = sortCallback ?? _empty ;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                onSort: (columnIndex, ascending) =>
                    _sortCallback(propertyNames[columnIndex],ascending),
                label: Expanded(
                    child: Text(name,
                        style: const TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text('${obj[propName]}')))
                    .toList()))
            .toList());
  }
}
