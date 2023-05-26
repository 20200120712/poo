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
  final tableColumnNames = ValueNotifier(<String>[]);
  final List<String> cafeColumnNames = [
    "Id",
    "Uid",
    "Brand",
    "Name",
    "Style",
    "IBU",
    "Blg"
  ];
  final List<String> cervejaColumnNames = [
    "Id",
    "Uid",
    "Blend_name",
    "Origin",
    "Variety",
    "Notes",
    "Intensifier"
  ];
  final List<String> nacoesColumnNames = [
    "Id",
    "Uid",
    "Nationality",
    "Language",
    "Capital",
    "National_sport",
    "Flag"
  ];

  DataService();

  void carregar(int index, BuildContext context) {
    int quantidade = selectedQuantity.value;
    if (index == CAFES_TAB_INDEX)
      carregarCafes(quantidade, context);
    else if (index == CERVEJAS_TAB_INDEX)
      carregarCervejas(quantidade, context);
    else if (index == NACOES_TAB_INDEX) carregarNacoes(quantidade, context);
  }

  void carregarDados(String url, BuildContext context, List<String> columnNames) async {
    try {
      var uri = Uri.parse(url);
      var resposta = await http.get(uri);
      if (resposta.statusCode == 200) {
        var dadosJson = jsonDecode(resposta.body);
        tableStateNotifier.value = dadosJson;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dados carregados!')));
        // Atualiza a lista de nomes de colunas
        tableColumnNames.value = columnNames;
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
        context, cafeColumnNames);
  }

  void carregarCervejas(int quantidade, BuildContext context) {
    carregarDados(
        'https://random-data-api.com/api/beer/random_beer?size=$quantidade',
        context, cervejaColumnNames);
  }

  void carregarNacoes(int quantidade, BuildContext context) {
    carregarDados(
        'https://random-data-api.com/api/nation/random_nation?size=$quantidade',
        context, nacoesColumnNames);
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
                    propertyNames: ["id","uid","brand","name","style","ibu","blg"],
                    columnNames: ["Id","Uid","Brand","Name","Style","IBU","Blg"],
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
              return Container(
                alignment: Alignment.center,
child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/file.jpg',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bem-vindo ao nosso aplicativo!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Para começar, toque em um dos botões abaixo para carregar dados aleatórios:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => dataService.carregar(
                            CAFES_TAB_INDEX,
                            context,
                          ),
                          child: Text('Cafés'),
                        ),
                        ElevatedButton(
                          onPressed: () => dataService.carregar(
                            CERVEJAS_TAB_INDEX,
                            context,
                          ),
                          child: Text('Cervejas'),
                        ),
                        ElevatedButton(
                          onPressed: () => dataService.carregar(
                            NACOES_TAB_INDEX,
                            context,
                          ),
                          child: Text('Nações'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class DataTableWidget extends HookWidget {
  final List<dynamic> jsonObjects;
  final List<String> propertyNames;
  final List<String> columnNames;

  DataTableWidget({
    required this.jsonObjects,
    required this.propertyNames,
    required this.columnNames,
  });

  @override
  Widget build(BuildContext context) {
    final _sortAscending = useState(true);
    final _sortColumnIndex = useState<int?>(null);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortAscending: _sortAscending.value,
        sortColumnIndex: _sortColumnIndex.value,
        columns: columnNames
            .map((columnName) => DataColumn(
                  label: Text(columnName),
                  onSort: (columnIndex, ascending) {
                    _sortColumnIndex.value = columnIndex;
                    _sortAscending.value = ascending;
                  },
                ))
            .toList(),
        rows: jsonObjects
            .map((jsonObject) => DataRow(
                  cells: propertyNames
                      .map((propertyName) => DataCell(
                            Text(jsonObject[propertyName].toString()),
                          ))
                      .toList(),
                ))
            .toList(),
      ),
    );
  }
}