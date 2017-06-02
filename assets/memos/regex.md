# Regular Expressions

## Basiques

| Regex           | Explication                                     |
|-----------------|-------------------------------------------------|
| `guitare`       | Cherche le mot « guitare » dans la chaîne.      |
| `guitare|piano` | Cherche le mot « guitare » OU « piano ».        |
| `^guitare`      | La chaîne doit commencer par « guitare ».       |
| `guitare$`      | La chaîne doit se terminer par « guitare ».     |
| `^guitare$`     | La chaîne doit contenir uniquement « guitare ». |

## Classes de caractères

| Regex            | Explication                                                                                      |
|------------------|--------------------------------------------------------------------------------------------------|
| `gr[ioa]s`       | Chaîne qui contient « gris », ou « gros », ou « gras ».                                          |
| `[a-z]`          | Caractères minuscules de a à z.                                                                  |
| `[0-9]`          | Chiffres de 0 à 9.                                                                               |
| `[a-e0-9]`       | Lettres de « a » à « e » ou chiffres de 0 à 9.                                                   |
| `[0-57A-Za-z.-]` | Chiffres de 0 à 5, ou 7, ou lettres majuscules, ou lettres minuscules, ou un point, ou un tiret. |
| `[^0-9]`         | Chaîne ne contenant PAS de chiffres.                                                             |
| `^[^0-9]`        | Chaîne ne commençant PAS par un chiffre.                                                         |

## Quantificateurs

| Regex        | Explication                                                                             |
|--------------|-----------------------------------------------------------------------------------------|
| `a?`         | « a » peut apparaître 0 ou 1 fois.                                                      |
| `a+`         | « a » doit apparaître au moins 1 fois.                                                  |
| `a*`         | « a » peut apparaître 0, 1 ou plusieurs fois.                                           |
| `bor?is`     | « bois » ou « boris ».                                                                  |
| `Ay(ay|oy)*` | Fonctionne pour Ay, Ayay, Ayoy, Ayayayoyayayoyayoyoyoy, etc.                            |
| `a{3}`       | « a » doit apparaître 3 fois exactement (« aaa »).                                      |
| `a{3,5}`     | « a » doit apparaître de 3 à 5 fois (« aaa », « aaaa », « aaaaa »).                     |
| `a{3,}`      | « a » doit apparaître au moins 3 fois (« aaa », « aaaa », « aaaaa », « aaaaaa », etc.). |

## Métacaractères

Liste : `# ! ^ $ ( ) [ ] { } | ? + * .`

Pour utiliser un métacaractère dans une recherche, il faut l'échapper avec un antislash : \.

| regex    | Explication                  |
|----------|------------------------------|
| `Hein?`  | Cherche « Hei » ou « Hein ». |
| `Hein\?` | Cherche « Hein? ».           |

## Classes abrégées

| Classe abrégée   | Correspondance                     |
|------------------|------------------------------------|
| `\d`             | [0-9]                              |
| `\D`             | [^0-9]                             |
| `\w`             | [a-zA-Z0-9_]                       |
| `\W`             | [^a-zA-Z0-9_]                      |
| `\t`             | Tabulation                         |
| `\n`             | Saut de ligne                      |
| `\r`             | Retour chariot                     |
| `\s`             | Espace blanc (correspond à\t\n\r)  |
| `\S`             | N'est PAS un espace blanc (\t\n\r) |
| `.`              | Classe universelle                 |


## Sources

- https://openclassrooms.com/courses/concevez-votre-site-web-avec-php-et-mysql/memento-des-expressions-regulieres
- https://blog.rootshell.be/wp-content/uploads/2006/10/regular_expressions_cheat_sheet.png
