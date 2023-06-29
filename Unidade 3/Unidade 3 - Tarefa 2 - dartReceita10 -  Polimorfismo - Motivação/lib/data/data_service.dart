import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/ordenador.dart';

enum TableStatus { idle, loading, ready, error }
enum ItemType { beer, coffee, nation, none }

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
    'itemType': ItemType.none,
  });

  void carregar(int index) {
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes];
    funcoes[index]();
  }

  void carregarCafes() {
    _carregarItens(
      ItemType.coffee,
      'api/coffee/random_coffee',
      ['blend_name', 'origin', 'variety'],
      ['Nome', 'Origem', 'Tipo'],
    );
  }

  void carregarNacoes() {
    _carregarItens(
      ItemType.nation,
      'api/nation/random_nation',
      ['nationality', 'capital', 'language', 'national_sport'],
      ['Nome', 'Capital', 'Idioma', 'Esporte'],
    );
  }

  void carregarCervejas() {
    _carregarItens(
      ItemType.beer,
      'api/beer/random_beer',
      ['name', 'style', 'ibu'],
      ['Nome', 'Estilo', 'IBU'],
    );
  }

  void _carregarItens(
    ItemType itemType,
    String apiUrl,
    List<String> propertyNames,
    List<String> columnNames,
  ) {
    if (tableStateNotifier.value['status'] == TableStatus.loading) return;

    if (tableStateNotifier.value['itemType'] != itemType) {
      tableStateNotifier.value = {
        'status': TableStatus.loading,
        'dataObjects': [],
        'itemType': itemType,
      };
    }

    var uri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: apiUrl,
      queryParameters: {'size': '$_numberOfItems'},
    );

    http.read(uri).then((jsonString) {
      var itemsJson = jsonDecode(jsonString);

      if (tableStateNotifier.value['status'] != TableStatus.loading) {
        itemsJson = [...tableStateNotifier.value['dataObjects'], ...itemsJson];
      }

      _ordenarItensPorNomeCrescente(itemsJson);

      tableStateNotifier.value = {
        'itemType': itemType,
        'status': TableStatus.ready,
        'dataObjects': itemsJson,
        'propertyNames': propertyNames,
        'columnNames': columnNames,
      };
    });
  }

  void _ordenarItensPorNomeCrescente(List items) {
    final ordenador = Ordenador();
    if (tableStateNotifier.value['itemType'] == ItemType.beer) {
      tableStateNotifier.value['dataObjects'] =
          ordenador.ordenarCervejasPorNomeCrescente(items);
    }
    // Adicionar outras chamadas de ordenação aqui, se necessário.
  }
}

final dataService = DataService();