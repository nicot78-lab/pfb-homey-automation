# PFB Homey - Tests automatisés

Projet de Fin de Bloc B réalisé dans le cadre de la formation Testeur Logiciel.

## Application testée

**Homey** est une plateforme de gestion de locations saisonnières.

Environnement de test :

http://livraison3.testacademy.fr/

## Objectif du projet

Ce projet a pour objectif d'automatiser des tests fonctionnels de l'application Homey à l'aide de Robot Framework et SeleniumLibrary.

Les tests automatisés doivent pouvoir être exécutés de manière reproductible et être intégrés dans une chaîne d'intégration continue.

## Périmètre

Automatisation des tests Web UI des User Stories suivantes :

- **US-07** : Faire une demande de réservation
- **US-08** : Traiter une demande de réservation

Un test technique de type **smoke test** permet également de vérifier que l'environnement Homey est accessible avant l'exécution des tests fonctionnels.

## Technologies utilisées

- Python 3.13
- Robot Framework 7.4.2
- SeleniumLibrary 6.9.0
- Selenium 4.48.0
- Google Chrome
- Git
- GitHub
- Jenkins pour l'intégration continue

## Structure du projet

```text
pfb-homey-automation/
├── tests/
│   └── smoke_homey.robot
├── resources/
├── results/
├── .gitignore
├── README.md
└── requirements.txt
```

### Description des dossiers et fichiers

- `tests/` : contient les scripts de tests automatisés Robot Framework.
- `resources/` : contient les ressources partagées, variables et mots-clés réutilisables.
- `results/` : contient les rapports générés lors de l'exécution des tests.
- `requirements.txt` : contient les dépendances nécessaires au projet.
- `.gitignore` : permet d'exclure du dépôt les fichiers qui ne doivent pas être versionnés.
- `README.md` : présente le projet et explique son installation et son utilisation.

## Installation

### 1. Cloner le dépôt

```bash
git clone https://github.com/nicot78-lab/pfb-homey-automation.git
```

### 2. Se placer dans le dossier du projet

```bash
cd pfb-homey-automation
```

### 3. Installer les dépendances

```bash
py -m pip install -r requirements.txt
```

## Exécution des tests

Pour exécuter l'ensemble des tests présents dans le dossier `tests` :

```bash
robot -d results tests
```

Pour exécuter uniquement le test technique permettant de vérifier l'accès à Homey :

```bash
robot -d results tests/smoke_homey.robot
```

## Résultats des tests

Après une exécution, Robot Framework génère notamment les fichiers suivants dans le dossier `results` :

- `output.xml` : données techniques de l'exécution ;
- `log.html` : détail des étapes exécutées ;
- `report.html` : synthèse des résultats de la campagne.

Le dossier `results/` n'est pas versionné sur GitHub car ces fichiers sont générés automatiquement à chaque exécution.

## Versionnement

Le code source des tests est versionné avec Git et stocké sur GitHub.

Dépôt du projet :

https://github.com/nicot78-lab/pfb-homey-automation

## Intégration continue

Le projet sera intégré à un pipeline Jenkins afin de permettre l'exécution automatique des tests et la génération des rapports de résultats.