import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/data_service.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedNumberOfItems = DataService().numberOfItems;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas"),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => dataService.popMenuItens
                  .map(
                    (num) => CheckedPopupMenuItem(
                      value: num,
                      checked: selectedNumberOfItems == num,
                      child: Text("Carregar $num itens por vez"),
                    ),
                  )
                  .toList(),
              onSelected: (number) {
                setState(() {
                  selectedNumberOfItems = number;
                });
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
                return Center(child: Text("Toque em algum botão"));

              case TableStatus.loading:
                return Center(child: CircularProgressIndicator());

              case TableStatus.ready:
                return SingleChildScrollView(
                  child: DataTableWidget(
                    jsonObjects: value['dataObjects'],
                    propertyNames: value['propertyNames'],
                    columnNames: value['columnNames'],
                  ),
                );

              case TableStatus.error:
                return Text("Lascou");
            }

            return Text("...");
          },
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
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
        onTap: (index) {
          state.value = index;

          _itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Cafés",
            icon: Icon(Icons.coffee_outlined),
          ),
          BottomNavigationBarItem(
              label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
          BottomNavigationBarItem(
              label: "Nações", icon: Icon(Icons.public_outlined))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List propertyNames;
  final List columnNames;

  DataTableWidget({
    required this.jsonObjects,
    required this.propertyNames,
    required this.columnNames,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columnNames
          .map(
            (columnName) => DataColumn(label: Text(columnName)),
          )
          .toList(),
      rows: jsonObjects
          .map(
            (jsonObject) => DataRow(
              cells: propertyNames
                  .map(
                    (propertyName) => DataCell(
                      Text(jsonObject[propertyName].toString()),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
