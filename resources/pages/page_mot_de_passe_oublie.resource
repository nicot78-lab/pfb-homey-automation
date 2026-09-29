*** Settings ***
Library     SeleniumLibrary
Resource    ../variables.robot
Resource    page_connexion.resource
Resource    page_inscription.resource


*** Variables ***
${CHAMP_MOT_DE_PASSE_OUBLIE}      css=#user_login_forgot
${BOUTON_MOT_DE_PASSE_OUBLIE}     css=#homey_forgetpass
${MESSAGE_MOT_DE_PASSE_OUBLIE}    css=#homey_msg_reset


*** Keywords ***

Ouvrir la popup Mot de passe oublié
    acceder à la page de connexion
    Ouvrir le parcours Mot de passe oublié
    La fenêtre Mot de passe oublié doit être affichée


Soumettre une demande de réinitialisation
    [Arguments]    ${email}

    Wait Until Element Is Visible
    ...    ${CHAMP_MOT_DE_PASSE_OUBLIE}
    ...    10s

    Clear Element Text
    ...    ${CHAMP_MOT_DE_PASSE_OUBLIE}

    Input Text
    ...    ${CHAMP_MOT_DE_PASSE_OUBLIE}
    ...    ${email}

    Click Element
    ...    ${BOUTON_MOT_DE_PASSE_OUBLIE}


Attendre le message final
    Wait Until Keyword Succeeds
    ...    20x
    ...    1s
    ...    Vérifier que le message est final


Vérifier que le message est final
    ${message}=    Get Text
    ...    ${MESSAGE_MOT_DE_PASSE_OUBLIE}

    Should Not Be Empty
    ...    ${message}

    Should Not Contain
    ...    ${message}
    ...    ${MESSAGE_ATTENTE}


Générer un email inconnu
    ${timestamp}=    Evaluate
    ...    str(__import__('time').time_ns())

    ${email}=    Set Variable
    ...    inconnu${timestamp}@example.com

    RETURN    ${email}


Créer un compte Voyageur pour le test
    ${timestamp}=    Evaluate
    ...    str(__import__('time').time_ns())

    ${username}=    Set Variable
    ...    mdp${timestamp}

    ${email}=    Set Variable
    ...    mdp${timestamp}@example.com

    Ouvrir la fenêtre d'inscription

    Renseigner le formulaire d'inscription
    ...    ${username}
    ...    ${email}
    ...    ${MOT_DE_PASSE_TEST}
    ...    ${MOT_DE_PASSE_TEST}

    Accepter les termes et conditions
    Valider l'inscription

    Sleep    3s

    RETURN    ${email}


Le compte inconnu doit afficher une erreur
    ${message}=    Get Text
    ...    ${MESSAGE_MOT_DE_PASSE_OUBLIE}

    Should Match Regexp
    ...    ${message}
    ...    (?i)(no user registered|not found|introuvable|n'existe)


Le compte connu doit confirmer l'envoi de réinitialisation
    ${message}=    Get Text
    ...    ${MESSAGE_MOT_DE_PASSE_OUBLIE}

    Should Not Contain
    ...    ${message}
    ...    The email could not be sent.

    Should Match Regexp
    ...    ${message}
    ...    (?i)(email.*sent|sent.*email|lien.*envoy|reset.*link)