# PFB Homey Automation

Projet d'automatisation de tests réalisé dans le cadre du Projet de Fin de Bloc B de la Test Academy.

L'objectif est d'automatiser les principaux parcours fonctionnels de l'application Homey / Livraison 3 avec Robot Framework et SeleniumLibrary, puis d'exécuter automatiquement cette campagne avec Jenkins.

---

## Application testée

Application :

http://livraison3.testacademy.fr/

Dépôt GitHub public :

https://github.com/nicot78-lab/pfb-homey-automation

---

## Technologies utilisées

| Outil | Version / utilisation |
|---|---|
| Python | 3.13.15 |
| Robot Framework | 7.4.2 |
| SeleniumLibrary | 6.9.0 |
| Selenium | 4.48.0 |
| Google Chrome | Navigateur utilisé pour les tests |
| Git / GitHub | Versionnement du projet |
| Jenkins | Intégration continue |

Les dépendances Python sont définies dans `requirements.txt` :

```text
robotframework==7.4.2
robotframework-seleniumlibrary==6.9.0
selenium==4.48.0
```

---

# Périmètre automatisé

Le projet couvre :

- un Smoke Test ;
- US-07 - Demande de réservation ;
- US-08 - Suivi d'une réservation ;
- S'inscrire ;
- Se connecter ;
- Devenir Hôte ;
- US-06 - Créer une annonce ;
- Traiter une demande de réservation ;
- Régénérer son mot de passe.

La campagne complète contient :

```text
66 tests
57 passed
0 failed
9 skipped
```

Les neuf tests ignorés correspondent à des écarts connus entre les User Stories et l'application testée. Ils portent le tag `defect`.

---

# Architecture POM

Le projet utilise une organisation inspirée du Page Object Model.

Les fichiers de tests sont placés dans :

```text
tests/
```

Les actions techniques, sélecteurs et mots-clés réutilisables sont placés dans :

```text
resources/pages/
```

Les variables communes sont centralisées dans :

```text
resources/variables.robot
```

Le fichier :

```text
resources/commun.resource
```

sert de point d'entrée commun aux ressources utilisées par les scénarios.

Cette organisation permet de séparer :

```text
Scénarios fonctionnels
        |
        v
tests/
        |
        v
resources/commun.resource
        |
        v
resources/pages/
        |
        v
SeleniumLibrary / navigateur
```

Les fichiers présents dans `tests/` ne contiennent plus de section locale `*** Keywords ***` ou `*** Variables ***`.

---

# Structure du projet

```text
pfb-homey-automation/
|
|-- .gitignore
|-- Jenkinsfile
|-- README.md
|-- requirements.txt
|
|-- resources/
|   |-- commun.resource
|   |-- navigateur.resource
|   |-- variables.robot
|   |
|   `-- pages/
|       |-- page_annonce.resource
|       |-- page_annonce_parcours.resource
|       |-- page_connexion.resource
|       |-- page_hote.resource
|       |-- page_inscription.resource
|       |-- page_mot_de_passe_oublie.resource
|       |-- page_reservation.resource
|       |-- page_reservation_parcours.resource
|       `-- page_reservations_voyageur.resource
|
|-- test_data/
|   `-- annonce_test.jpg
|
|-- tests/
|   |-- smoke_homey.robot
|   |-- us07_reservation.robot
|   |-- us08_reservation.robot
|   |-- us_annonce.robot
|   |-- us_connexion.robot
|   |-- us_hote.robot
|   |-- us_inscription.robot
|   |-- us_mot_de_passe_oublie.robot
|   `-- us_traiter_reservation.robot
|
`-- results/
    |-- output.xml
    |-- log.html
    `-- report.html
```

Le dossier `results/` est généré lors de l'exécution mais n'est pas versionné dans Git grâce au fichier `.gitignore`.

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

Les identifiants utilisés par les tests ne sont pas enregistrés dans le dépôt GitHub.

Ils sont fournis par des variables d'environnement.

## Voyageur

En local :

```powershell
$env:HOMEY_VOYAGEUR_USER="nom_utilisateur"
$env:HOMEY_VOYAGEUR_PASSWORD="mot_de_passe"
```

Dans Jenkins, le credential utilisé est :

```text
homey-voyageur
```

Variables injectées :

```text
HOMEY_VOYAGEUR_USER
HOMEY_VOYAGEUR_PASSWORD
```

## Hôte

En local :

```powershell
$env:HOMEY_HOTE_USER="nom_utilisateur"
$env:HOMEY_HOTE_PASSWORD="mot_de_passe"
```

Dans Jenkins, le credential utilisé est :

```text
homey-hote
```

Variables injectées :

```text
HOMEY_HOTE_USER
HOMEY_HOTE_PASSWORD
```

Aucun mot de passe n'est enregistré dans le dépôt Git.

---

# Exécution locale

Pour exécuter toute la campagne en excluant les défauts connus :

```powershell
py -m robot --skip defect --outputdir results tests
```

Résultat de référence :

```text
66 tests
57 passed
0 failed
9 skipped
```

---

# Smoke Test

Fichier :

```text
tests/smoke_homey.robot
```

Le Smoke Test vérifie que l'application Homey est accessible avant l'exécution des scénarios fonctionnels.

Résultat :

```text
1 test
1 passed
0 failed
```

---

# US-07 - Demande de réservation

Fichier :

```text
tests/us07_reservation.robot
```

Les scénarios vérifient notamment :

- l'accès au formulaire de réservation ;
- le comportement d'un visiteur non connecté ;
- l'envoi d'une demande par un Voyageur connecté ;
- la présence de la réservation côté Hôte ;
- le champ de message prévu par l'US ;
- la création d'un message côté Hôte.

Résultat :

```text
6 tests
4 passed
0 failed
2 skipped
```

Défauts connus :

```text
US07 - Le formulaire de réservation doit contenir un message obligatoire
US07 - Une demande de réservation doit créer un message côté hôte
```

Dans l'application testée :

- le champ de message obligatoire prévu par l'US n'est pas disponible ;
- la demande de réservation ne génère pas le message attendu côté Hôte.

---

# US-08 - Suivi d'une réservation

Fichier :

```text
tests/us08_reservation.robot
```

Les scénarios vérifient :

- l'accès au tableau de bord ;
- la présence des réservations ;
- les informations affichées ;
- l'accès au détail ;
- le statut initial ;
- l'action d'annulation.

Résultat :

```text
5 tests
3 passed
0 failed
2 skipped
```

Défauts connus :

```text
US08 - Une nouvelle demande doit avoir le statut NOUVEAU
US08 - Une réservation initiale doit proposer l'action Annuler au voyageur
```

---

# User Story - S'inscrire

Fichier :

```text
tests/us_inscription.robot
```

Les scénarios vérifient :

- l'ouverture de la fenêtre d'inscription ;
- les champs obligatoires ;
- la création d'un compte valide ;
- les contrôles sur le nom d'utilisateur ;
- le format de l'adresse email ;
- la confirmation du mot de passe ;
- l'acceptation des conditions ;
- le lien vers les termes et conditions ;
- l'accès à l'inscription depuis la connexion.

Résultat :

```text
9 tests
9 passed
0 failed
```

Les comptes de test sont générés avec des données uniques afin de permettre plusieurs exécutions de la campagne.

---

# User Story - Se connecter

Fichier :

```text
tests/us_connexion.robot
```

Les scénarios vérifient notamment :

- l'ouverture de la fenêtre de connexion ;
- les champs du formulaire ;
- une connexion valide ;
- le tableau de bord Voyageur ;
- les identifiants invalides ;
- les champs obligatoires ;
- la case « Se souvenir de moi » ;
- le parcours « Mot de passe oublié » ;
- l'accès à la recherche sans connexion.

Résultat :

```text
10 tests
10 passed
0 failed
```

---

# User Story - Devenir Hôte

Fichier :

```text
tests/us_hote.robot
```

Les scénarios vérifient notamment :

- l'accès à la page « Devenir un hôte » ;
- les informations affichées ;
- les champs obligatoires ;
- la création d'un compte Hôte ;
- les principales validations du formulaire.

Résultat :

```text
11 tests
11 passed
0 failed
```

Les données Hôte créées pendant les tests sont générées de manière unique.

---

# US-06 - Créer une annonce

Fichier :

```text
tests/us_annonce.robot
```

Ressources principales :

```text
resources/pages/page_annonce.resource
resources/pages/page_annonce_parcours.resource
```

Image de test :

```text
test_data/annonce_test.jpg
```

Les scénarios vérifient notamment :

- l'accès à la création d'annonce ;
- l'étape Information ;
- l'étape Tarifs ;
- l'étape Médias ;
- le chargement d'une image ;
- l'étape Caractéristiques ;
- la Localisation ;
- le Règlement intérieur ;
- le retour à l'étape précédente ;
- l'enregistrement en brouillon ;
- la soumission ;
- la publication de l'annonce.

Résultat :

```text
14 tests
12 passed
0 failed
2 skipped
```

Défauts connus :

```text
ANN-04-US - Le titre seul devrait permettre de quitter l'étape Information selon l'US
ANN-08-US - L'adresse seule devrait permettre de quitter l'étape Localisation selon l'US
```

L'application demande davantage d'informations obligatoires que celles prévues dans l'US pour les étapes Information et Localisation.

---

# User Story - Traiter une demande de réservation

Fichier :

```text
tests/us_traiter_reservation.robot
```

Ressources principales :

```text
resources/pages/page_reservation.resource
resources/pages/page_reservation_parcours.resource
resources/pages/page_reservations_voyageur.resource
```

Les scénarios vérifient notamment :

- une nouvelle demande côté Hôte ;
- les informations de réservation ;
- la confirmation de disponibilité ;
- le statut `DISPONIBLE` côté Voyageur ;
- l'action « Payez maintenant » ;
- les frais supplémentaires ;
- les remises ;
- le profil de paiement Hôte ;
- le virement bancaire ;
- les champs IBAN et SWIFT ;
- le paiement hors site.

Résultat :

```text
7 tests
5 passed
0 failed
2 skipped
```

Défauts connus :

```text
TR-03 - Après confirmation le statut Hôte doit être ATTENTE DE PAIEMENT
TR-04 - Le refus Hôte rend la réservation REFUSE des deux côtés
```

Pour TR-03, l'US attend :

```text
ATTENTE DE PAIEMENT
```

alors que l'application affiche :

```text
PAIEMENT EN ATTENTE
```

TR-04 est conservé afin de tracer l'écart observé sur le traitement d'un refus.

---

# User Story - Régénérer son mot de passe

Fichier :

```text
tests/us_mot_de_passe_oublie.robot
```

Ressource dédiée :

```text
resources/pages/page_mot_de_passe_oublie.resource
```

Les scénarios vérifient :

- l'ouverture du parcours ;
- la présence du formulaire ;
- un compte inconnu ;
- un compte connu.

Résultat :

```text
3 tests
2 passed
0 failed
1 skipped
```

Défaut connu :

```text
MDP-03 - Un compte connu doit recevoir un email de réinitialisation
```

Pour un compte connu, l'application reconnaît le compte mais affiche :

```text
The email could not be sent.
Possible reason: your host may have disabled the mail() function.
```

L'envoi réel du lien de réinitialisation ne peut donc pas être validé dans l'environnement testé.

---

# Gestion des défauts connus

Les scénarios présentant un écart connu portent le tag :

```text
defect
```

Pour exécuter la campagne sans ces défauts :

```powershell
py -m robot --skip defect --outputdir results tests
```

Les neuf scénarios concernés sont :

```text
US07 - Le formulaire de réservation doit contenir un message obligatoire
US07 - Une demande de réservation doit créer un message côté hôte
US08 - Une nouvelle demande doit avoir le statut NOUVEAU
US08 - Une réservation initiale doit proposer l'action Annuler au voyageur
ANN-04-US - Le titre seul devrait permettre de quitter l'étape Information selon l'US
ANN-08-US - L'adresse seule devrait permettre de quitter l'étape Localisation selon l'US
TR-03 - Après confirmation le statut Hôte doit être ATTENTE DE PAIEMENT
TR-04 - Le refus Hôte rend la réservation REFUSE des deux côtés
MDP-03 - Un compte connu doit recevoir un email de réinitialisation
```

Ils peuvent être réactivés lorsque les anomalies correspondantes sont corrigées.

---

# Rapports Robot Framework

Après exécution, Robot Framework génère :

```text
results/output.xml
results/log.html
results/report.html
```

`log.html` contient le détail des mots-clés exécutés.

`report.html` fournit la synthèse de la campagne.

Le dossier `results/` n'est pas enregistré dans GitHub.

---

# Intégration continue Jenkins

Le pipeline est défini dans :

```text
Jenkinsfile
```

Il réalise automatiquement :

```text
1. Récupération du code depuis GitHub
2. Vérification de l'environnement
3. Installation des dépendances
4. Injection sécurisée des identifiants
5. Exécution des tests Robot Framework
6. Archivage des résultats
```

Commande exécutée :

```powershell
py -m robot --skip defect --outputdir results tests
```

Chrome est exécuté en mode headless dans Jenkins.

Les rapports contenus dans `results/` sont archivés comme artefacts Jenkins.

---

# Résultat de référence

Dernière campagne complète :

```text
66 tests
57 passed
0 failed
9 skipped
```

Statut du pipeline Jenkins :

```text
SUCCESS
```

Les résultats détaillés sont disponibles dans les artefacts du build Jenkins.

---

# Versionnement Git

Le projet est hébergé dans un dépôt GitHub public :

```text
https://github.com/nicot78-lab/pfb-homey-automation
```

Branche principale :

```text
main
```

Les modifications sont enregistrées avec des commits Git afin de conserver l'historique du projet.

Dernière mise en conformité de l'architecture POM :

```text
a1c10e9 - Mise en conformité POM des tests Robot Framework
```

---

# Reproductibilité

Les principes appliqués sont :

- aucune donnée sensible enregistrée dans Git ;
- utilisation de variables d'environnement ;
- utilisation de Jenkins Credentials ;
- données uniques pour les créations de comptes ;
- titres uniques pour les annonces ;
- image de test versionnée ;
- variables communes externalisées ;
- sélecteurs et actions techniques placés dans les ressources ;
- séparation entre scénarios de tests et logique des pages ;
- absence de chemins Windows personnels dans les scénarios ;
- dépendances documentées dans `requirements.txt` ;
- même commande de campagne en local et dans Jenkins ;
- rapports Robot Framework générés automatiquement.

---

# État actuel du projet

```text
Smoke                       : PASS
US-07                       : PASS hors défauts connus
US-08                       : PASS hors défauts connus
Connexion                   : PASS
Inscription                 : PASS
Devenir Hôte                : PASS
Créer annonce               : PASS hors défauts connus
Traiter une réservation     : PASS hors défauts connus
Régénérer mot de passe      : PASS hors défaut connu

Total                       : 66 tests
Réussis                     : 57
Échecs                      : 0
Ignorés                     : 9
Jenkins                     : SUCCESS
```

Chaîne d'automatisation :

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