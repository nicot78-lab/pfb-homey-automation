*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Variables ***
${MOT_DE_PASSE_INSCRIPTION}    Test1234!


*** Test Cases ***

INS-01 - Un visiteur peut ouvrir la fenêtre d'inscription
    [Tags]    INSCRIPTION    interface

    Ouvrir la fenêtre d'inscription

    La fenêtre d'inscription doit être affichée


INS-02 - Le formulaire d'inscription contient les champs obligatoires
    [Tags]    INSCRIPTION    interface    formulaire

    Ouvrir la fenêtre d'inscription

    Le formulaire d'inscription doit être complet


INS-03 - Un visiteur peut créer un compte avec des données valides
    [Tags]    INSCRIPTION    nominal

    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${utilisateur}=    Set Variable    voyageur${timestamp}
    ${email}=    Set Variable    voyageur${timestamp}@example.com

    Ouvrir la fenêtre d'inscription

    Renseigner le formulaire d'inscription
    ...    ${utilisateur}
    ...    ${email}
    ...    ${MOT_DE_PASSE_INSCRIPTION}
    ...    ${MOT_DE_PASSE_INSCRIPTION}

    Accepter les termes et conditions

    Valider l'inscription

    Le message de création de compte doit être affiché

    La fenêtre de connexion doit être affichée


INS-04 - L'inscription est refusée si le nom d'utilisateur est vide
    [Tags]    INSCRIPTION    controle    negatif

    Ouvrir la fenêtre d'inscription

    Renseigner le formulaire d'inscription
    ...    ${EMPTY}
    ...    testemail@example.com
    ...    ${MOT_DE_PASSE_INSCRIPTION}
    ...    ${MOT_DE_PASSE_INSCRIPTION}

    Accepter les termes et conditions

    Valider l'inscription

    Le message d'erreur d'inscription doit contenir
    ...    The username field is empty.


INS-09 - L'inscription est refusée si le format de l'email est invalide
    [Tags]    INSCRIPTION    controle    negatif

    Ouvrir la fenêtre d'inscription

    Renseigner le formulaire d'inscription
    ...    testemailinvalide
    ...    emailinvalide
    ...    ${MOT_DE_PASSE_INSCRIPTION}
    ...    ${MOT_DE_PASSE_INSCRIPTION}

    Accepter les termes et conditions

    Valider l'inscription

    Le message d'erreur d'inscription doit contenir
    ...    Invalid email address.


INS-13 - L'inscription est refusée si les mots de passe sont différents
    [Tags]    INSCRIPTION    controle    negatif

    Ouvrir la fenêtre d'inscription

    Renseigner le formulaire d'inscription
    ...    testmotdepasse
    ...    testmotdepasse@example.com
    ...    Test1234!
    ...    Test5678!

    Accepter les termes et conditions

    Valider l'inscription

    Le message d'erreur d'inscription doit contenir
    ...    Passwords do not match


INS-14 - L'inscription est refusée si les conditions ne sont pas acceptées
    [Tags]    INSCRIPTION    controle    negatif

    Ouvrir la fenêtre d'inscription

    Renseigner le formulaire d'inscription
    ...    testconditions
    ...    testconditions@example.com
    ...    ${MOT_DE_PASSE_INSCRIPTION}
    ...    ${MOT_DE_PASSE_INSCRIPTION}

    Valider l'inscription

    Le message d'erreur d'inscription doit contenir
    ...    You need to agree with terms & conditions.


INS-16 - Le lien des termes et conditions est accessible
    [Tags]    INSCRIPTION    navigation    conditions

    Ouvrir la fenêtre d'inscription

    Ouvrir les termes et conditions

    La page des termes et conditions doit être affichée


INS-18 - L'inscription est accessible depuis la fenêtre de connexion
    [Tags]    INSCRIPTION    navigation

    acceder à la page de connexion

    Ouvrir l'inscription depuis la fenêtre de connexion

    La fenêtre d'inscription doit être affichée