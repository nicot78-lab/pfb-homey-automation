*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL CREATION ANNONCE}    http://livraison3.testacademy.fr/index.php/add-listing/
${IMAGE ANNONCE TEST}      ${EXECDIR}${/}test_data${/}annonce_test.jpg

${formulaire annonce}      css=#submit_listing_form

${lien creer annonce}      xpath=//a[contains(normalize-space(.),'Créer annonce')]
${lien mes annonces}       xpath=//a[contains(normalize-space(.),'Mes annonces')]

${bouton brouillon}        css=#save_as_draft
${bouton continuer}        css=#submit_listing_form .btn-step-next
${bouton retour}           css=#submit_listing_form .btn-step-back
${bouton soumettre}        css=#submit_listing_form .btn-step-submit

${bloc erreur annonce}         css=.validate-errors.alert.alert-danger
${bloc erreur image}           css=.validate-errors-gal.alert.alert-danger
${message erreur annonce}      Erreur! Veuillez remplir les champs obligatoires.
${message erreur image}        Importez au moins une image.
${message succes annonce}      Toutes nos félicitations. Votre annonce a été soumise pour approbation.


# ==========================================================
# ETAPE 1 - INFORMATION
# ==========================================================
${champ titre annonce}          css=#listing_title
${champ type annonce}           css=#listing_type
${champ chambres annonce}       css=#listing_bedrooms
${champ voyageurs annonce}      css=#guests
${champ lits annonce}           css=#beds
${champ bains annonce}          css=#baths
${champ pieces annonce}         css=#listing_rooms
${champ superficie annonce}     css=#listing_size
${champ unite annonce}          css=#listing_size_unit


# ==========================================================
# ETAPE 2 - TARIFS
# ==========================================================
${champ tarif nuit}             css=#night_price
${champ libelle tarif}          css=#price_postfix
${champ frais nettoyage}        css=#submit_listing_form input[name='cleaning_fee']
${champ caution}                css=#security_deposit


# ==========================================================
# ETAPE 3 - MEDIAS
# ==========================================================
${bouton selection image}       css=#select_gallery_images
${champ fichier image}          css=#submit_listing_form input[type='file']
${image chargee cachee}         css=#homey_gallery_container input.listing-image-id[name='listing_image_ids[]']
${vignette image chargee}       css=#homey_gallery_container .upload-gallery-thumb img


# ==========================================================
# ETAPE 4 - CARACTERISTIQUES
# ==========================================================
${titre caracteristiques}       xpath=//div[contains(@class,'form-step') and contains(@class,'active')]//h2[normalize-space()='Caractéristiques']
${equipement climatisation}     css=#amenity-air-conditioning
${equipement wifi}              css=#amenity-wi-fi
${installation parking}         css=#facility-free-parking


# ==========================================================
# ETAPE 5 - LOCALISATION
# ==========================================================
${champ adresse annonce}        css=#listing_address
${champ appt annonce}           css=#aptSuit
${champ ville annonce}          css=#city
${champ departement annonce}    css=#countyState
${champ code postal annonce}    css=#zip
${champ region annonce}         css=#area
${champ pays annonce}           css=#homey_country


*** Keywords ***

# ==========================================================
# ACCES
# ==========================================================

Se connecter en tant qu'hôte
    [Arguments]    ${utilisateur}    ${mot_de_passe}

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${utilisateur}
    ...    ${mot_de_passe}

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s


Ouvrir la création d'annonce
    Wait Until Page Contains Element
    ...    ${lien creer annonce}
    ...    15s

    Execute JavaScript
    ...    const els=[...document.querySelectorAll("a")]; const el=els.find(e=>e.offsetParent!==null && /créer annonce/i.test((e.textContent||"").trim())); if(!el){throw new Error("Lien Créer annonce introuvable");} el.click();

    Wait Until Location Contains
    ...    /add-listing/
    ...    15s

    Wait Until Element Is Visible
    ...    ${champ titre annonce}
    ...    15s


Accéder directement à la création d'annonce
    Go To
    ...    ${URL CREATION ANNONCE}

    Wait Until Element Is Visible
    ...    ${champ titre annonce}
    ...    15s


La fonction Créer annonce ne doit pas être proposée
    Page Should Not Contain Element
    ...    ${lien creer annonce}


# ==========================================================
# ETAPE 1 - INFORMATION
# ==========================================================

L'étape Information doit être affichée
    Wait Until Element Is Visible
    ...    ${champ titre annonce}
    ...    10s


Renseigner uniquement le titre
    [Arguments]    ${titre}

    Clear Element Text
    ...    ${champ titre annonce}

    Input Text
    ...    ${champ titre annonce}
    ...    ${titre}


Renseigner les informations obligatoires de l'annonce
    [Arguments]    ${titre}

    Wait Until Element Is Visible
    ...    ${champ titre annonce}
    ...    10s

    Execute JavaScript
    ...    const r=document.querySelector("#submit_listing_form input[name='room_type'][value='255']"); if(!r){throw new Error("Genre Logement complet introuvable");} r.checked=true; r.dispatchEvent(new Event("change",{bubbles:true}));

    Clear Element Text
    ...    ${champ titre annonce}

    Input Text
    ...    ${champ titre annonce}
    ...    ${titre}

    Execute JavaScript
    ...    const s=document.querySelector("#listing_type"); if(!s){throw new Error("Type annonce introuvable");} s.value="63"; s.dispatchEvent(new Event("change",{bubbles:true}));

    Clear Element Text
    ...    ${champ chambres annonce}

    Input Text
    ...    ${champ chambres annonce}
    ...    2

    Clear Element Text
    ...    ${champ voyageurs annonce}

    Input Text
    ...    ${champ voyageurs annonce}
    ...    4

    Clear Element Text
    ...    ${champ lits annonce}

    Input Text
    ...    ${champ lits annonce}
    ...    2

    Clear Element Text
    ...    ${champ bains annonce}

    Input Text
    ...    ${champ bains annonce}
    ...    1

    Clear Element Text
    ...    ${champ pieces annonce}

    Input Text
    ...    ${champ pieces annonce}
    ...    3

    Clear Element Text
    ...    ${champ superficie annonce}

    Input Text
    ...    ${champ superficie annonce}
    ...    60

    Clear Element Text
    ...    ${champ unite annonce}

    Input Text
    ...    ${champ unite annonce}
    ...    m2


# ==========================================================
# NAVIGATION ENTRE LES ETAPES
# ==========================================================

Continuer vers l'étape suivante
    Wait Until Element Is Visible
    ...    ${bouton continuer}
    ...    15s

    Click Button
    ...    ${bouton continuer}


Retourner à l'étape précédente
    Wait Until Element Is Visible
    ...    ${bouton retour}
    ...    15s

    Click Button
    ...    ${bouton retour}


Le message d'erreur de création doit être affiché
    Wait Until Element Is Visible
    ...    ${bloc erreur annonce}
    ...    10s

    Element Should Contain
    ...    ${bloc erreur annonce}
    ...    ${message erreur annonce}


Le message d'erreur image doit être affiché
    Wait Until Element Is Visible
    ...    ${bloc erreur image}
    ...    10s

    Element Should Contain
    ...    ${bloc erreur image}
    ...    ${message erreur image}


# ==========================================================
# ETAPE 2 - TARIFS
# ==========================================================

L'étape Tarifs doit être affichée
    Wait Until Element Is Visible
    ...    ${champ tarif nuit}
    ...    15s


Renseigner les tarifs de l'annonce
    Wait Until Element Is Visible
    ...    ${champ tarif nuit}
    ...    15s

    Clear Element Text
    ...    ${champ tarif nuit}

    Input Text
    ...    ${champ tarif nuit}
    ...    80

    Clear Element Text
    ...    ${champ libelle tarif}

    Input Text
    ...    ${champ libelle tarif}
    ...    Nuit

    Clear Element Text
    ...    ${champ frais nettoyage}

    Input Text
    ...    ${champ frais nettoyage}
    ...    20

    Execute JavaScript
    ...    const r=document.querySelector("#submit_listing_form input[name='cleaning_fee_type'][value='per_stay']"); if(!r){throw new Error("Unité frais Par séjour introuvable");} r.checked=true; r.dispatchEvent(new Event("change",{bubbles:true}));

    Clear Element Text
    ...    ${champ caution}

    Input Text
    ...    ${champ caution}
    ...    200


# ==========================================================
# ETAPE 3 - MEDIAS
# ==========================================================

L'étape Médias doit être affichée
    Wait Until Element Is Visible
    ...    ${bouton selection image}
    ...    15s


Charger l'image de test de l'annonce
    Wait Until Page Contains Element
    ...    ${champ fichier image}
    ...    15s

    Choose File
    ...    ${champ fichier image}
    ...    ${IMAGE ANNONCE TEST}

    Wait Until Page Contains Element
    ...    ${image chargee cachee}
    ...    30s

    Wait Until Element Is Visible
    ...    ${vignette image chargee}
    ...    30s

    ${id_image}=    Get Value
    ...    ${image chargee cachee}

    Should Not Be Empty
    ...    ${id_image}


# ==========================================================
# ETAPE 4 - CARACTERISTIQUES
# ==========================================================

L'étape Caractéristiques doit être affichée
    Wait Until Element Is Visible
    ...    ${titre caracteristiques}
    ...    15s


Sélectionner quelques caractéristiques
    Execute JavaScript
    ...    const ids=["amenity-air-conditioning","amenity-wi-fi","facility-free-parking"]; for(const id of ids){const e=document.getElementById(id); if(!e){throw new Error("Caractéristique introuvable : "+id);} e.checked=true; e.dispatchEvent(new Event("change",{bubbles:true}));}


# ==========================================================
# ETAPE 5 - LOCALISATION
# ==========================================================

L'étape Localisation doit être affichée
    Wait Until Element Is Visible
    ...    ${champ adresse annonce}
    ...    15s


Renseigner uniquement l'adresse de l'annonce
    Clear Element Text
    ...    ${champ adresse annonce}

    Input Text
    ...    ${champ adresse annonce}
    ...    10 rue de la Paix


Renseigner la localisation complète de l'annonce
    Wait Until Element Is Visible
    ...    ${champ adresse annonce}
    ...    15s

    Clear Element Text
    ...    ${champ adresse annonce}

    Input Text
    ...    ${champ adresse annonce}
    ...    10 rue de la Paix

    Clear Element Text
    ...    ${champ appt annonce}

    Input Text
    ...    ${champ appt annonce}
    ...    12

    Clear Element Text
    ...    ${champ ville annonce}

    Input Text
    ...    ${champ ville annonce}
    ...    Paris

    Clear Element Text
    ...    ${champ departement annonce}

    Input Text
    ...    ${champ departement annonce}
    ...    Paris

    Clear Element Text
    ...    ${champ code postal annonce}

    Input Text
    ...    ${champ code postal annonce}
    ...    75002

    Clear Element Text
    ...    ${champ region annonce}

    Input Text
    ...    ${champ region annonce}
    ...    Île-de-France

    Clear Element Text
    ...    ${champ pays annonce}

    Input Text
    ...    ${champ pays annonce}
    ...    France


# ==========================================================
# ETAPE 6 - REGLEMENT INTERIEUR
# ==========================================================

L'étape Règlement intérieur doit être affichée
    Wait Until Element Is Visible
    ...    ${bouton soumettre}
    ...    15s


Renseigner le règlement intérieur
    Wait Until Keyword Succeeds
    ...    3x
    ...    500ms
    ...    Sélectionner et vérifier le règlement intérieur


Sélectionner et vérifier le règlement intérieur
    Execute JavaScript
    ...    const valeurs={smoke:"0",pets:"1",party:"0",children:"1"}; for(const [nom,valeur] of Object.entries(valeurs)){const selecteur="#submit_listing_form input[name='"+nom+"'][value='"+valeur+"']"; const r=document.querySelector(selecteur); if(!r){throw new Error("Règle introuvable : "+nom);} if(!r.checked){r.click();} r.dispatchEvent(new Event("input",{bubbles:true})); r.dispatchEvent(new Event("change",{bubbles:true}));}

    ${regles_ok}=    Execute JavaScript
    ...    const valeurs={smoke:"0",pets:"1",party:"0",children:"1"}; return Object.entries(valeurs).every(([nom,valeur])=>{const selecteur="#submit_listing_form input[name='"+nom+"'][value='"+valeur+"']"; const r=document.querySelector(selecteur); return r && r.checked;});

    Should Be True
    ...    ${regles_ok}


Soumettre l'annonce
    Wait Until Element Is Visible
    ...    ${bouton soumettre}
    ...    15s

    Scroll Element Into View
    ...    ${bouton soumettre}

    Click Button
    ...    ${bouton soumettre}


Le message de confirmation de l'annonce doit être affiché
    Wait Until Page Contains
    ...    ${message succes annonce}
    ...    20s


# ==========================================================
# BROUILLON
# ==========================================================

Enregistrer l'annonce comme brouillon
    Wait Until Element Is Visible
    ...    ${bouton brouillon}
    ...    10s

    Click Button
    ...    ${bouton brouillon}

    Sleep    2s


Ouvrir Mes annonces
    Wait Until Page Contains Element
    ...    ${lien mes annonces}
    ...    15s

    Execute JavaScript
    ...    const els=[...document.querySelectorAll("a")]; const el=els.find(e=>e.offsetParent!==null && /mes annonces/i.test((e.textContent||"").trim())); if(!el){throw new Error("Lien Mes annonces introuvable");} el.click();

    Wait Until Page Contains
    ...    Mes annonces
    ...    15s


Le brouillon doit être visible
    [Arguments]    ${titre}

    Wait Until Page Contains
    ...    ${titre}
    ...    15s

    Page Should Contain
    ...    Brouillon


# ==========================================================
# PUBLICATION / RECHERCHE
# ==========================================================

L'annonce publiée doit être visible dans Mes annonces
    [Arguments]    ${titre}

    Ouvrir Mes annonces

    Wait Until Page Contains
    ...    ${titre}
    ...    15s

    Page Should Contain
    ...    Publié


L'annonce doit être visible dans la recherche publique
    [Arguments]    ${titre}

    Go To
    ...    ${URL}

    Wait Until Element Is Visible
    ...    ${bouton chercher}
    ...    15s

    Click Element
    ...    ${bouton chercher}

    Wait Until Location Contains
    ...    /search-results/
    ...    20s

    Wait Until Page Contains Element
    ...    css=ul.pagination
    ...    20s

    ${trouve}=    Set Variable    ${False}

    FOR    ${page}    IN RANGE    1    13
        ${trouve}=    Run Keyword And Return Status
        ...    Page Should Contain
        ...    ${titre}

        IF    ${trouve}
            BREAK
        END

        IF    ${page} < 12
            ${page_suivante}=    Evaluate    ${page} + 1

            Execute JavaScript
            ...    const a=document.querySelector("ul.pagination a[rel='Next']"); if(!a){throw new Error("Bouton page suivante introuvable");} a.click();

            Wait Until Page Contains Element
            ...    css=ul.pagination li.active a[data-homeypagi='${page_suivante}']
            ...    20s

            Sleep    1s
        END
    END

    Should Be True
    ...    ${trouve}
    ...    L'annonce '${titre}' n'a été trouvée sur aucune des 12 pages de résultats.