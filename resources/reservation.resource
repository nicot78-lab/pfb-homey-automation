*** Settings ***
Library    SeleniumLibrary


*** Variables ***

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
# RECHERCHE
# =========================

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