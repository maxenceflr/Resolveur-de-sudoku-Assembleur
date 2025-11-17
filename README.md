# Résolveur de Sudoku en Assembleur (MIPS)

Ce projet implémente un **résolveur de Sudoku en assembleur MIPS**, fonctionnant sous l'environnement **MARS**. Il permet de vérifier une grille, de détecter les doublons, et d'exécuter les différentes étapes de résolution via un ensemble de sous-programmes MIPS.

---

## 📦 Prérequis

Avant de lancer le projet, vous devez disposer de :

* **Java** installé sur votre machine (Java 8+)
* L'outil **MARS** (MIPS Assembler and Runtime Simulator)
* Un système compatible : Windows, macOS ou Linux

---

## 🚀 Installation de MARS

1. Télécharger MARS au format `.jar` depuis son site officiel ou un mirroir universitaire.
2. Ouvrir le fichier téléchargé : double-cliquez simplement dessus.

> 💡 Si le double-clic ne fonctionne pas, lancez-le via la commande suivante :
>
> ```bash
> java -jar Mars.jar
> ```

---

## ▶️ Lancer le projet (Étapes)

Voici les étapes pour lancer le programme assembleur dans **MARS** :

1. **Téléchargez MARS** (fichier `.jar`).
2. **Ouvrez-le avec Java** (double-clic sur le fichier `.jar`).
3. Dans MARS, cliquez sur **File → New** pour créer un nouveau fichier.
4. **Écrivez ou importez votre code assembleur** dans l'éditeur.
5. Cliquez sur le bouton **Assemble** pour compiler le programme.
6. Cliquez sur **Run → Go** pour exécuter le programme.

---

## 📁 Structure du projet

Le projet ne contient **qu'un seul fichier assembleur** ainsi qu'un fichier texte pour la grille :

```
/resolveur-sudoku-assembleur
│
├── sudoku.asm        # Le programme assembleur complet du résolveur
├── sudoku.txt      # grille de test à utilisée en entrée dans le .data
└── README.md
```

---

## 🔍 Fonctionnement global du programme

Le résolveur charge une grille de Sudoku et applique différentes vérifications :

* Vérification des lignes
* Vérification des colonnes
* Vérification des carrés 3×3

Selon l'implémentation choisie, une partie de la résolution peut être automatisée.


---

 Tests

Des grilles de test sont fournies dans le dossier sudoku.txt. Pour modifier la grille utilisée, éditez la section `.data` du fichier `sudoku.asm`.


