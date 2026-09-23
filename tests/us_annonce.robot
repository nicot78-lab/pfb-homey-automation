*** Settings ***
Resource    ../resources/commun.resource
Library     DateTime

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Variables ***
${HOTE_USER}        %{HOMEY_HOTE_USER}
${HOTE_PASSWORD}    %{HOMEY_HOTE_PASSWORD}


*** Test Cases ***

ANN-01 - Un visiteur non connecté ne voit pas la fonction Créer annonce
    [Tags]    annonce
    La fonction Créer annonce ne doit pas être proposée


ANN-02 - Un hôte connecté peut accéder à la création d'une annonce
    [Tags]    annonce
    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    L'étape Information doit être affichée


ANN-03 - La création est refusée si les champs obligatoires de l'étape Information sont vides
    [Tags]    annonce
    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    Continuer vers l'étape suivante

    Le message d'erreur de création doit être affiché
    L'étape Information doit être affichée


ANN-04 - Un hôte peut compléter l'étape Information
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    Renseigner les informations obligatoires de l'annonce
    ...    ${titre}

    Continuer vers l'étape suivante

    L'étape Tarifs doit être affichée


ANN-04-US - Le titre seul devrait permettre de quitter l'étape Information selon l'US
    [Tags]    annonce    defect
    ${titre}=    Générer un titre d'annonce

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    Renseigner uniquement le titre
    ...    ${titre}

    Continuer vers l'étape suivante

    L'étape Tarifs doit être affichée


ANN-05 - Le tarif par nuit est obligatoire
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    Renseigner les informations obligatoires de l'annonce
    ...    ${titre}

    Continuer vers l'étape suivante

    L'étape Tarifs doit être affichée

    Continuer vers l'étape suivante

    Le message d'erreur de création doit être affiché
    L'étape Tarifs doit être affichée


ANN-06 - Une image est obligatoire à l'étape Médias
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Préparer l'étape Médias
    ...    ${titre}

    Continuer vers l'étape suivante

    L'étape Médias doit être affichée


ANN-07 - Les caractéristiques sont facultatives
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Préparer l'étape Médias
    ...    ${titre}

    Charger l'image de test de l'annonce

    Continuer vers l'étape suivante

    L'étape Caractéristiques doit être affichée

    Continuer vers l'étape suivante

    L'étape Localisation doit être affichée


ANN-08-US - L'adresse seule devrait permettre de quitter l'étape Localisation selon l'US
    [Tags]    annonce    defect
    ${titre}=    Générer un titre d'annonce

    Préparer l'étape Localisation
    ...    ${titre}

    Renseigner uniquement l'adresse de l'annonce

    Continuer vers l'étape suivante

    L'étape Règlement intérieur doit être affichée


ANN-09 - Une localisation complète permet d'accéder au règlement intérieur
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Préparer l'étape Localisation
    ...    ${titre}

    Renseigner la localisation complète de l'annonce

    Continuer vers l'étape suivante

    L'étape Règlement intérieur doit être affichée


ANN-10 - Le bouton Retour permet de revenir à l'étape précédente
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    Renseigner les informations obligatoires de l'annonce
    ...    ${titre}

    Continuer vers l'étape suivante

    L'étape Tarifs doit être affichée

    Retourner à l'étape précédente

    L'étape Information doit être affichée


ANN-11 - Un hôte peut enregistrer une annonce comme brouillon
    [Tags]    annonce
    ${titre}=    Générer un titre de brouillon

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    Renseigner uniquement le titre
    ...    ${titre}

    Enregistrer l'annonce comme brouillon

    Ouvrir Mes annonces

    Le brouillon doit être visible
    ...    ${titre}


ANN-12 - Un hôte peut soumettre une annonce complète
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Préparer le règlement intérieur
    ...    ${titre}

    Renseigner le règlement intérieur

    Soumettre l'annonce

    Le message de confirmation de l'annonce doit être affiché


ANN-13 - Une annonce soumise est immédiatement publiée
    [Tags]    annonce
    ${titre}=    Générer un titre d'annonce

    Préparer le règlement intérieur
    ...    ${titre}

    Renseigner le règlement intérieur

    Soumettre l'annonce

    Le message de confirmation de l'annonce doit être affiché

    L'annonce publiée doit être visible dans Mes annonces
    ...    ${titre}



*** Keywords ***

Générer un titre d'annonce
    ${timestamp}=    Get Current Date
    ...    result_format=%Y%m%d%H%M%S%f

    ${titre}=    Set Variable
    ...    Annonce Auto ${timestamp}

    RETURN    ${titre}


Générer un titre de brouillon
    ${timestamp}=    Get Current Date
    ...    result_format=%Y%m%d%H%M%S%f

    ${titre}=    Set Variable
    ...    Brouillon Auto ${timestamp}

    RETURN    ${titre}


Préparer l'étape Médias
    [Arguments]    ${titre}

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir la création d'annonce

    Renseigner les informations obligatoires de l'annonce
    ...    ${titre}

    Continuer vers l'étape suivante

    L'étape Tarifs doit être affichée

    Renseigner les tarifs de l'annonce

    Continuer vers l'étape suivante

    L'étape Médias doit être affichée


Préparer l'étape Localisation
    [Arguments]    ${titre}

    Préparer l'étape Médias
    ...    ${titre}

    Charger l'image de test de l'annonce

    Continuer vers l'étape suivante

    L'étape Caractéristiques doit être affichée

    Continuer vers l'étape suivante

    L'étape Localisation doit être affichée


Préparer le règlement intérieur
    [Arguments]    ${titre}

    Préparer l'étape Localisation
    ...    ${titre}

    Renseigner la localisation complète de l'annonce

    Continuer vers l'étape suivante

    L'étape Règlement intérieur doit être affichée