Link para acesso ao codigo:

https://zapp.run/edit/receita-4-zg4406y3g450?file=lib/main.dart&entry=lib/main.dart


Exercícios

1. Faça com que a tabela seja deslizável verticalmente, para quando houver mais dados nela. Acrescente novos objetos ao List dataObjects pra testar.

2. Tem um componente bem interessante, o ListView e o ListTile. Copie e cole a classe DataBodyWidget. Renomeie a classe colada e sua fábrica para MytileWidget. O build dessa nova classe deve apresentar os dados em tiles e não mais num DataTable. Esteja livre para modificar o que for necessário na classe, inclusive fábrica e atributos. Faça um programa principal que teste seu novo componente.

Na tabela original da receita, há um defeito enorme para torná-la reutilizável. Ela apenas exibe colunas com os nomes Nome, Estilo e IBU. Não faz sentido se for pra exibir dados de café ou de países, por exemplo. A tabela também apenas exibe propriedades identificadas por name, style e ibu. Numa lista de objetos JSON de outra coisa que não seja cerveja, dificilmente os objetos da lista terão essas propriedades. Contorne essas restrições. Um objeto de sua classe DataBodyWidget deve ser capaz de mostrar, numa tabela, o que a gente bem entender. Esteja livre para modificar o que quiser, incluindo fábrica, atributos, método build etc. A solução é mais difícil de pensar do que de implementar então, se você viajar muito na maionese, provavelmente estará errado


3. Faça o mesmo da questão anterior em relação à questão 2.