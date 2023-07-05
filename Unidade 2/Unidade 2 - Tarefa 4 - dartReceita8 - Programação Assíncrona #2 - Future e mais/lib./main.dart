import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

const CAFES_TAB_INDEX = 0;
const CERVEJAS_TAB_INDEX = 1;
const NACOES_TAB_INDEX = 2;
const USUARIO_TAB_INDEX = 3;

class DataService {
  final ValueNotifier<List<dynamic>> tableStateNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> columnNamesNotifier = ValueNotifier([]);
  final selectedQuantity = ValueNotifier(5);

  DataService();

  void carregar(int index, BuildContext context) {
    int quantidade = selectedQuantity.value;
    if (index == CAFES_TAB_INDEX)
      carregarCafes(quantidade, context);
    else if (index == CERVEJAS_TAB_INDEX)
      carregarCervejas(quantidade, context);
    else if (index == NACOES_TAB_INDEX)
      carregarNacoes(quantidade, context);
    else if (index == USUARIO_TAB_INDEX)
      carregarUsuarios(quantidade, context);
  }

  void carregarDadosAsync(String url, List<String> columnNames, BuildContext context) async {
    try {
      var uri = Uri.parse(url);
      var resposta = await http.get(uri);
      if (resposta.statusCode == 200) {
        var dadosJson = jsonDecode(resposta.body);
        tableStateNotifier.value = dadosJson;
        columnNamesNotifier.value = columnNames;
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

  void carregarNacoes(int quantidade, BuildContext context) {
    List<String> columnNames = [
      "id",
      "uid",
      "nationality",
      "language",
      "capital",
      "national_sport",
      "flag"
    ];
    carregarDadosAsync(
        'https://random-data-api.com/api/nation/random_nation?size=$quantidade',
        columnNames,
        context);
  }

  void carregarCafes(int quantidade, BuildContext context) {
    List<String> columnNames = [
      "id",
      "uid",
      "blend_name",
      "origin",
      "variety",
      "intensifier"
    ];
    carregarDadosAsync(
        'https://random-data-api.com/api/coffee/random_coffee?size=$quantidade',
        columnNames,
        context);
  }

  void carregarCervejas(int quantidade, BuildContext context) {
    List<String> columnNames = [
      "id",
      "uid",
      "brand",
      "name",
      "style",
      "blg"
    ];
    carregarDadosAsync(
        'https://random-data-api.com/api/beer/random_beer?size=$quantidade',
        columnNames,
        context);
  }

  void carregarUsuarios(int quantidade, BuildContext context) {
    List<String> columnNames = [
      "id",
      "uid",
      "first_name",
      "last_name",
      "email",
      "username"
    ];
    carregarDadosAsync(
        'https://random-data-api.com/api/users/random_user?size=$quantidade',
        columnNames,
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
        body: Center(
          child: ValueListenableBuilder(
            valueListenable: dataService.tableStateNotifier,
            builder: (_, value, __) {
              if (value.isNotEmpty) {
                List<String> columnNames = dataService.columnNamesNotifier.value;
                return DataTableWidget(
                  jsonObjects: value,
                  columnNames: columnNames,
                );
              } else {
                return WelcomeWidget();
              }
            },
          ),
        ),
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
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Usuário',
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
  final List<String> columnNames;

  const DataTableWidget({
    Key? key,
    required this.jsonObjects,
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
    return columnNames.map((columnName) {
      return DataColumn(
        label: Text(columnName),
      );
    }).toList();
  }

  List<DataRow> getRows() {
    return jsonObjects.map((jsonObject) {
      return DataRow(
        cells: columnNames.map((columnName) {
          return DataCell(
            Text('${jsonObject[columnName]}'),
          );
        }).toList(),
      );
    }).toList();
  }
}

class WelcomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/minha_imagem.jpg',
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 16),
        const Text(
          'Bora colocar para rodar?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Toque em um dos botões abaixo para carregar os dados.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
