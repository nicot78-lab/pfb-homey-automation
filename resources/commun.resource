*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL}    http://livraison3.testacademy.fr/
${navigateur}    Chrome

${JENKINS_URL}    %{JENKINS_URL=}


# =========================
# CONNEXION
# =========================
${lien se connecter}    xpath=//a[contains(text(),'Se connecter')]
${champ nom_utilisateur}    css=#modal-login input[name='username']
${champ mot de passe}    css=#modal-login input[name='password']
${bouton se connecter}    css=#modal-login button[type='submit']
${zone erreur}    css=#modal-login .error
${titre tableau de bord}    Tableau de bord - Livraison 3

${champ utilisateur valide}    %{HOMEY_VOYAGEUR_USER}
${champ mot de passe valide}    %{HOMEY_VOYAGEUR_PASSWORD}

${case souvenir connexion}    xpath=//div[@id='modal-login']//input[@type='checkbox']
${lien mot de passe oublie}    xpath=//div[@id='modal-login']//a[contains(normalize-space(.),'mot de passe oublié')]

${message connexion succes}    Login successful


# =========================
# INSCRIPTION
# =========================
${fenetre inscription}    id=modal-register

${champ inscription utilisateur}    xpath=(//div[@id='modal-register']//input[not(@type='checkbox') and not(@type='hidden')])[1]
${champ inscription email}    xpath=(//div[@id='modal-register']//input[not(@type='checkbox') and not(@type='hidden')])[2]
${champ inscription mot de passe}    xpath=(//div[@id='modal-register']//input[not(@type='checkbox') and not(@type='hidden')])[3]
${champ inscription confirmation}    xpath=(//div[@id='modal-register']//input[not(@type='checkbox') and not(@type='hidden')])[4]

${case termes inscription}    xpath=//div[@id='modal-register']//input[@type='checkbox']
${lien termes inscription}    xpath=//div[@id='modal-register']//a[contains(normalize-space(.),'termes et conditions')]

${bouton inscription}    xpath=//div[@id='modal-register']//button[contains(normalize-space(.),"S'inscrire")]
${lien connexion depuis inscription}    xpath=//div[@id='modal-register']//a[contains(normalize-space(.),'Se connecter')]
${lien inscription depuis connexion}    xpath=//div[@id='modal-login']//a[contains(normalize-space(.),"S'inscrire")]

${message succes inscription}    Your account was created and you can login now!


# =========================
# RECHERCHE / ANNONCE
# =========================
${bouton chercher}    css=.search-button > .btn-primary:nth-child(1)
${premiere annonce}    css=.infobox_trigger:nth-child(1) .hover-effect

${titre annonce attendu}    Beautiful Cove
${lien annonce attendu}    http://livraison3.testacademy.fr/index.php/listing/beautiful-cove/


# =========================
# CONTACTER L'HOTE
# =========================
${nom contact valide}    nicolas
${email contact valide}    nicolas@test.gmail
${telephone contact valide}    06123456
${message contact valide}    message pour test de nicolas

${placeholder nom contact}    Nom
${placeholder email contact}    Email
${placeholder telephone contact}    Téléphone
${placeholder message contact}    Message

${lien contacter hote}    xpath=//a[@data-toggle='modal' and @data-target='#modal-contact-host' and contains(normalize-space(.),"Contacter l'hôte")]

${fenetre contacter hote}    id=modal-contact-host
${titre fenetre contacter hote}    xpath=//div[@id='modal-contact-host']//h4[normalize-space(.)="Contactez l'hôte"]

${champ nom contact}    css=#modal-contact-host input[name='name']
${champ email contact}    css=#modal-contact-host input[name='email']
${champ telephone contact}    css=#modal-contact-host input[name='phone']
${champ message contact}    css=#modal-contact-host textarea[name='message']

${bouton soumettre contact}    css=.contact_listing_host
${bouton fermer contacter hote}    css=#modal-contact-host button.close[data-dismiss='modal']

${formulaire contacter hote}    css=#modal-contact-host form[method='POST']
${zone messages contact}    css=#modal-contact-host .homey_contact_messages

${champ cible email hote}    css=#modal-contact-host input[name='target_email'][type='hidden']
${champ securite contact hote}    css=#modal-contact-host input[name='host_contact_security'][type='hidden']
${champ lien annonce contact}    css=#modal-contact-host input[name='permalink'][type='hidden']
${champ titre annonce contact}    css=#modal-contact-host input[name='listing_title'][type='hidden']
${champ action contact}    css=#modal-contact-host input[name='action'][value='homey_host_contact']

${section annonces similaires}    id=similar-listing-section
${premiere annonce similaire}    css=#similar-listing-section a.hover-effect


*** Keywords ***

# =========================
# NAVIGATEUR
# =========================

ouvrir le navigateur et accéder à l'application
    ${options}=    Evaluate
    ...    selenium.webdriver.ChromeOptions()
    ...    modules=selenium.webdriver

    Call Method
    ...    ${options}
    ...    add_argument
    ...    --window-size\=1920,1080

    Call Method
    ...    ${options}
    ...    add_argument
    ...    --disable-notifications

    Call Method
    ...    ${options}
    ...    add_argument
    ...    --disable-popup-blocking

    IF    $JENKINS_URL
        Call Method
        ...    ${options}
        ...    add_argument
        ...    --headless\=new
    END

    Open Browser
    ...    ${URL}
    ...    ${navigateur}
    ...    options=${options}

    Set Window Size    1920    1080

    Wait Until Page Contains Element
    ...    css=body
    ...    15s


fermer le navigateur
    Close All Browsers


# =========================
# CONNEXION
# =========================

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

    Clear Element Text    ${champ nom_utilisateur}
    Input Text    ${champ nom_utilisateur}    ${utilisateur}


saisir le mot de passe
    [Arguments]    ${mot_de_passe}

    Wait Until Element Is Visible
    ...    ${champ mot de passe}
    ...    10s

    Clear Element Text    ${champ mot de passe}
    Input Text    ${champ mot de passe}    ${mot_de_passe}


Soumettre le formulaire de connexion
    Wait Until Element Is Visible
    ...    ${bouton se connecter}
    ...    10s

    Execute JavaScript
    ...    const b=document.querySelector("#modal-login button[type='submit']"); if(!b){throw new Error("Bouton de connexion introuvable");} b.click();


Saisir le nom d'utilisateur et le mot de passe
    [Arguments]    ${utilisateur}    ${mot_de_passe}

    Wait Until Element Is Visible
    ...    ${champ nom_utilisateur}
    ...    10s

    Clear Element Text    ${champ nom_utilisateur}
    Input Text    ${champ nom_utilisateur}    ${utilisateur}

    Wait Until Element Is Visible
    ...    ${champ mot de passe}
    ...    10s

    Clear Element Text    ${champ mot de passe}
    Input Text    ${champ mot de passe}    ${mot_de_passe}


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


Lancer une recherche sans connexion
    Wait Until Element Is Visible
    ...    ${bouton chercher}
    ...    10s

    Click Element
    ...    ${bouton chercher}


Les résultats de recherche doivent être affichés
    Wait Until Page Contains
    ...    Beautiful Cove
    ...    15s

    Page Should Contain
    ...    Large And Modern Bedroom


# =========================
# INSCRIPTION
# =========================

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

    Wait Until Element Is Visible
    ...    ${champ inscription utilisateur}
    ...    10s

    Clear Element Text
    ...    ${champ inscription utilisateur}

    Input Text
    ...    ${champ inscription utilisateur}
    ...    ${utilisateur}

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


# =========================
# ANNONCES
# =========================

Accéder à l'annonce Beautiful Cove
    Wait Until Element Is Visible
    ...    ${bouton chercher}
    ...    10s

    Click Element    ${bouton chercher}

    Execute JavaScript    window.scrollTo(0,0)

    Wait Until Element Is Visible
    ...    ${premiere annonce}
    ...    10s

    Click Element    ${premiere annonce}

    Wait Until Page Contains
    ...    Beautiful Cove
    ...    10s


Accéder à une autre annonce depuis les annonces similaires
    Accéder à l'annonce Beautiful Cove

    Wait Until Element Is Visible
    ...    ${section annonces similaires}
    ...    10s

    Scroll Element Into View
    ...    ${section annonces similaires}

    Wait Until Element Is Visible
    ...    ${premiere annonce similaire}
    ...    10s

    Click Element
    ...    ${premiere annonce similaire}

    Wait Until Element Is Visible
    ...    ${lien contacter hote}
    ...    10s


# =========================
# CONTACTER L'HOTE
# =========================

Ouvrir le formulaire Contacter l'hôte
    Wait Until Element Is Visible
    ...    ${lien contacter hote}
    ...    10s

    Click Element
    ...    ${lien contacter hote}

    Wait Until Element Is Visible
    ...    ${fenetre contacter hote}
    ...    10s


Accéder au formulaire Contacter l'hôte
    Accéder à l'annonce Beautiful Cove
    Ouvrir le formulaire Contacter l'hôte


Saisir les informations de contact
    [Arguments]    ${nom}    ${email}    ${telephone}    ${message}

    Wait Until Element Is Visible
    ...    ${champ nom contact}
    ...    10s

    Clear Element Text    ${champ nom contact}
    Input Text    ${champ nom contact}    ${nom}

    Clear Element Text    ${champ email contact}
    Input Text    ${champ email contact}    ${email}

    Clear Element Text    ${champ telephone contact}
    Input Text    ${champ telephone contact}    ${telephone}

    Clear Element Text    ${champ message contact}
    Input Text    ${champ message contact}    ${message}


Vider les informations de contact
    Clear Element Text    ${champ nom contact}
    Clear Element Text    ${champ email contact}
    Clear Element Text    ${champ telephone contact}
    Clear Element Text    ${champ message contact}