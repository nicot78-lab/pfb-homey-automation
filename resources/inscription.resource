*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${fenetre inscription}    id=modal-register

${champ inscription utilisateur}    css=#modal-register input[name='username']
${champ inscription email}    css=#modal-register input[name='useremail']
${champ inscription mot de passe}    css=#modal-register input[name='register_pass']
${champ inscription confirmation}    css=#modal-register input[name='register_pass_retype']

${case termes inscription}    css=#modal-register input[name='term_condition']
${lien termes inscription}    xpath=//div[@id='modal-register']//a[contains(normalize-space(.),'termes et conditions')]

${bouton inscription}    xpath=//div[@id='modal-register']//button[contains(normalize-space(.),"S'inscrire")]
${lien connexion depuis inscription}    xpath=//div[@id='modal-register']//a[contains(normalize-space(.),'Se connecter')]
${lien inscription depuis connexion}    xpath=//div[@id='modal-login']//a[contains(normalize-space(.),"S'inscrire")]

${message succes inscription}    Your account was created and you can login now!


*** Keywords ***

Ouvrir la fenêtre d'inscription
    Wait Until Page Contains
    ...    S'inscrire
    ...    15s

    Execute JavaScript
    ...    const els=[...document.querySelectorAll("a")]; const el=els.find(e=>e.offsetParent!==null && /inscrire/i.test((e.textContent||"").trim())); if(!el){throw new Error("Lien S'inscrire introuvable");} el.click();

    Wait Until Element Is Visible
    ...    ${fenetre inscription}
    ...    10s


La fenêtre d'inscription doit être affichée
    Wait Until Element Is Visible
    ...    ${fenetre inscription}
    ...    10s

    Page Should Contain
    ...    S'inscrire


Le formulaire d'inscription doit être complet
    Wait Until Element Is Visible
    ...    ${champ inscription utilisateur}
    ...    10s

    Element Should Be Visible
    ...    ${champ inscription utilisateur}

    Element Should Be Visible
    ...    ${champ inscription email}

    Element Should Be Visible
    ...    ${champ inscription mot de passe}

    Element Should Be Visible
    ...    ${champ inscription confirmation}

    Element Should Be Visible
    ...    ${case termes inscription}

    Element Should Be Visible
    ...    ${bouton inscription}

    Element Should Be Visible
    ...    ${lien connexion depuis inscription}


Renseigner le formulaire d'inscription
    [Arguments]    ${utilisateur}    ${email}    ${mot_de_passe}    ${confirmation}

    Wait Until Keyword Succeeds
    ...    3x
    ...    500ms
    ...    Renseigner et vérifier le formulaire d'inscription
    ...    ${utilisateur}
    ...    ${email}
    ...    ${mot_de_passe}
    ...    ${confirmation}


Renseigner et vérifier le formulaire d'inscription
    [Arguments]    ${utilisateur}    ${email}    ${mot_de_passe}    ${confirmation}

    Wait Until Element Is Visible
    ...    ${champ inscription utilisateur}
    ...    10s

    Clear Element Text
    ...    ${champ inscription email}

    Input Text
    ...    ${champ inscription email}
    ...    ${email}

    Clear Element Text
    ...    ${champ inscription mot de passe}

    Input Text
    ...    ${champ inscription mot de passe}
    ...    ${mot_de_passe}

    Clear Element Text
    ...    ${champ inscription confirmation}

    Input Text
    ...    ${champ inscription confirmation}
    ...    ${confirmation}

    Clear Element Text
    ...    ${champ inscription utilisateur}

    Input Text
    ...    ${champ inscription utilisateur}
    ...    ${utilisateur}

    Sleep    200ms

    ${valeur_utilisateur}=    Get Value
    ...    ${champ inscription utilisateur}

    ${valeur_email}=    Get Value
    ...    ${champ inscription email}

    ${valeur_mot_de_passe}=    Get Value
    ...    ${champ inscription mot de passe}

    ${valeur_confirmation}=    Get Value
    ...    ${champ inscription confirmation}

    Should Be Equal
    ...    ${valeur_utilisateur}
    ...    ${utilisateur}

    Should Be Equal
    ...    ${valeur_email}
    ...    ${email}

    Should Be Equal
    ...    ${valeur_mot_de_passe}
    ...    ${mot_de_passe}

    Should Be Equal
    ...    ${valeur_confirmation}
    ...    ${confirmation}


Accepter les termes et conditions
    Wait Until Element Is Visible
    ...    ${case termes inscription}
    ...    10s

    Select Checkbox
    ...    ${case termes inscription}

    Checkbox Should Be Selected
    ...    ${case termes inscription}


Valider l'inscription
    Wait Until Element Is Visible
    ...    ${bouton inscription}
    ...    10s

    Click Button
    ...    ${bouton inscription}


Le message de création de compte doit être affiché
    Wait Until Page Contains
    ...    ${message succes inscription}
    ...    15s


Le message d'erreur d'inscription doit contenir
    [Arguments]    ${message}

    Wait Until Page Contains
    ...    ${message}
    ...    10s


Ouvrir les termes et conditions
    Wait Until Element Is Visible
    ...    ${lien termes inscription}
    ...    10s

    Click Element
    ...    ${lien termes inscription}

    Sleep    1s

    Run Keyword And Ignore Error
    ...    Switch Window
    ...    NEW


La page des termes et conditions doit être affichée
    Wait Until Page Contains
    ...    Termes et conditions
    ...    10s


Ouvrir l'inscription depuis la fenêtre de connexion
    Wait Until Element Is Visible
    ...    ${lien inscription depuis connexion}
    ...    10s

    Click Element
    ...    ${lien inscription depuis connexion}

    Wait Until Element Is Visible
    ...    ${fenetre inscription}
    ...    10s