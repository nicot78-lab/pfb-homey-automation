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
- la User Story « Devenir Hôte » ;
- l'US-06 « Créer une annonce » ;
- la User Story « Traiter une demande de réservation ».

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

Cette suite automatise le parcours de demande de réservation d'un Voyageur ainsi que les contrôles associés côté Hôte.

Les scénarios automatisés vérifient notamment :

- qu'un visiteur non connecté peut accéder au formulaire de réservation ;
- qu'un visiteur non connecté ne peut pas finaliser une réservation ;
- qu'un Voyageur connecté peut envoyer une demande de réservation ;
- qu'une demande envoyée apparaît dans les réservations du compte Hôte ;
- la présence du champ de message obligatoire prévu dans l'US-07 ;
- la création attendue d'un nouveau message côté Hôte après l'envoi d'une demande.

Deux scénarios sont actuellement identifiés avec le tag `defect` :

```text
US07 - Le formulaire de réservation doit contenir un message obligatoire
US07 - Une demande de réservation doit créer un message côté hôte
```

Dans l'environnement testé :

- le champ de message obligatoire prévu dans l'US-07 n'est pas disponible dans le formulaire de réservation ;
- la demande de réservation apparaît bien côté Hôte dans « Réservations » ;
- aucun nouveau message n'est créé dans « Messages » lors de l'envoi de la demande.

Résultat de la suite hors défauts connus :

```text
6 tests
4 passed
0 failed
2 skipped
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
US08 - Une nouvelle demande doit avoir le statut NOUVEAU
US08 - Une réservation initiale doit proposer l'action Annuler au voyageur
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

- l'accès à la page « Devenir un hôte » ;
- la présence des étapes expliquant comment devenir Hôte ;
- la présence des champs obligatoires du formulaire ;
- la création d'un compte Hôte avec des données valides ;
- les différents contrôles de validation du formulaire.

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

Cela permet de créer un nouveau compte à chaque exécution sans utiliser d'identifiants fixes pour la création du compte.

---

# US-06 - Créer une annonce

Cette suite automatise le parcours de création d'une annonce par un compte Hôte.

Fichier :

```text
tests/us_annonce.robot
```

Ressource dédiée :

```text
resources/annonce.resource
```

Image utilisée pour le test d'upload :

```text
test_data/annonce_test.jpg
```

Les scénarios automatisés vérifient notamment :

- qu'un visiteur non connecté ne voit pas la fonction « Créer annonce » ;
- qu'un Hôte connecté peut accéder au formulaire de création ;
- le contrôle des champs obligatoires ;
- le tarif par nuit ;
- l'upload d'une image ;
- l'étape Caractéristiques ;
- la localisation ;
- le bouton Retour ;
- l'enregistrement en brouillon ;
- la soumission d'une annonce complète ;
- la présence immédiate de l'annonce avec le statut « Publié » dans « Mes annonces ».

Résultat :

```text
14 tests
12 passed
0 failed
2 skipped
```

Les deux scénarios ignorés portent le tag `defect` :

```text
ANN-04-US - Le titre seul devrait permettre de quitter l'étape Information selon l'US
ANN-08-US - L'adresse seule devrait permettre de quitter l'étape Localisation selon l'US
```

## Écarts observés entre l'US et l'application

### Étape Information

L'US indique que seul le titre est obligatoire.

Dans l'application testée, plusieurs champs supplémentaires doivent être renseignés pour pouvoir continuer.

### Étape Localisation

L'US indique que seule l'adresse est obligatoire.

Dans l'application testée, plusieurs champs supplémentaires doivent également être renseignés pour continuer.

## Observation complémentaire

Après soumission, l'application affiche :

```text
Toutes nos félicitations. Votre annonce a été soumise pour approbation.
```

Dans le même temps, l'annonce apparaît avec le statut « Publié » dans « Mes annonces ».

---

# User Story - Traiter une demande de réservation

Cette suite automatise les principaux traitements d'une demande de réservation côté Hôte et Voyageur.

Fichier :

```text
tests/us_traiter_reservation.robot
```

Les scénarios automatisés vérifient notamment :

- l'affichage d'une nouvelle demande côté Hôte ;
- le statut `NOUVEAU` ;
- les informations principales de la réservation ;
- la confirmation de disponibilité par l'Hôte ;
- le statut `DISPONIBLE` côté Voyageur ;
- la présence de l'action « Payez maintenant » ;
- l'accès aux frais supplémentaires et aux remises ;
- le profil de paiement Hôte ;
- le mode de paiement par virement bancaire ;
- les champs IBAN, SWIFT et informations bancaires ;
- l'accès à la page de paiement hors site.

Résultat :

```text
7 tests
5 passed
0 failed
2 skipped
```

Deux scénarios sont conservés avec le tag `defect` :

```text
TR-03 - Après confirmation le statut Hôte doit être ATTENTE DE PAIEMENT
TR-04 - Le refus Hôte rend la réservation REFUSE des deux côtés
```

Pour TR-03, l'US attend `ATTENTE DE PAIEMENT` alors que l'application affiche `PAIEMENT EN ATTENTE`.

TR-04 est conservé pour tracer l'écart observé lors du refus d'une réservation.

---
# Structure du projet

```text
pfb-homey-automation/
|
|-- Jenkinsfile
|-- README.md
|-- requirements.txt
|
|-- resources/
|   |-- commun.resource
|   |-- navigateur.resource
|   |-- connexion.resource
|   |-- inscription.resource
|   |-- reservation.resource
|   |-- hote.resource
|   `-- annonce.resource
|
|-- test_data/
|   `-- annonce_test.jpg
|
|-- tests/
|   |-- smoke_homey.robot
|   |-- us07_reservation.robot
|   |-- us08_reservation.robot
|   |-- us_connexion.robot
|   |-- us_inscription.robot
|   |-- us_hote.robot
|   |-- us_annonce.robot
|   `-- us_traiter_reservation.robot
|
`-- results/
    |-- output.xml
    |-- log.html
    `-- report.html
```

Le dossier `results/` n'est pas versionné dans Git.

---

# Organisation des ressources

Le fichier :

```text
resources/commun.resource
```

sert de point d'entrée aux fichiers de tests.

Il importe :

```text
navigateur.resource
connexion.resource
inscription.resource
reservation.resource
hote.resource
annonce.resource
```

Les fichiers de tests utilisent l'import :

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

# Identifiants de test

Les identifiants des comptes Voyageur et Hôte ne sont pas enregistrés dans le dépôt Git.

## Voyageur

```powershell
$env:HOMEY_VOYAGEUR_USER="nom_utilisateur"
$env:HOMEY_VOYAGEUR_PASSWORD="mot_de_passe"
```

Credential Jenkins :

```text
homey-voyageur
```

## Hôte

```powershell
$env:HOMEY_HOTE_USER="nom_utilisateur"
$env:HOMEY_HOTE_PASSWORD="mot_de_passe"
```

Credential Jenkins :

```text
homey-hote
```

Les données sensibles ne doivent jamais être inscrites directement dans les fichiers Robot Framework ou dans GitHub.

---

# Exécution locale

Pour exécuter toute la campagne en excluant les défauts connus :

```powershell
py -m robot --skip defect --outputdir results tests
```

Résultat de référence actuel :

```text
63 tests
55 passed
0 failed
8 skipped
```

---

# Exécution des suites séparément

## US-07

```powershell
py -m robot --skip defect --outputdir results tests\us07_reservation.robot
```

Résultat :

```text
6 tests, 4 passed, 0 failed, 2 skipped
```

## US-08

```powershell
py -m robot --skip defect --outputdir results tests\us08_reservation.robot
```

Résultat :

```text
5 tests, 3 passed, 0 failed, 2 skipped
```

## Connexion

```powershell
py -m robot --outputdir results tests\us_connexion.robot
```

Résultat :

```text
10 tests, 10 passed, 0 failed
```

## Inscription

```powershell
py -m robot --outputdir results tests\us_inscription.robot
```

Résultat :

```text
9 tests, 9 passed, 0 failed
```

## Devenir Hôte

```powershell
py -m robot --outputdir results tests\us_hote.robot
```

Résultat :

```text
11 tests, 11 passed, 0 failed
```

## Créer une annonce

```powershell
py -m robot --skip defect --outputdir results tests\us_annonce.robot
```

Résultat :

```text
14 tests, 12 passed, 0 failed, 2 skipped
```

---

# Rapports Robot Framework

Après l'exécution, Robot Framework génère :

```text
results/output.xml
results/log.html
results/report.html
```

`log.html` permet de consulter le détail des étapes exécutées.

`report.html` fournit une synthèse de la campagne.

---

# Intégration continue Jenkins

Une pipeline Jenkins est définie dans :

```text
Jenkinsfile
```

La pipeline effectue :

```text
1. Récupération du projet depuis GitHub
2. Vérification de l'environnement
3. Installation des dépendances
4. Injection sécurisée des identifiants Voyageur et Hôte
5. Exécution des tests Robot Framework
6. Archivage des résultats
```

Commande Jenkins :

```powershell
py -m robot --skip defect --outputdir results tests
```

Chrome est exécuté en mode headless dans Jenkins.

---

# Résultat Jenkins

La pipeline Jenkins exécutée après le push du dernier code sur la branche `main` s'est terminée avec le statut :

```text
SUCCESS
```

La campagne locale de référence sur ce même état du projet est :

```text
63 tests
55 passed
0 failed
8 skipped
```

Les rapports Robot Framework sont archivés automatiquement par Jenkins.

---

# Gestion des défauts connus

Les scénarios mettant en évidence un écart entre l'US et l'application sont conservés avec le tag :

```text
defect
```

Huit scénarios sont actuellement ignorés dans la campagne :

```text
US07 - Le formulaire de réservation doit contenir un message obligatoire
US07 - Une demande de réservation doit créer un message côté hôte
US08 - Une nouvelle demande doit avoir le statut NOUVEAU
US08 - Une réservation initiale doit proposer l'action Annuler au voyageur
ANN-04-US - Le titre seul devrait permettre de quitter l'étape Information selon l'US
ANN-08-US - L'adresse seule devrait permettre de quitter l'étape Localisation selon l'US
```

Ils pourront être réactivés lorsque les anomalies ou écarts auront été corrigés.

---

# Principes de reproductibilité

Les principes appliqués sont :

- absence de mots de passe dans Git ;
- variables d'environnement ;
- Jenkins Credentials ;
- données uniques pour les créations de comptes ;
- titres uniques pour les annonces ;
- image de test versionnée ;
- ressources séparées par domaine ;
- sélecteurs stables lorsque cela est possible ;
- absence de chemins Windows personnels dans les scénarios ;
- dépendances documentées ;
- commandes d'exécution documentées ;
- mêmes suites en local et dans Jenkins.

---

# État actuel du projet

```text
Smoke          : PASS
US-07          : PASS hors défauts connus
US-08          : PASS hors défauts connus
Connexion      : PASS
Inscription    : PASS
Devenir Hôte   : PASS
Créer annonce  : PASS hors défauts connus

Total          : 63 tests
Réussis                       : 55
Échecs         : 0
Ignorés                       : 8
Jenkins        : SUCCESS
```

La chaîne d'automatisation est opérationnelle :

```text
GitHub
   |
   v
Jenkins
   |
   v
Robot Framework
   |
   v
Selenium / Chrome
   |
   v
Rapports de tests
```


