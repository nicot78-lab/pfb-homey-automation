*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL HOTE}    http://livraison3.testacademy.fr/index.php/become-a-host/

${lien devenir hote}    xpath=//a[contains(normalize-space(.),'Devenir un hôte')]

${formulaire hote}    xpath=//form[.//input[@name='role' and @value='homey_host']]

${champ hote utilisateur}    xpath=//form[.//input[@name='role' and @value='homey_host']]//input[@name='username']
${champ hote email}    xpath=//form[.//input[@name='role' and @value='homey_host']]//input[@name='useremail']
${champ hote mot de passe}    xpath=//form[.//input[@name='role' and @value='homey_host']]//input[@name='register_pass']
${champ hote confirmation}    xpath=//form[.//input[@name='role' and @value='homey_host']]//input[@name='register_pass_retype']

${case termes hote}    xpath=//form[.//input[@name='role' and @value='homey_host']]//input[@name='term_condition']

${bouton inscription hote}    xpath=//form[.//input[@name='role' and @value='homey_host']]//button[contains(normalize-space(.),"S'inscrire")]

${message succes hote}    Your account was created and you can login now!

${champ connexion apres creation hote}    css=#modal-login input[name='username']
${champ mot de passe connexion apres creation hote}    css=#modal-login input[name='password']
${bouton connexion apres creation hote}    css=#modal-login button[type='submit']


*** Keywords ***

Ouvrir la page Devenir un hôte depuis le menu
    Wait Until Page Contains Element
    ...    ${lien devenir hote}
    ...    15s

    Click Element
    ...    ${lien devenir hote}

    Wait Until Location Contains
    ...    /become-a-host/
    ...    15s


La page Devenir un hôte doit être affichée
    Wait Until Location Contains
    ...    /become-a-host/
    ...    15s

    Page Should Contain
    ...    Become a Host

    Page Should Contain
    ...    Register


Les étapes pour devenir hôte doivent être affichées
    Page Should Contain
    ...    How To Become a Homey Host

    Page Should Contain
    ...    1. List Your Place

    Page Should Contain
    ...    2. Welcome Your Guests

    Page Should Contain
    ...    3. Earn Money


Le formulaire Hôte doit être complet
    Wait Until Element Is Visible
    ...    ${champ hote utilisateur}
    ...    10s

    Element Should Be Visible
    ...    ${champ hote utilisateur}

    Element Should Be Visible
    ...    ${champ hote email}

    Element Should Be Visible
    ...    ${champ hote mot de passe}

    Element Should Be Visible
    ...    ${champ hote confirmation}

    Element Should Be Visible
    ...    ${case termes hote}

    Element Should Be Visible
    ...    ${bouton inscription hote}


Renseigner le formulaire Hôte
    [Arguments]    ${utilisateur}    ${email}    ${mot_de_passe}    ${confirmation}

    Wait Until Keyword Succeeds
    ...    3x
    ...    500ms
    ...    Renseigner et vérifier le formulaire Hôte
    ...    ${utilisateur}
    ...    ${email}
    ...    ${mot_de_passe}
    ...    ${confirmation}


Renseigner et vérifier le formulaire Hôte
    [Arguments]    ${utilisateur}    ${email}    ${mot_de_passe}    ${confirmation}

    Wait Until Element Is Visible
    ...    ${champ hote utilisateur}
    ...    10s

    Clear Element Text
    ...    ${champ hote email}

    Input Text
    ...    ${champ hote email}
    ...    ${email}

    Clear Element Text
    ...    ${champ hote mot de passe}

    Input Text
    ...    ${champ hote mot de passe}
    ...    ${mot_de_passe}

    Clear Element Text
    ...    ${champ hote confirmation}

    Input Text
    ...    ${champ hote confirmation}
    ...    ${confirmation}

    Clear Element Text
    ...    ${champ hote utilisateur}

    Input Text
    ...    ${champ hote utilisateur}
    ...    ${utilisateur}

    Sleep    200ms

    ${valeur_utilisateur}=    Get Value
    ...    ${champ hote utilisateur}

    ${valeur_email}=    Get Value
    ...    ${champ hote email}

    ${valeur_mot_de_passe}=    Get Value
    ...    ${champ hote mot de passe}

    ${valeur_confirmation}=    Get Value
    ...    ${champ hote confirmation}

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


Accepter les termes Hôte
    Wait Until Element Is Visible
    ...    ${case termes hote}
    ...    10s

    Select Checkbox
    ...    ${case termes hote}

    Checkbox Should Be Selected
    ...    ${case termes hote}


Refuser les termes Hôte
    Wait Until Element Is Visible
    ...    ${case termes hote}
    ...    10s

    Unselect Checkbox
    ...    ${case termes hote}


Valider la création du compte Hôte
    Wait Until Element Is Visible
    ...    ${bouton inscription hote}
    ...    10s

    Click Button
    ...    ${bouton inscription hote}


Le message de création du compte Hôte doit être affiché
    Wait Until Page Contains
    ...    ${message succes hote}
    ...    15s


La popup de connexion doit être ouverte après création du compte Hôte
    Wait Until Element Is Visible
    ...    ${champ connexion apres creation hote}
    ...    15s

    Element Should Be Visible
    ...    ${champ mot de passe connexion apres creation hote}

    Element Should Be Visible
    ...    ${bouton connexion apres creation hote}


Le message d'erreur Hôte doit contenir
    [Arguments]    ${message}

    Wait Until Page Contains
    ...    ${message}
    ...    10s


Se connecter avec le compte Hôte créé
    [Arguments]    ${utilisateur}    ${mot_de_passe}

    Wait Until Element Is Visible
    ...    ${champ connexion apres creation hote}
    ...    15s

    Clear Element Text
    ...    ${champ connexion apres creation hote}

    Input Text
    ...    ${champ connexion apres creation hote}
    ...    ${utilisateur}

    Clear Element Text
    ...    ${champ mot de passe connexion apres creation hote}

    Input Text
    ...    ${champ mot de passe connexion apres creation hote}
    ...    ${mot_de_passe}

    Click Button
    ...    ${bouton connexion apres creation hote}

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s


Le tableau de bord Hôte doit contenir les fonctions Hôte
    Wait Until Location Contains
    ...    /dashboard/
    ...    20s

    Page Should Contain
    ...    Tableau de bord

    Page Should Contain
    ...    Mes annonces

    Page Should Contain
    ...    Créer annonce

    Page Should Contain
    ...    Réservations

    Page Should Contain
    ...    Portefeuille

    Page Should Contain
    ...    Messages

    Page Should Contain
    ...    Factures

    Page Should Contain
    ...    Favoris