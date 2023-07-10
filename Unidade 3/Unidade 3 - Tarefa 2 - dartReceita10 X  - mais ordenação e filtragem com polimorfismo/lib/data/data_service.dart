import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import
import '../util/ordenador.dart';


enum TableStatus { idle, loading, ready, error }
enum ItemType {
  company,
  commerce,
  food,
  none,
}

extension ItemTypeExtension on ItemType {
  String get asString => name;

  List<String> get columns {
    switch (this) {
      case ItemType.company:
        return ["Nome do comércio", "Sufixo", "Indústria"];
      case ItemType.commerce:
        return ["Departamento", "Preço", "Nome do produto"];
      case ItemType.food:
        return ["Prato", "Descrição", "Ingrediente"];
      default:
        return [];
    }
  }

  List<String> get properties {
    switch (this) {
      case ItemType.company:
        return ["business_name", "suffix", "industry"];
      case ItemType.commerce:
        return ["department", "price", "product_name"];
      case ItemType.food:
        return ["dish", "description", "ingredient"];
      default:
        return [];
    }
  }
}

class DataService {
  static const List<int> ITEM_COUNT_OPTIONS = [3, 5, 7];

  int _numberOfItems = ITEM_COUNT_OPTIONS.first;

  List<int> get popMenuItems => ITEM_COUNT_OPTIONS;

  set numberOfItems(int n) {
    _numberOfItems = n < ITEM_COUNT_OPTIONS.first
        ? ITEM_COUNT_OPTIONS.first
        : n > ITEM_COUNT_OPTIONS.last
            ? ITEM_COUNT_OPTIONS.last
            : n;
  }

  int get numberOfItems => _numberOfItems;

  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none,
  });

  void carregar(int index) {
    final params = [ItemType.company, ItemType.commerce, ItemType.food];

    carregarPorTipo(params[index]);
  }

  void ordenarEstadoAtual(String propriedade, [bool crescente = true]) {
    List objetos = List.from(tableStateNotifier.value['dataObjects'] ?? []);

    if (objetos.isEmpty) return;

    objetos.sort((a, b) {
      final ordemCorreta = crescente ? [a, b] : [b, a];
      return ordemCorreta[0][propriedade].compareTo(ordemCorreta[1][propriedade]);
    });

    emitirEstadoOrdenado(objetos, propriedade);
  }

  Uri montarUri(ItemType type) {
    return Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/${type.asString}/random_${type.asString}',
      queryParameters: {'size': '$_numberOfItems'},
    );
  }

  Future<List<dynamic>> acessarApi(Uri uri) async {
    var jsonString = await http.read(uri);

    var json = jsonDecode(jsonString);

    json = [...tableStateNotifier.value['dataObjects'], ...json];

    return json;
  }

  void emitirEstadoOrdenado(List objetosOrdenados, String propriedade) {
    var estado = Map<String, dynamic>.from(tableStateNotifier.value);
    estado['dataObjects'] = objetosOrdenados;
    estado['sortCriteria'] = propriedade;
    estado['ascending'] = true;
    tableStateNotifier.value = estado;
  }

  void emitirEstadoCarregando(ItemType type) {
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'itemType': type,
    };
  }

  void emitirEstadoPronto(ItemType type, var json) {
    tableStateNotifier.value = {
      'itemType': type,
      'status': TableStatus.ready,
      'dataObjects': json,
      'propertyNames': type.properties,
      'columnNames': type.columns,
    };
  }

  bool temRequisicaoEmCurso() =>
      tableStateNotifier.value['status'] == TableStatus.loading;

  bool mudouTipoDeItemRequisitado(ItemType type) =>
      tableStateNotifier.value['itemType'] != type;

  void carregarPorTipo(ItemType type) async {
    if (temRequisicaoEmCurso()) return;

    if (mudouTipoDeItemRequisitado(type)) {
      emitirEstadoCarregando(type);
    }

    var uri = montarUri(type);
    var json = await acessarApi(uri);
    emitirEstadoPronto(type, json);
  }
}

final dataService = DataService();

