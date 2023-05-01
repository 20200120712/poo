import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class DataService {
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);

  void carregar(int index) {
  var listas = [carregarCafes, carregarCervejas, carregarNacoes];
  listas[index]();
}

  void carregarCervejas() {
    tableStateNotifier.value = [
      {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
      {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
      {"name": "Duvel", "style": "Pilsner", "ibu": "82"}
    ];
  }

  void carregarCafes() {
    tableStateNotifier.value = [
      {
        "name": "Café brasileiro",
        "origem": "Brasil",
        "nota": "4.5"
      },
      {
        "name": "Café colombiano",
        "origem": "Colômbia",
        "nota": "4.8"
      },
      {
        "name": "Café etíope",
        "origem": "Etiópia",
        "nota": "4.6"
      }
    ];
  }

  void carregarNacoes() {
    tableStateNotifier.value = [
      {
        "name": "Brasil",
        "population": "211 milhões",
        "language": "Português"
      },
      {
        "name": "EUA",
        "population": "331 milhões",
        "language": "Inglês"
      },
      {
        "name": "Japão",
        "population": "126 milhões",
        "language": "Japonês"
      }
    ];
  }
}

final dataService = DataService();

void main() { 
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Dicas")),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            if (value.isNotEmpty) {
              if (value[0].containsKey("ibu")) {  
                return DataTableWidget(
                  jsonObjects: value,
                  propertyNames: ["name", "style", "ibu"],
                  columnNames: ["Nome", "Estilo", "IBU"],
                );
              } 
              else if (value[0].containsKey("nota")) {
                  return DataTableWidget(
                    jsonObjects: value,
                    propertyNames: ["name", "origem", "nota"],
                    columnNames: ["Nome", "Origem", "Nota"],
                  );
              } else if (value[0].containsKey("language")) {
                  return DataTableWidget(
                    jsonObjects: value,
                    propertyNames: ["name", "population", "language"],
                    columnNames: ["Nome", "População", "Idioma"],
                  );
              }
            }
            return const Center(child: Text("Nenhum item encontrado."));
          }
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  final Function(int) itemSelectedCallback;

  NewNavBar({required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
      onTap: (int index) {
        state.value = index;
        itemSelectedCallback(index);
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas", 
          icon: Icon(Icons.local_drink_outlined)
        ),
        BottomNavigationBarItem(
          label: "Nações", 
          icon: Icon(Icons.flag_outlined)
        )
      ]
    );
  }
}

// ...

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;

  final List<String> columnNames;

  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const ["Nome", "Estilo", "IBU"],
      this.propertyNames = const ["name", "style", "ibu"]});
  

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}