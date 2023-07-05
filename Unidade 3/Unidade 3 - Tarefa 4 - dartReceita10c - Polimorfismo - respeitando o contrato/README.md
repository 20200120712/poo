# Tarefa 2 - Unidade 3 - Receita10

[Acesso rápido - clique aqui](https://zapp.run/edit/tarefa-2-z2qk066l3ql0?entry=lib%2Fmain.dart)

## Exercícios

1. Para a próxima aula, você precisará refletir e debater sobre o porquê de eu ter escrito que chamar o objeto dataService ali de dentro do DataTableWidget era seboso. Não me decepcione.

2. Implemente todas as ordenações possíveis nesse estilo proposto pela receita, replicando código.

3. Você já treinou conhecimentos, ao longo das receitas, para retirar essa replicação de código sem apelar para o método de ordenação que o dart oferece. Tente fazer isso! Lembre que ordenação tem que ser feita via seu Ordenador.

# Tarefa 3 - Unidade 3 - Receita10b

[Acesso rápido - clique aqui](https://zapp.run/edit/tarefa-3-z4fi06bs4fj0)

## Exercícios

1. Faça todas as ordenações, sempre chamando o mesmo método. Tente evitar novas replicações de código, ainda dá pra melhorar. Nas minhas contas, basta uma classe herdando o Decididor para abarcar todas essas ordenações de objetos JSON de uma lapada só. 

# Tarefa 4 - Unidade 3 - Receita10c

[Acesso rápido - clique aqui](https://zapp.run/edit/unidade-3-zwcy06ztwcz0)

## Exercícios

1. Algumas escolhas de nome que eu faço são meramente didáticas. Assim, uma classe cujo objetivo é comparar dois objetos não deve ter o nome "FuncionarioDoMes". Usar ComparadorJSON ou DecididorJSON como nome (a classe só funciona para comparação de objetos JSON) seria uma prática mais adequada de programação. Faça essa modificação.

2. Atualmente, uma das maneiras mais populares de se promover polimorfismo é o uso das callback functions. Esse nosso contrato Decididor, por exemplo, tem apenas uma função nele, poderia ser trocado facilmente por uma callback function. Escreva um novo método de ordenação na classe Ordenador (não modifique o que já funciona, seja prudente), usando uma callback function em vez da classe abstrata Decididor. Você precisa modificar o arquivo data_service.dart para que seja usado o método de ordenação que recebe uma callback function.

3. Faça com que a tabela exiba entidades diferentes de Cafés, Cervejas e Nações. Você deve procurar outra(s) API(s) para buscar essas novas entidades. Se não conseguir, pode usar outras entidades acessíveis através da random-api.

4. Nesse novo app, implemente todas as ordenações, crescente e decrescente, com o devido acerto da interface gráfica. Seu usuário deve poder ver por qual coluna a tabela está ordenada e se a ordem é crescente ou decrescente. É mais fácil do que parece, o componente DataTableWidget sabe trabalhar com isso, exibindo setas pra cima e pra baixo nas colunas.

5. (Desafio Emocionante) Acrescente um campo de pesquisa (na barra de ações, na parte de cima da IU). A partir da terceira letra digitada, o app deve fazer uma operação de filtragem nos objetos exibidos. Detalhe emocionante: você não pode usar nenhuma função de biblioteca para fazer a filtragem. Em vez disso, deve implementar o seu próprio esquema genérico de filtragem, com polimorfismo, tal qual fizemos com o Ordenador.