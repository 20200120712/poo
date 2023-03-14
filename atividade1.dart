class Produto {
  String nome;
  double preco;

  Produto(this.nome, this.preco);
}

class Item {
  Produto produto;
  int quantidade;

  Item(this.produto, this.quantidade);

  double getPrecoTotal() {
    return produto.preco * quantidade;
  }
}

class Venda {
  List<Item> itens;

  Venda(this.itens);

  double getTotal() {
    //Caso base da recursão: se a lista de itens estiver vazia, retorna 0.0
    if (itens.isEmpty) {
      return 0.0;
    } else {
      //Remove o último item da lista e calcula o subtotal somando o preço total do item
      //com o total dos demais itens (chamando recursivamente o método getTotal)
      Item item = itens.removeLast();
      double subtotal = item.getPrecoTotal() + getTotal();
      //Adiciona novamente o item na lista
      itens.add(item);
      return subtotal;
    }
  }
}

void main() {
  var produto1 = Produto('Produto 1', 10.0);
  var produto2 = Produto('Produto 2', 20.0);
  var produto3 = Produto('Produto 3', 30.0);

  var item1 = Item(produto1, 2);
  var item2 = Item(produto2, 1);
  var item3 = Item(produto3, 3);

  var venda = Venda([item1, item2, item3]);

  double total = venda.getTotal();
  print('Total: $total');
}
