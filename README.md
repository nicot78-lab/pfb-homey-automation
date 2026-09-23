# PFB Homey Automation

Projet d'automatisation de tests réalisé dans le cadre du Projet de Fin de Bloc B de la Test Academy.

L'objectif est d'automatiser des tests fonctionnels de l'application Homey / Livraison 3 avec Robot Framework et SeleniumLibrary, puis d'exécuter ces tests automatiquement dans une pipeline Jenkins.

---

## Application testée

Application :

http://livraison3.testacademy.fr/

Dépôt GitHub :

https://github.com/nicot78-lab/pfb-homey-automation

---

## Technologies utilisées

| Outil | Utilisation |
|---|---|
| Python | Exécution de Robot Framework |
| Robot Framework | Framework d'automatisation |
| SeleniumLibrary | Automatisation du navigateur |
| Selenium | Pilotage de Chrome |
| Google Chrome | Navigateur utilisé pour les tests |
| Git / GitHub | Versionnement du projet |
| Jenkins | Intégration continue |

Versions principales définies dans `requirements.txt` :

```text
robotframework==7.4.2
robotframework-seleniumlibrary==6.9.0
selenium==4.48.0
```

---

# Périmètre automatisé

Le projet couvre actuellement :

- un test Smoke ;
- l'US-07 liée à la réservation ;
- l'US-08 liée au suivi d'une réservation ;
- la User Story « S'inscrire » ;
- la User Story « Se connecter » ;
- la User Story « Devenir Hôte ».

---

# Smoke Test

Le test Smoke vérifie que l'application Homey est accessible avant l'exécution des scénarios fonctionnels.

Fichier :

```text
tests/smoke_homey.robot
```

Résultat :

```text
1 test
1 passed
0 failed
```

---

# US-07 - Demande de réservation

Les scénarios automatisés vérifient notamment :

- qu'un visiteur non connecté peut accéder au formulaire de réservation ;
- qu'un visiteur non connecté ne peut pas finaliser une réservation ;
- qu'un voyageur connecté peut envoyer une demande de réservation ;
- la présence du champ de message obligatoire prévu dans l'US-07.

Le scénario concernant le message obligatoire est identifié comme défaut connu et porte le tag :

```text
defect
```

Dans le parcours desktop testé, le champ de message obligatoire attendu par l'US-07 n'est pas disponible.

Résultat de la suite hors défaut connu :

```text
4 tests
3 passed
0 failed
1 skipped
```

---

# US-08 - Suivi d'une réservation

Le périmètre automatisé côté Voyageur vérifie :

- l'accès au tableau de bord des réservations ;
- la présence d'une demande de réservation ;
- l'affichage des informations de réservation ;
- l'accès au détail d'une réservation.

Deux scénarios sont actuellement identifiés avec le tag `defect` :

```text
Une nouvelle demande doit avoir le statut NOUVEAU
Une réservation initiale doit proposer l'action Annuler au voyageur
```

Dans l'environnement testé :

- le statut initial observé ne correspond pas au statut attendu par l'US-08 ;
- aucune action d'annulation exploitable n'est visible dans le parcours principal testé côté Voyageur.

Résultat de la suite hors défauts connus :

```text
5 tests
3 passed
0 failed
2 skipped
```

---

# User Story - S'inscrire

Cette suite automatise la création d'un compte Voyageur et plusieurs règles de validation du formulaire d'inscription.

Fichier :

```text
tests/us_inscription.robot
```

Les scénarios automatisés vérifient :

- l'ouverture de la fenêtre d'inscription ;
- la présence des champs obligatoires ;
- la création d'un compte avec des données valides ;
- le refus de l'inscription si le nom d'utilisateur est vide ;
- le refus d'un email au format invalide ;
- le refus si les deux mots de passe sont différents ;
- le refus si les termes et conditions ne sont pas acceptés ;
- l'accès à la page des termes et conditions ;
- l'accès à l'inscription depuis la fenêtre de connexion.

Résultat :

```text
9 tests
9 passed
0 failed
```

---

## Reproductibilité des tests d'inscription

Le nom d'utilisateur et l'adresse email doivent être uniques.

Pour permettre à plusieurs personnes d'exécuter les mêmes tests plusieurs fois, le scénario nominal ne contient donc pas de compte utilisateur fixe.

Robot Framework génère automatiquement un identifiant unique à partir de la date et de l'heure d'exécution.

Exemple :

```text
voyageur20260921150342
voyageur20260921150342@example.com
```

Une nouvelle valeur est générée lors de chaque exécution.

Cela permet :

- de rejouer les tests sans modifier le fichier ;
- d'éviter un conflit avec un compte déjà créé ;
- d'exécuter les tests sur un autre poste ;
- d'exécuter les mêmes tests dans Jenkins.

---

# User Story - Se connecter

Cette suite automatise les principaux scénarios de connexion d'un compte Voyageur.

Fichier :

```text
tests/us_connexion.robot
```

Les scénarios automatisés vérifient :

- l'ouverture de la fenêtre de connexion ;
- la présence des éléments du formulaire ;
- la connexion d'un Voyageur avec des identifiants valides ;
- l'affichage du message de succès de connexion ;
- la redirection vers le tableau de bord Voyageur ;
- la présence des principales rubriques du tableau de bord ;
- le refus de coordonnées invalides ;
- le refus d'un nom d'utilisateur ou email vide ;
- le refus d'un mot de passe vide ;
- le fonctionnement de la case « Se souvenir de moi » ;
- l'accès au parcours « Mot de passe oublié » ;
- l'accès à la recherche pour un visiteur non connecté.

Résultat :

```text
10 tests
10 passed
0 failed
```

La saisie des identifiants est vérifiée avant soumission afin de stabiliser l'exécution dans Chrome et en mode headless.

---

# User Story - Devenir Hôte

Cette suite automatise la création d'un compte Hôte depuis la page « Devenir un hôte ».

Fichier :

```text
tests/us_hote.robot
```

Les scénarios automatisés vérifient :

- l'accès à la page « Devenir un hôte » depuis le menu principal ;
- l'affichage de la page dédiée ;
- la présence des étapes expliquant comment devenir Hôte ;
- la présence des champs obligatoires du formulaire ;
- la création d'un compte Hôte avec des données valides ;
- l'affichage du message de confirmation ;
- l'ouverture automatique de la popup de connexion ;
- la connexion avec le compte Hôte nouvellement créé ;
- la présence des fonctions spécifiques Hôte dans le tableau de bord ;
- le refus d'un nom d'utilisateur vide ;
- le refus d'un email vide ;
- le refus d'un email au format invalide ;
- le refus d'un mot de passe vide ;
- le refus d'une confirmation de mot de passe vide ;
- le refus de mots de passe différents ;
- le refus de l'inscription lorsque les termes et conditions ne sont pas acceptés.

Le formulaire Hôte est distingué des autres formulaires présents dans la page grâce au champ :

```text
role = homey_host
```

Le tableau de bord du compte créé est vérifié avec les fonctions Hôte suivantes :

```text
Mes annonces
Créer annonce
Réservations
Portefeuille
Messages
Factures
Favoris
```

Résultat :

```text
11 tests
11 passed
0 failed
```

---

## Reproductibilité des tests Hôte

Le scénario nominal génère automatiquement un nom d'utilisateur et une adresse email uniques.

Exemple :

```text
hote20260923102530
hote20260923102530@example.com
```

Cela permet de créer un nouveau compte à chaque exécution sans utiliser d'identifiants Hôte fixes.

Le mot de passe utilisé dans le scénario est une donnée de test générique et le compte créé est destiné uniquement aux tests automatisés.

---

# Structure du projet

```text
pfb-homey-automation/
│
├── Jenkinsfile
├── README.md
├── requirements.txt
│
├── resources/
│   ├── commun.resource
│   ├── navigateur.resource
│   ├── connexion.resource
│   ├── inscription.resource
│   ├── reservation.resource
│   └── hote.resource
│
├── tests/
│   ├── smoke_homey.robot
│   ├── us07_reservation.robot
│   ├── us08_reservation.robot
│   ├── us_connexion.robot
│   ├── us_inscription.robot
│   └── us_hote.robot
│
└── results/
    ├── output.xml
    ├── log.html
    └── report.html
```

Le dossier `results/` n'est pas versionné dans Git.

---

# Organisation des ressources

Le fichier :

```text
resources/commun.resource
```

sert de point d'entrée aux fichiers de tests.

Il importe les ressources spécialisées :

```text
navigateur.resource
connexion.resource
inscription.resource
reservation.resource
hote.resource
```

Cette organisation permet de séparer les mots-clés par domaine fonctionnel et d'améliorer la lisibilité et la maintenance du projet.

Les fichiers de tests continuent à utiliser un seul import :

```robot
Resource    ../resources/commun.resource
```

---

# Installation

Cloner le dépôt :

```powershell
git clone https://github.com/nicot78-lab/pfb-homey-automation.git
cd pfb-homey-automation
```

Installer les dépendances :

```powershell
py -m pip install -r requirements.txt
```

---

# Identifiants de test Voyageur

Les identifiants du compte Voyageur ne sont pas enregistrés dans le dépôt Git.

Ils sont fournis à Robot Framework avec des variables d'environnement :

```powershell
$env:HOMEY_VOYAGEUR_USER="nom_utilisateur"
$env:HOMEY_VOYAGEUR_PASSWORD="mot_de_passe"
```

Les données sensibles ne doivent jamais être inscrites directement dans les fichiers Robot Framework ou dans GitHub.

Dans Jenkins, ces valeurs sont stockées dans Jenkins Credentials.

Credential utilisé :

```text
homey-voyageur
```

Variables injectées :

```text
HOMEY_VOYAGEUR_USER
HOMEY_VOYAGEUR_PASSWORD
```

---

# Exécution locale

Pour exécuter toute la campagne en excluant les défauts connus :

```powershell
robot --skip defect --outputdir results tests
```

ou :

```powershell
py -m robot --skip defect --outputdir results tests
```

Résultat de référence actuel :

```text
40 tests
37 passed
0 failed
3 skipped
```

Les trois tests ignorés correspondent aux scénarios identifiés avec le tag `defect`.

---

# Exécution des suites séparément

## US-07

```powershell
robot --skip defect --outputdir results tests\us07_reservation.robot
```

Résultat :

```text
4 tests, 3 passed, 0 failed, 1 skipped
```

## US-08

```powershell
robot --skip defect --outputdir results tests\us08_reservation.robot
```

Résultat :

```text
5 tests, 3 passed, 0 failed, 2 skipped
```

## Connexion

```powershell
robot --outputdir results tests\us_connexion.robot
```

Résultat :

```text
10 tests, 10 passed, 0 failed
```

## Inscription

```powershell
robot --outputdir results tests\us_inscription.robot
```

Résultat :

```text
9 tests, 9 passed, 0 failed
```

## Devenir Hôte

```powershell
robot --outputdir results tests\us_hote.robot
```

Résultat :

```text
11 tests, 11 passed, 0 failed
```

---

# Rapports Robot Framework

Après l'exécution, Robot Framework génère :

```text
results/output.xml
results/log.html
results/report.html
```

`log.html` permet de consulter le détail des mots-clés et des étapes exécutées.

`report.html` fournit une synthèse du résultat de la campagne.

---

# Intégration continue Jenkins

Une pipeline Jenkins est définie dans le fichier :

```text
Jenkinsfile
```

La pipeline effectue les étapes suivantes :

```text
1. Récupération du projet depuis GitHub
2. Vérification de l'environnement
3. Installation des dépendances
4. Injection sécurisée des identifiants Voyageur
5. Exécution des tests Robot Framework
6. Archivage des résultats
```

Commande exécutée par Jenkins :

```powershell
py -m robot --skip defect --outputdir results tests
```

Le navigateur Chrome est exécuté en mode headless dans l'environnement Jenkins.

Les mêmes scénarios sont exécutables localement avec Chrome visible.

---

# Résultat Jenkins

La campagne complète a été exécutée avec succès dans Jenkins.

Résultat :

```text
40 tests
37 réussis
0 échec
3 ignorés
```

La suite « Devenir Hôte » est également validée dans Jenkins :

```text
11 tests
11 réussis
0 échec
```

Les rapports générés par Robot Framework sont archivés automatiquement par Jenkins.

---

# Gestion des défauts connus

Les scénarios mettant en évidence une anomalie de l'application sont conservés afin d'assurer leur traçabilité.

Ils utilisent le tag :

```text
defect
```

Pour exécuter la campagne de non-régression sans ces anomalies connues :

```powershell
robot --skip defect --outputdir results tests
```

Trois scénarios sont actuellement ignorés dans la campagne Jenkins :

```text
US07 - Le formulaire de réservation doit contenir un message obligatoire
US08 - Une nouvelle demande doit avoir le statut NOUVEAU
US08 - Une réservation initiale doit proposer l'action Annuler au voyageur
```

Ils pourront être réactivés lorsque les anomalies auront été corrigées.

---

# Principes de reproductibilité

Les tests ont été conçus pour pouvoir être exécutés par un autre testeur ou sur un autre poste.

Les principes appliqués sont :

- absence de mot de passe Voyageur dans le dépôt Git ;
- utilisation de variables d'environnement ;
- utilisation des Jenkins Credentials ;
- génération de données uniques pour les créations de comptes ;
- séparation des ressources par domaine fonctionnel ;
- utilisation de sélecteurs stables lorsque cela est possible ;
- vérification des valeurs saisies dans les formulaires dynamiques ;
- tests indépendants les uns des autres ;
- absence de chemins Windows personnels dans les scénarios ;
- dépendances documentées dans `requirements.txt` ;
- commandes d'exécution documentées ;
- exécution possible localement et dans Jenkins ;
- utilisation des mêmes suites en local et en intégration continue.

---

# État actuel du projet

```text
Smoke          : PASS
US-07          : PASS hors défaut connu
US-08          : PASS hors défauts connus
Connexion      : PASS
Inscription    : PASS
Devenir Hôte   : PASS

Total          : 40 tests
Réussis        : 37
Échecs         : 0
Ignorés        : 3
Jenkins        : SUCCESS
```

La chaîne d'automatisation est opérationnelle :

```text
GitHub
   ↓
Jenkins
   ↓
Robot Framework
   ↓
Selenium / Chrome
   ↓
Rapports de tests
```