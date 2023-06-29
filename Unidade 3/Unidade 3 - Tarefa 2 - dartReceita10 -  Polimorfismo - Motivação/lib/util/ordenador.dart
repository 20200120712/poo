class Ordenador {
  List ordenarCervejasPorNomeCrescente(List cervejas) {
    List cervejasOrdenadas = List.of(cervejas);
    cervejasOrdenadas.sort((a, b) => a['name'].compareTo(b['name']));
    return cervejasOrdenadas;
  }
}

