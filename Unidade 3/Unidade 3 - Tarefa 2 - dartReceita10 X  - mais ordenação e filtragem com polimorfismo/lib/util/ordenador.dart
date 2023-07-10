class Ordenador {
  List<dynamic> ordenarItens(List<dynamic> itens, String propriedade, [bool crescente = true]) {
    itens.sort((a, b) {
      final ordemCorreta = crescente ? [a, b] : [b, a];
      return ordemCorreta[0][propriedade].compareTo(ordemCorreta[1][propriedade]);
    });

    return itens;
  }
}
