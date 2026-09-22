*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Test Cases ***

CONN-01 - Un visiteur peut ouvrir la fenêtre de connexion
    [Tags]    CONNEXION    interface

    acceder à la page de connexion

    La fenêtre de connexion doit être affichée


CONN-02 - Le formulaire de connexion contient les éléments attendus
    [Tags]    CONNEXION    interface    formulaire

    acceder à la page de connexion

    Le formulaire de connexion doit être complet


CONN-03 - Un voyageur peut se connecter avec des identifiants valides
    [Tags]    CONNEXION    voyageur    nominal

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${champ mot de passe valide}

    Soumettre la connexion et vérifier le succès

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s


CONN-04 - Le tableau de bord Voyageur contient les rubriques attendues
    [Tags]    CONNEXION    voyageur    tableau-de-bord

    Se connecter avec un compte valide

    Le tableau de bord Voyageur doit être complet


CONN-05 - La connexion est refusée avec des identifiants invalides
    [Tags]    CONNEXION    negatif

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    utilisateur_inexistant_999
    ...    MauvaisMotDePasse123!

    Soumettre le formulaire de connexion

    Le message d'erreur de connexion doit contenir
    ...    Invalid username or email


CONN-06 - La connexion est refusée si le nom utilisateur est vide
    [Tags]    CONNEXION    negatif    obligatoire

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${EMPTY}
    ...    Test1234!

    Soumettre le formulaire de connexion

    Le message d'erreur de connexion doit contenir
    ...    The username or email field is empty.


CONN-07 - La connexion est refusée si le mot de passe est vide
    [Tags]    CONNEXION    negatif    obligatoire

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${EMPTY}

    Soumettre le formulaire de connexion

    Le message d'erreur de connexion doit contenir
    ...    The password field is empty.


CONN-08 - La case Se souvenir de moi est sélectionnable
    [Tags]    CONNEXION    interface

    acceder à la page de connexion

    Cocher Se souvenir de moi

    La case Se souvenir de moi doit être cochée


CONN-09 - Le parcours Mot de passe oublié est accessible
    [Tags]    CONNEXION    mot-de-passe-oublie

    acceder à la page de connexion

    Ouvrir le parcours Mot de passe oublié

    La fenêtre Mot de passe oublié doit être affichée


CONN-12 - La recherche reste accessible sans connexion
    [Tags]    CONNEXION    visiteur    recherche

    Vérifier que le visiteur est non connecté

    Lancer une recherche sans connexion

    Les résultats de recherche doivent être affichés


# ==========================================================
# CONN-10 et CONN-11 - COMPTE HOTE
# ==========================================================
#
# Les scénarios de connexion et de tableau de bord Hôte
# restent identifiés dans le plan de tests.
#
# Ils ne sont pas automatisés à ce stade car aucun compte
# Hôte de test valide n'est disponible.
#
# Aucun identifiant ne doit être inventé ou stocké en dur.
# Lorsque des identifiants Hôte seront fournis, ils devront
# être injectés via des variables d'environnement ou des
# Jenkins Credentials.