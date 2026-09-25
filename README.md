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