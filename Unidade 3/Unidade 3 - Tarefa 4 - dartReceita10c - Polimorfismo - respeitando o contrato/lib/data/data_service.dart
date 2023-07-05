import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/ordenador.dart';

enum TableStatus { idle, loading, ready, error }
enum ItemType {
  company,
  commerce,
  food,
  none;

  String get asString => name;

  List<String> get columns => this == company
      ? ["Nome comércio", "Sufixo", "Indústria"]
      : this == commerce
          ? ["Departamento", "Preço", "Nome do produto"]
          : this == food
              ? ["Prato", "Descrição", "Ingrediente"]
                      : [];

  List<String> get properties => this == company
      ? ["business_name", "suffix", "industry"]
      : this == commerce
          ? ["department", "price", "product_name"]
          : this == food
              ? ["dish", "description", "ingredient"]
                      : [];
}

class OrdenadorExpert extends Decididor {
  final String propriedade;

  final bool crescente;

  OrdenadorExpert(this.propriedade, [this.crescente = true]);

  @override
  bool precisaTrocarAtualPeloProximo(atual, proximo) {
    try {
      final ordemCorreta = crescente ? [atual, proximo] : [proximo, atual];

      return ordemCorreta[0][propriedade]
              .compareTo(ordemCorreta[1][propriedade]) >
          0;
    } catch (error) {
      return false;
    }
  }
}

class DataService {
static const List<int> ITEM_COUNT_OPTIONS = [3, 5, 7];

  int _numberOfItems = ITEM_COUNT_OPTIONS.first;

  List<int> get popMenuItens => ITEM_COUNT_OPTIONS;

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
    'itemType': ItemType.none
  });

  void carregar(index) {
    final params = [ItemType.company, ItemType.commerce, ItemType.food];

    carregarPorTipo(params[index]);
  }

  void ordenarEstadoAtual(final String propriedade, [bool crescente=true]) {
    List objetos = tableStateNotifier.value['dataObjects'] ?? [];

    if (objetos == []) return;

    Ordenador ord = Ordenador();
    Decididor d = OrdenadorExpert(propriedade, crescente);
    var objetosOrdenados = ord.ordenarItens(objetos, d);
    emitirEstadoOrdenado(objetosOrdenados, propriedade);
  }

  Uri montarUri(ItemType type) {
    return Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/${type.asString}/random_${type.asString}',
        queryParameters: {'size': '$_numberOfItems'});
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
      'itemType': type
    };
  }

  void emitirEstadoPronto(ItemType type, var json) {
    tableStateNotifier.value = {
      'itemType': type,
      'status': TableStatus.ready,
      'dataObjects': json,
      'propertyNames': type.properties,
      'columnNames': type.columns
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
    var json = await acessarApi(uri); //, type);
    emitirEstadoPronto(type, json);
  }
}

final dataService = DataService();
