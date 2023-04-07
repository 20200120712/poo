Exercícios
Modifique os valores do primarySwatch e veja os efeitos na interface.

Modifique algum texto do body, tente estilizá-lo, mudar a fonte ou botar em negrito. Como fazer? Pesquise flutter styled text.

Há um widget complementar ao Column, que é o Row, que serve para alinhar uma coleção de widgets um ao lado do outro e não um abaixo do outro. Use esse widget e ponha três Text no bottomNavigationBar.

Em vez de Text na barra de navegação inferior, use botões de verdade, é de se esperar que haja fábricas para isso. Pesquise por flutter ElevatedButton example e desenrole.

Faça com que um dos botões seja um botão de ícone. Pesquise por flutter IconButton example e seja feliz.

Faça com que os botões fiquem centralizados. Você pode precisar de widgets Expanded para isso. Pode haver outras soluções sem Expanded também.

Há muitas e muitas outras coisas que podemos botar nas caixas ThemeData. Que tal dar uma olhada e modificar seu programa para que a fonte default dos componentes de texto seja uma fonte escolhida por você.

Aquela coleção children no widget Column não precisa ser uma coleção apenas de Text. A coleção pode ter dentro dela quaisquer widgets e pode ter widgets de fábricas diferentes dentro dela! Pode ter um texto, dois botões e uma imagem, por exemplo. Assim, acrescente àqueles 3 Text uma imagem da internet. É muito simples. Se você mexer em muita coisa, provavelmente está errado. Lembre que a imagem deve ser carregada da internet (via URL) e não do disco rígido. Não vou dar dica de pesquisa dessa vez, veja como você se sai por si próprio.

É muito chato para o usuário ficar esperando sem ver nada enquanto uma imagem é carregada da internet. Exiba alguma imagem alternativa enquanto o carregamento estiver acontecendo e faça um efeito de fade in quando a imagem finalmente for carregada. Sem dicas de pesquisa.

Faça um novo aplicativo. Pode copiar e colar o app dessa receita para começar. Substitua title do AppBar por um texto com o string "Cervejas". Em seguida, substitua o body do Scaffold por uma tabela, essa tabela pode ser construída através do widget DataTable. Os cabeçalhos das colunas da tabela devem ter os rótulos "Nome", "Estilo" e "IBU".  Preencha a tabela com 3 linhas. A linha 1 deve ter os valores La Fin Du Monde, Bock e 65. A linha 2 deve ter os valores Sapporo Premium, Sour Ale e 54. E a linha 3 deve ter os valores Duvel, Pilsner e 82. 

Tente acrescentar diversas outras linhas (invente os dados). O que acontece quando as informações não cabem mais na tela? Que tal fazer com que se possa deslizar pelos dados da tabela através do mouse ou de gesto com o dedo? É bem mais fácil do que parece e tem tudo a vem com a moral dessa receita. Ache uma caixa que saiba implementar essa funcionalidade (isso se chava scroll) e fabrique essa caixa colocando seu DataTable dentro dela. E só.
