*** Settings ***
Library     DateTime
Library     SeleniumLibrary
Resource    ../variables.robot


*** Keywords ***

Se connecter comme hôte
    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}


Générer un titre d'annonce
    ${timestamp}=    Get Current Date
    ...    result_format=%Y%m%d%H%M%S%f

    ${titre}=    Set Variable    Annonce Auto ${timestamp}

    RETURN    ${titre}


Générer un titre de brouillon
    ${timestamp}=    Get Current Date
    ...    result_format=%Y%m%d%H%M%S%f

    ${titre}=    Set Variable    Brouillon Auto ${timestamp}

    RETURN    ${titre}


L'étape Médias doit être prête
    Wait Until Page Contains Element
    ...    css=#submit_listing_form input[type='file']
    ...    15s


Préparer l'étape Information
    [Arguments]    ${titre}

    Se connecter comme hôte
    Ouvrir la création d'annonce

    Renseigner les informations obligatoires de l'annonce
    ...    ${titre}


Préparer l'étape Médias
    [Arguments]    ${titre}

    Préparer l'étape Information
    ...    ${titre}

    Continuer vers l'étape suivante
    L'étape Tarifs doit être affichée

    Renseigner les tarifs de l'annonce

    Continuer vers l'étape suivante
    L'étape Médias doit être prête


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