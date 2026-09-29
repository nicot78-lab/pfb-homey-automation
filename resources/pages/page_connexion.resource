*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${champ nom_utilisateur}    css=#modal-login input[name='username']
${champ mot de passe}    css=#modal-login input[name='password']
${bouton se connecter}    css=#modal-login button[type='submit']

${champ utilisateur valide}    %{HOMEY_VOYAGEUR_USER}
${champ mot de passe valide}    %{HOMEY_VOYAGEUR_PASSWORD}

${case souvenir connexion}    xpath=//div[@id='modal-login']//input[@type='checkbox']
${lien mot de passe oublie}    xpath=//div[@id='modal-login']//a[contains(normalize-space(.),'mot de passe oublié')]

${message connexion succes}    Login successful


*** Keywords ***

acceder à la page de connexion
    Wait Until Page Contains Element
    ...    css=a[data-target='#modal-login']
    ...    15s

    Execute JavaScript
    ...    const els=[...document.querySelectorAll("a[data-target='#modal-login']")]; const el=els.find(e=>e.offsetParent!==null) || els[0]; if(!el){throw new Error("Lien de connexion introuvable");} el.click();

    Wait Until Element Is Visible
    ...    ${champ nom_utilisateur}
    ...    10s


saisir le nom d'utilisateur
    [Arguments]    ${utilisateur}

    Wait Until Element Is Visible
    ...    ${champ nom_utilisateur}
    ...    10s

    Clear Element Text
    ...    ${champ nom_utilisateur}

    Input Text
    ...    ${champ nom_utilisateur}
    ...    ${utilisateur}


saisir le mot de passe
    [Arguments]    ${mot_de_passe}

    Wait Until Element Is Visible
    ...    ${champ mot de passe}
    ...    10s

    Clear Element Text
    ...    ${champ mot de passe}

    Input Text
    ...    ${champ mot de passe}
    ...    ${mot_de_passe}


Soumettre le formulaire de connexion
    Wait Until Element Is Visible
    ...    ${bouton se connecter}
    ...    10s

    Execute JavaScript
    ...    const b=document.querySelector("#modal-login button[type='submit']"); if(!b){throw new Error("Bouton de connexion introuvable");} b.click();


Saisir le nom d'utilisateur et le mot de passe
    [Arguments]    ${utilisateur}    ${mot_de_passe}

    Wait Until Keyword Succeeds
    ...    3x
    ...    500ms
    ...    Renseigner et vérifier les identifiants de connexion
    ...    ${utilisateur}
    ...    ${mot_de_passe}


Renseigner et vérifier les identifiants de connexion
    [Arguments]    ${utilisateur}    ${mot_de_passe}

    Wait Until Element Is Visible
    ...    ${champ nom_utilisateur}
    ...    10s

    Clear Element Text
    ...    ${champ mot de passe}

    Input Text
    ...    ${champ mot de passe}
    ...    ${mot_de_passe}

    Clear Element Text
    ...    ${champ nom_utilisateur}

    Input Text
    ...    ${champ nom_utilisateur}
    ...    ${utilisateur}

    Sleep    200ms

    ${valeur_utilisateur}=    Get Value
    ...    ${champ nom_utilisateur}

    ${valeur_mot_de_passe}=    Get Value
    ...    ${champ mot de passe}

    Should Be Equal
    ...    ${valeur_utilisateur}
    ...    ${utilisateur}

    Should Be Equal
    ...    ${valeur_mot_de_passe}
    ...    ${mot_de_passe}


Se connecter avec un compte valide
    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${champ mot de passe valide}

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s


La fenêtre de connexion doit être affichée
    Wait Until Element Is Visible
    ...    ${champ nom_utilisateur}
    ...    10s

    Element Should Be Visible
    ...    ${champ mot de passe}

    Element Should Be Visible
    ...    ${bouton se connecter}


Le formulaire de connexion doit être complet
    Wait Until Element Is Visible
    ...    ${champ nom_utilisateur}
    ...    10s

    Element Should Be Visible
    ...    ${champ nom_utilisateur}

    Element Should Be Visible
    ...    ${champ mot de passe}

    Element Should Be Visible
    ...    ${case souvenir connexion}

    Element Should Be Visible
    ...    ${lien mot de passe oublie}

    Element Should Be Visible
    ...    ${bouton se connecter}


Préparer la capture de la réponse de connexion
    Execute JavaScript
    ...    sessionStorage.removeItem("robot_login_response"); if(!window.__robotXHRInstalled){const oldSend=XMLHttpRequest.prototype.send; XMLHttpRequest.prototype.send=function(){this.addEventListener("load",function(){try{const ancien=sessionStorage.getItem("robot_login_response")||""; sessionStorage.setItem("robot_login_response",ancien+(this.responseText||""));}catch(e){}}); return oldSend.apply(this,arguments);}; window.__robotXHRInstalled=true;}


Soumettre la connexion et vérifier le succès
    Préparer la capture de la réponse de connexion

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s

    La réponse de connexion doit contenir le succès


La réponse de connexion doit contenir le succès
    ${reponse}=    Execute JavaScript
    ...    return sessionStorage.getItem("robot_login_response") || "";

    Should Contain
    ...    ${reponse}
    ...    ${message connexion succes}
    ...    La connexion redirige bien vers le tableau de bord mais la réponse AJAX ne contient pas le message de succès attendu


Le tableau de bord Voyageur doit être complet
    Wait Until Location Contains
    ...    /dashboard/
    ...    20s

    Page Should Contain    Tableau de bord
    Page Should Contain    Profil
    Page Should Contain    Voyages
    Page Should Contain    Portefeuille
    Page Should Contain    Messages
    Page Should Contain    Factures
    Page Should Contain    Favoris
    Page Should Contain    Se déconnecter


Le message d'erreur de connexion doit contenir
    [Arguments]    ${message}

    Wait Until Page Contains
    ...    ${message}
    ...    10s


Cocher Se souvenir de moi
    Wait Until Element Is Visible
    ...    ${case souvenir connexion}
    ...    10s

    Select Checkbox
    ...    ${case souvenir connexion}


La case Se souvenir de moi doit être cochée
    Checkbox Should Be Selected
    ...    ${case souvenir connexion}


Ouvrir le parcours Mot de passe oublié
    Wait Until Element Is Visible
    ...    ${lien mot de passe oublie}
    ...    10s

    Click Element
    ...    ${lien mot de passe oublie}

    Wait Until Page Contains
    ...    Mot de passe oublié
    ...    10s


La fenêtre Mot de passe oublié doit être affichée
    Wait Until Page Contains
    ...    Mot de passe oublié
    ...    10s

    ${champ_visible}=    Execute JavaScript
    ...    return (()=>{const visible=e=>e.getClientRects().length>0&&getComputedStyle(e).display!=="none"&&getComputedStyle(e).visibility!=="hidden";return [...document.querySelectorAll("input")].some(e=>{const p=(e.getAttribute("placeholder")||"").toLowerCase();return visible(e)&&(p.includes("utilisateur")||p.includes("email"));});})();

    Should Be True
    ...    ${champ_visible}
    ...    Le champ utilisateur ou email du mot de passe oublié n'est pas visible

    ${controle_visible}=    Execute JavaScript
    ...    return (()=>{const visible=e=>e.getClientRects().length>0&&getComputedStyle(e).display!=="none"&&getComputedStyle(e).visibility!=="hidden";const titres=[...document.querySelectorAll("body *")].filter(e=>visible(e)&&/mot de passe oublié/i.test((e.innerText||"").trim()));for(const titre of titres){const modal=titre.closest(".modal");if(!modal)continue;const controles=[...modal.querySelectorAll("button,input[type='submit'],input[type='button'],a.btn,a")].filter(visible);if(controles.some(e=>{const t=(e.innerText||e.value||e.getAttribute("aria-label")||"").replace(/\s+/g," ").trim();return t.length>0;}))return true;}return false;})();

    Should Be True
    ...    ${controle_visible}
    ...    Aucun contrôle de soumission visible n'a été trouvé dans la fenêtre Mot de passe oublié


Vérifier que le visiteur est non connecté
    Page Should Contain Element
    ...    css=a[data-target='#modal-login']