# trabalho-3-progmob
Terceiro Trabalho de Programação para Dispositivos Móveis

---
# My Film List

## Aluno
Claudio Azambuja Caramori - 2018.1906.002-0

## Visão
Haverá uma lista de filmes e as opiniões e avaliações de quem assistiu. Usuários podem adicionar um filmes no seu catálogo. Nos filmes adicionados, podem marcar um filme como assistido, e, se assistido, podem dar uma avaliação de 0 a 5 estrelas, e um breve comentário com suas opiniões. As opiniões ficarão públicas para quem pesquisar o filme na lista principal.

## Papéis
**USUÁRIO**: O usuário padrão do sistema.

**ADMIN**: Um ambiente admin web será usado para filtrar comentários ofensivos e maliciosos.

## Requisitos funcionais
- Login com email e senha;
- Cadastro com email, senha, nome obrigatórios e avatar opicional (caso não tenha, será usado um placeholder);
- Adicionar um filme no seu catálogo, buscado na API do IMDB;
- Marcar um filme como assistido com um booleano;
- Avaliar um filme assistido com nota e comentário opicional;
- Visualizar dados de um filme;
- Visualizar comentários de outros usuários em um filme;

## Tecnologia empregada
- API em Ruby on Rails;
- Ambiente Admin Web integrado a API;
- API externa de filmes do IMDB (https://developer.imdb.com/documentation/) para extrair a lista de filmes;
- Aplicativo desenvolvido em Kotlin/Flutter;
