Link para acesso ao codigo:

https://zapp.run/edit/receita-4-zg4406y3g450?file=lib/main.dart&entry=lib/main.dart


Exerc�cios

1. Fa�a com que a tabela seja desliz�vel verticalmente, para quando houver mais dados nela. Acrescente novos objetos ao List dataObjects pra testar.

2. Tem um componente bem interessante, o ListView e o ListTile. Copie e cole a classe DataBodyWidget. Renomeie a classe colada e sua f�brica para MytileWidget. O build dessa nova classe deve apresentar os dados em tiles e n�o mais num DataTable. Esteja livre para modificar o que for necess�rio na classe, inclusive f�brica e atributos. Fa�a um programa principal que teste seu novo componente.

Na tabela original da receita, h� um defeito enorme para torn�-la reutiliz�vel. Ela apenas exibe colunas com os nomes Nome, Estilo e IBU. N�o faz sentido se for pra exibir dados de caf� ou de pa�ses, por exemplo. A tabela tamb�m apenas exibe propriedades identificadas por name, style e ibu. Numa lista de objetos JSON de outra coisa que n�o seja cerveja, dificilmente os objetos da lista ter�o essas propriedades. Contorne essas restri��es. Um objeto de sua classe DataBodyWidget deve ser capaz de mostrar, numa tabela, o que a gente bem entender. Esteja livre para modificar o que quiser, incluindo f�brica, atributos, m�todo build etc. A solu��o � mais dif�cil de pensar do que de implementar ent�o, se voc� viajar muito na maionese, provavelmente estar� errado


3. Fa�a o mesmo da quest�o anterior em rela��o � quest�o 2.