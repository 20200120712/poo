class Ordenador {
  List ordenarListagem(List objetos, Decididor decididor) {
    List objetosOrdenados = List.of(objetos);
    bool trocouAoMenosUm;

    do {
      trocouAoMenosUm = false;

      for (int i = 0; i < objetosOrdenados.length - 1; i++) {
        var atual = objetosOrdenados[i];
        var proximo = objetosOrdenados[i + 1];

        if (decididor.precisaTrocarAtualPeloProximo(atual, proximo)) {
          var aux = objetosOrdenados[i];
          objetosOrdenados[i] = objetosOrdenados[i + 1];
          objetosOrdenados[i + 1] = aux;
          trocouAoMenosUm = true;
        }
      }
    } while (trocouAoMenosUm);

    return objetosOrdenados;
  }
}

abstract class Decididor {
  bool precisaTrocarAtualPeloProximo(dynamic atual, dynamic proximo);
}

class DecididorCervejaNomeCrescente extends Decididor {
  @override
  bool precisaTrocarAtualPeloProximo(atual, proximo) {
    try {
      return atual["name"].compareTo(proximo["name"]) > 0;
    } catch (error) {
      return false;
    }
  }
}

class DecididorCervejaEstiloCrescente extends Decididor {
  @override
  bool precisaTrocarAtualPeloProximo(atual, proximo) {
    try {
      return atual["style"].compareTo(proximo["style"]) > 0;
    } catch (error) {
      return false;
    }
  }
}

class DecididorCervejaNomeDecrescente extends Decididor {
  @override
  bool precisaTrocarAtualPeloProximo(atual, proximo) {
    try {
      return atual["name"].compareTo(proximo["name"]) < 0;
    } catch (error) {
      return false;
    }
  }
}

class DecididorCervejaEstiloDecrescente extends Decididor {
  @override
  bool precisaTrocarAtualPeloProximo(atual, proximo) {
    try {
      return atual["style"].compareTo(proximo["style"]) < 0;
    } catch (error) {
      return false;
    }
  }
}
