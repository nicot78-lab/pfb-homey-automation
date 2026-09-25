*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Variables ***
${MESSAGE_ATTENTE}    veuillez patienter


*** Test Cases ***

MDP-01 - Un utilisateur peut ouvrir la popup Mot de passe oublié
    [Tags]    mot-de-passe

    Ouvrir la popup Mot de passe oublié

    Page Should Contain    Mot de passe oublié
    Element Should Be Visible    css=#user_login_forgot
    Element Should Be Visible    css=#homey_forgetpass


MDP-02 - Un compte inconnu affiche un message d'erreur
    [Tags]    mot-de-passe    compte-inconnu

    ${email}=    Evaluate
    ...    "inconnu" + str(__import__('time').time_ns()) + "@example.com"

    Ouvrir la popup Mot de passe oublié
    Soumettre une demande de réinitialisation    ${email}
    Attendre le message final

    ${message}=    Get Text    css=#homey_msg_reset

    Log To Console    \nMESSAGE FINAL COMPTE INCONNU : ${message}

    Should Match Regexp
    ...    ${message}
    ...    (?i)(no user registered|not found|introuvable|n'existe)


MDP-03 - Un compte connu doit recevoir un email de réinitialisation
    [Tags]    mot-de-passe    compte-connu    defect

    ${email}=    Créer un compte Voyageur pour le test

    Ouvrir la popup Mot de passe oublié
    Soumettre une demande de réinitialisation    ${email}
    Attendre le message final

    ${message}=    Get Text    css=#homey_msg_reset

    Log To Console    \nMESSAGE FINAL COMPTE CONNU : ${message}

    Should Not Contain
    ...    ${message}
    ...    The email could not be sent.

    Should Match Regexp
    ...    ${message}
    ...    (?i)(email.*sent|sent.*email|lien.*envoy|reset.*link)


*** Keywords ***

Ouvrir la popup Mot de passe oublié
    acceder à la page de connexion

    Wait Until Element Is Visible
    ...    css=#modal-login a[data-target='#modal-login-forgot-password']
    ...    10s

    Click Element
    ...    css=#modal-login a[data-target='#modal-login-forgot-password']

    Wait Until Element Is Visible
    ...    css=#user_login_forgot
    ...    10s


Soumettre une demande de réinitialisation
    [Arguments]    ${email}

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("#user_login_forgot")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Champ email visible introuvable");} e.value="${email}"; e.dispatchEvent(new Event("input",{bubbles:true})); e.dispatchEvent(new Event("change",{bubbles:true}));

    ${valeur}=    Execute JavaScript
    ...    const e=[...document.querySelectorAll("#user_login_forgot")].find(x=>x.offsetParent!==null); return e ? e.value : "";

    Should Be Equal    ${valeur}    ${email}

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("#homey_forgetpass")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Bouton Soumettre visible introuvable");} e.click();


Attendre le message final
    Wait Until Keyword Succeeds
    ...    20x
    ...    1s
    ...    Vérifier que le message est final


Vérifier que le message est final
    ${message}=    Get Text    css=#homey_msg_reset

    Should Not Be Empty    ${message}

    Should Not Contain
    ...    ${message}
    ...    ${MESSAGE_ATTENTE}


Créer un compte Voyageur pour le test
    ${timestamp}=    Evaluate
    ...    str(__import__('time').time_ns())

    ${username}=    Set Variable    mdp${timestamp}
    ${email}=       Set Variable    mdp${timestamp}@example.com
    ${password}=    Set Variable    Test1234!

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a[data-target='#modal-register']")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Lien inscription introuvable");} e.click();

    Wait Until Element Is Visible
    ...    css=#modal-register input[name='username']
    ...    10s

    Input Text
    ...    css=#modal-register input[name='username']
    ...    ${username}

    Input Text
    ...    css=#modal-register input[name='useremail']
    ...    ${email}

    Input Text
    ...    css=#modal-register input[name='register_pass']
    ...    ${password}

    Input Text
    ...    css=#modal-register input[name='register_pass_retype']
    ...    ${password}

    Select Checkbox
    ...    css=#modal-register input[name='term_condition']

    Click Button
    ...    css=#modal-register .homey-register-button

    Sleep    3s

    RETURN    ${email}