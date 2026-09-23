*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Test Cases ***

HOTE-01 - Un visiteur peut accéder à la page Devenir un hôte
    [Tags]    HOTE    interface

    Ouvrir la page Devenir un hôte depuis le menu

    La page Devenir un hôte doit être affichée


HOTE-02 - La page explique les étapes pour devenir hôte
    [Tags]    HOTE    interface

    Ouvrir la page Devenir un hôte depuis le menu

    Les étapes pour devenir hôte doivent être affichées


HOTE-03 - Le formulaire Hôte contient les champs obligatoires
    [Tags]    HOTE    formulaire

    Ouvrir la page Devenir un hôte depuis le menu

    Le formulaire Hôte doit être complet


HOTE-04 - Un visiteur peut créer un compte Hôte avec des données valides
    [Tags]    HOTE    nominal

    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${utilisateur}=    Set Variable    hote${timestamp}
    ${email}=    Set Variable    hote${timestamp}@example.com
    ${mot_de_passe}=    Set Variable    Test1234!

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    ${utilisateur}
    ...    ${email}
    ...    ${mot_de_passe}
    ...    ${mot_de_passe}

    Accepter les termes Hôte

    Valider la création du compte Hôte

    Le message de création du compte Hôte doit être affiché

    La popup de connexion doit être ouverte après création du compte Hôte

    Se connecter avec le compte Hôte créé
    ...    ${utilisateur}
    ...    ${mot_de_passe}

    Le tableau de bord Hôte doit contenir les fonctions Hôte


HOTE-05 - La création est refusée si le nom utilisateur est vide
    [Tags]    HOTE    negatif    obligatoire

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    ${EMPTY}
    ...    hotevide@example.com
    ...    Test1234!
    ...    Test1234!

    Accepter les termes Hôte

    Valider la création du compte Hôte

    Le message d'erreur Hôte doit contenir
    ...    The username field is empty.


HOTE-06 - La création est refusée si l'email est vide
    [Tags]    HOTE    negatif    obligatoire

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    hoteemailvide
    ...    ${EMPTY}
    ...    Test1234!
    ...    Test1234!

    Accepter les termes Hôte

    Valider la création du compte Hôte

    Le message d'erreur Hôte doit contenir
    ...    The email field is empty.


HOTE-07 - La création est refusée si le format de l'email est invalide
    [Tags]    HOTE    negatif    validation

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    hoteemailinvalide
    ...    testemailinvalide
    ...    Test1234!
    ...    Test1234!

    Accepter les termes Hôte

    Valider la création du compte Hôte

    Le message d'erreur Hôte doit contenir
    ...    Invalid email address.


HOTE-08 - La création est refusée si le mot de passe est vide
    [Tags]    HOTE    negatif    obligatoire

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    hotepasswordvide
    ...    hotepasswordvide@example.com
    ...    ${EMPTY}
    ...    Test1234!

    Accepter les termes Hôte

    Valider la création du compte Hôte

    Le message d'erreur Hôte doit contenir
    ...    One of the password field is empty!


HOTE-09 - La création est refusée si la confirmation est vide
    [Tags]    HOTE    negatif    obligatoire

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    hoteconfirmationvide
    ...    hoteconfirmationvide@example.com
    ...    Test1234!
    ...    ${EMPTY}

    Accepter les termes Hôte

    Valider la création du compte Hôte

    Le message d'erreur Hôte doit contenir
    ...    One of the password field is empty!


HOTE-10 - La création est refusée si les mots de passe sont différents
    [Tags]    HOTE    negatif    validation

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    hotepassworddifferent
    ...    hotepassworddifferent@example.com
    ...    Test1234!
    ...    Test5678!

    Accepter les termes Hôte

    Valider la création du compte Hôte

    Le message d'erreur Hôte doit contenir
    ...    Passwords do not match


HOTE-11 - La création est refusée si les conditions ne sont pas acceptées
    [Tags]    HOTE    negatif    obligatoire

    Ouvrir la page Devenir un hôte depuis le menu

    Renseigner le formulaire Hôte
    ...    hotetermes
    ...    hotetermes@example.com
    ...    Test1234!
    ...    Test1234!

    Refuser les termes Hôte

    Valider la création du compte Hôte

    Le message d'erreur Hôte doit contenir
    ...    You need to agree with terms & conditions.