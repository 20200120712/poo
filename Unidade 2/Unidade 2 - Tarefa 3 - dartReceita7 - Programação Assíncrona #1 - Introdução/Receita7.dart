import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

const CAFES_TAB_INDEX = 0;
const CERVEJAS_TAB_INDEX = 1;
const NACOES_TAB_INDEX = 2;

class DataService {
  final ValueNotifier<List<dynamic>> tableStateNotifier = ValueNotifier([]);
  final selectedQuantity = ValueNotifier(5);
  
  DataService();

  void carregar(int index, BuildContext context) {
    int quantidade = selectedQuantity.value;
    if (index == CAFES_TAB_INDEX)
      carregarCafes(quantidade, context);
    else if (index == CERVEJAS_TAB_INDEX)
      carregarCervejas(quantidade, context);
    else if (index == NACOES_TAB_INDEX) carregarNacoes(quantidade, context);
  }

  void carregarDados(String url, BuildContext context) async {
  try {
    var uri = Uri.parse(url);
    var resposta = await http.get(uri);
    if (resposta.statusCode == 200) {
      var dadosJson = jsonDecode(resposta.body);
      tableStateNotifier.value = dadosJson;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados carregados!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Erro: $e')));
  }
}
  void carregarCafes(int quantidade, BuildContext context) {
    carregarDados(
        'https://random-data-api.com/api/coffee/random_coffee?size=$quantidade',
        context);
  }

  void carregarCervejas(int quantidade, BuildContext context) {
    carregarDados(
        'https://random-data-api.com/api/beer/random_beer?size=$quantidade',
        context);
  }

  void carregarNacoes(int quantidade, BuildContext context) {
    carregarDados(
        'https://random-data-api.com/api/nation/random_nation?size=$quantidade',
        context);
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
      theme: ThemeData(primarySwatch: Colors.grey),
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
                    propertyNames: ["id","uid","brand","name","style","hop","yeast","malts","ibu","alcohol","blg"],
                    columnNames: ["Id","Uid","Brand","Name","Style","Hop","Yeast","Malts","IBU","Alcohol","Blg"],
                  );
                } else if (value[0].containsKey("notes")) {
                  return DataTableWidget(
                    jsonObjects: value,
                    propertyNames: ["id","uid","blend_name","origin","variety","notes","intensifier"],
                    columnNames: ["Id","Uid","Blend_name","Origin","Variety","Notes","Intensifier"],
                  );
                } else if (value[0].containsKey("language")) {
                  return DataTableWidget(
                    jsonObjects: value,
                    propertyNames: ["id","uid","nationality","language","capital","national_sport","flag"],
                    columnNames: ["Id","Uid","Nationality","Language","Capital","National_sport","Flag"],
                  );
                }
              }
              return const Center(child: Text("Toque algum botão, abaixo..."));
            }),
        bottomNavigationBar: Stack(
          children: [
            NewNavBar(itemSelectedCallback: dataService.carregar),
            Positioned(
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: dataService.selectedQuantity,
                  builder: (_, value, __) {
                    return DropdownButton(
                      value: value,
                      items: [
                        DropdownMenuItem(child: Text('5'), value: 5),
                        DropdownMenuItem(child: Text('10'), value: 10),
                        DropdownMenuItem(child: Text('15'), value: 15),
                      ],
                      onChanged: (value) => dataService.selectedQuantity.value = value as int,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  final Function(int, BuildContext) itemSelectedCallback;

  NewNavBar({required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
      onTap: (int index) {
        state.value = index;
        itemSelectedCallback(index, context);
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.coffee),
          label: 'Cafés',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_drink),
          label: 'Cervejas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'Nações',
        ),
      ],
      backgroundColor: Colors.grey[300],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.red,

    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List<dynamic> jsonObjects;
  final List<String> propertyNames;
  final List<String> columnNames;

  const DataTableWidget({
    Key? key,
    required this.jsonObjects,
    required this.propertyNames,
    required this.columnNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: getColumns(),
          rows: getRows(),
        ),
      ),
    );
  }

  List<DataColumn> getColumns() {
    return List.generate(
      columnNames.length,
      (index) => DataColumn(
        label: Text(columnNames[index]),
      ),
    );
  }

  List<DataRow> getRows() {
    return List.generate(
      jsonObjects.length,
      (index) {
        return DataRow(
          cells: List.generate(
            propertyNames.length,
            (cellIndex) => DataCell(
              Text('${jsonObjects[index][propertyNames[cellIndex]]}'),
            ),
          ),
        );
      },
    );
  }
}