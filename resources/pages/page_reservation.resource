*** Settings ***
Library    SeleniumLibrary


*** Variables ***

# =========================
# RECHERCHE / ANNONCE
# =========================

${bouton chercher}    css=.search-button > .btn-primary\:nth-child(1)
${premiere annonce}    css=.infobox_trigger\:nth-child(1) .hover-effect

${titre annonce attendu}    Beautiful Cove
${lien annonce attendu}    http://livraison3.testacademy.fr/index.php/listing/beautiful-cove/

${titre annonce hote test}    Annonce Auto 20260923181135870389
${lien annonce hote test}    http://livraison3.testacademy.fr/index.php/listing/annonce-auto-20260923181135870389/

${message aucun message hote}    You don't have any message at this moment.

${url reservations}    http://livraison3.testacademy.fr/index.php/reservations/
${url profil paiement hote}    http://livraison3.testacademy.fr/index.php/profile/?dpage=payment-method


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


# =========================
# TRAITEMENT RESERVATION
# =========================

${bouton confirmer disponibilite}    css=.confirm-offsite-reservation
${bouton refuser reservation}    css=#decline-reservation-btn
${champ raison refus}    css=textarea[name='reason']
${bouton soumettre refus}    css=#decline

${champ nom frais}    css=input[placeholder='Entrez le nom de la dépense']
${champ valeur frais}    css=input[placeholder='Entrez le prix de la dépense']
${bouton ajouter frais}    css=#add_more_expense
${bouton enregistrer frais}    css=#save_expenses

${champ nom remise}    css=input[placeholder='Entrez le nom de la remise']
${champ valeur remise}    css=input[placeholder='Entrez la valeur de la remise']
${bouton ajouter remise}    css=#add_more_discount
${bouton enregistrer remise}    css=#save_discounts

${champ paiement prenom}    css=#ben_first_name
${champ paiement nom}    css=#ben_last_name
${champ paiement compagnie}    css=#ben_company_name
${champ paiement fiscal}    css=#ben_tax_number
${champ paiement adresse}    css=#ben_street_address
${champ paiement appt}    css=#ben_apt_suit
${champ paiement ville}    css=#ben_city
${champ paiement etat}    css=#ben_state
${champ paiement code postal}    css=#ben_zip_code

${mode paiement virement}    css=input[name='payout_method'][value='wire']

${champ iban}    css=#bank_account
${champ swift}    css=#swift
${champ banque}    css=#bank_name
${champ banque adresse}    css=#wir_street_address
${champ banque appt}    css=#wir_aptsuit
${champ banque ville}    css=#wir_city
${champ banque etat}    css=#wir_state
${champ banque code postal}    css=#wir_zip_code

${option paiement reservation}    css=#host_payment_option


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

    Click Element
    ...    ${bouton chercher}

    Execute JavaScript
    ...    window.scrollTo(0,0)

    Wait Until Element Is Visible
    ...    ${premiere annonce}
    ...    10s

    Click Element
    ...    ${premiere annonce}

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


# =========================
# US07 - CONTROLE COTE HOTE
# =========================

Envoyer une demande sur l'annonce de l'hôte test
    Go To    ${lien annonce hote test}

    Wait Until Page Contains
    ...    ${titre annonce hote test}
    ...    15s

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile input[name='arrive']"); if(!e){throw new Error("Champ date de début introuvable");} e.click();

    Wait Until Page Contains Element
    ...    css=#homey_remove_on_mobile li.day-available.future-day
    ...    10s

    ${dates}=    Execute JavaScript
    ...    return (()=>{const e=[...document.querySelectorAll("#homey_remove_on_mobile li.day-available.future-day")];const s=new Set(e.map(x=>x.dataset.formattedDate));for(const x of e){const d=new Date(x.dataset.formattedDate+"T12:00:00");const n1=new Date(d);n1.setDate(d.getDate()+1);const n2=new Date(d);n2.setDate(d.getDate()+2);const f1=n1.toISOString().slice(0,10);const f2=n2.toISOString().slice(0,10);if(s.has(f1)&&s.has(f2)){return [x.dataset.formattedDate,f2];}}return []})();

    Length Should Be    ${dates}    2

    ${date_debut}=    Set Variable    ${dates}[0]
    ${date_fin}=    Set Variable    ${dates}[1]

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile li[data-formatted-date='${date_debut}']"); if(!e){throw new Error("Date de début introuvable");} e.click();

    Sleep    0.5s

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile li[data-formatted-date='${date_fin}']"); if(!e){throw new Error("Date de fin introuvable");} e.click();

    Sleep    0.5s

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile input[name='guests']"); if(!e){throw new Error("Champ voyageurs introuvable");} e.click();

    Wait Until Page Contains Element
    ...    css=#homey_remove_on_mobile button.adult_plus
    ...    10s

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile button.adult_plus"); if(!e){throw new Error("Bouton ajout voyageur introuvable");} e.click();

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile button.apply_guests"); if(!e){throw new Error("Bouton appliquer introuvable");} e.click();

    Sleep    0.5s

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile #request_for_reservation"); if(!e){throw new Error("Bouton réservation introuvable");} e.click();

    Wait Until Page Contains
    ...    Demande de réservation envoyée
    ...    20s

    RETURN    ${date_debut}    ${date_fin}


Ouvrir les réservations de l'hôte
    Execute JavaScript
    ...    const els=[...document.querySelectorAll("a")]; const e=els.find(x=>x.offsetParent!==null && /réservations/i.test((x.textContent||"").trim())); if(!e){throw new Error("Lien Réservations introuvable");} e.click();

    Wait Until Page Contains
    ...    ${titre annonce hote test}
    ...    20s


La réservation doit être visible côté hôte
    [Arguments]    ${date_debut}    ${date_fin}

    Page Should Contain    ${titre annonce hote test}
    Page Should Contain    ${date_debut}
    Page Should Contain    ${date_fin}
    Page Should Contain    NOUVEAU


Ouvrir les messages de l'hôte
    Execute JavaScript
    ...    const els=[...document.querySelectorAll("a")]; const e=els.find(x=>x.offsetParent!==null && /messages/i.test((x.textContent||"").trim())); if(!e){throw new Error("Lien Messages introuvable");} e.click();

    Wait Until Location Contains
    ...    /messages/
    ...    20s


Un nouveau message doit être visible côté hôte
    Page Should Not Contain
    ...    ${message aucun message hote}


# =========================
# TRAITER UNE RESERVATION
# =========================

Ouvrir le détail Hôte de la réservation correspondant aux dates
    [Arguments]    ${date_debut}    ${date_fin}

    Ouvrir les réservations de l'hôte

    ${details_url}=    Execute JavaScript
    ...    return (()=>{const rows=[...document.querySelectorAll("tr")].filter(r=>{const t=(r.innerText||"").replace(/\s+/g," ");return t.includes("${titre annonce hote test}")&&t.includes("${date_debut}")&&t.includes("${date_fin}");});const liens=rows.flatMap(r=>[...r.querySelectorAll("a[href*='reservation_detail=']")]);liens.sort((a,b)=>{const ia=parseInt(new URL(a.href).searchParams.get("reservation_detail")||"0");const ib=parseInt(new URL(b.href).searchParams.get("reservation_detail")||"0");return ib-ia;});return liens.length?liens[0].href:"";})();

    Should Not Be Empty
    ...    ${details_url}
    ...    Impossible de trouver la réservation correspondant aux dates ${date_debut} - ${date_fin}

    Go To
    ...    ${details_url}

    Wait Until Location Contains
    ...    reservation_detail
    ...    15s

    RETURN    ${details_url}


Récupérer l'identifiant de la réservation courante
    ${reservation_id}=    Execute JavaScript
    ...    return new URL(window.location.href).searchParams.get("reservation_detail") || "";

    Should Not Be Empty
    ...    ${reservation_id}
    ...    Aucun identifiant de réservation n'est présent dans l'URL

    RETURN    ${reservation_id}


Confirmer la disponibilité de la réservation
    ${visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll(".confirm-offsite-reservation")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${visible}
    ...    Le bouton Confirmer la disponibilité n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll(".confirm-offsite-reservation")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Bouton Confirmer la disponibilité visible introuvable");} e.scrollIntoView({block:"center"}); e.click();

    Wait Until Page Contains
    ...    Vous avez confirmé la disponibilité pour cette réservation.
    ...    20s


Refuser la réservation
    [Arguments]    ${motif}

    ${visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("#decline-reservation-btn")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${visible}
    ...    Le bouton Refuser n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("#decline-reservation-btn")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Bouton Refuser visible introuvable");} e.scrollIntoView({block:"center"}); e.click();

    Wait Until Element Is Visible
    ...    ${champ raison refus}
    ...    10s

    Clear Element Text
    ...    ${champ raison refus}

    Input Text
    ...    ${champ raison refus}
    ...    ${motif}

    ${valeur}=    Get Value
    ...    ${champ raison refus}

    Should Be Equal
    ...    ${valeur}
    ...    ${motif}

    ${soumettre_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("#decline")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${soumettre_visible}
    ...    Le bouton Soumettre du refus n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("#decline")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Bouton Soumettre du refus introuvable");} e.click();

    Sleep    4s


Ouvrir la réservation côté Voyageur
    [Arguments]    ${reservation_id}

    Go To
    ...    ${url reservations}?reservation_detail=${reservation_id}

    Wait Until Location Contains
    ...    reservation_detail=${reservation_id}
    ...    15s

    Wait Until Page Contains
    ...    Réservation #${reservation_id}
    ...    15s


La réservation Voyageur doit être disponible
    [Arguments]    ${reservation_id}

    Wait Until Page Contains
    ...    Réservation #${reservation_id} DISPONIBLE
    ...    15s

    Page Should Contain
    ...    Payez maintenant

    Page Should Contain
    ...    Annuler

    ${paiement_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a[href]")].some(e=>e.offsetParent!==null && /reservation-payment/.test(e.href));

    Should Be True
    ...    ${paiement_visible}
    ...    L'action Payez maintenant n'est pas disponible

    ${annuler_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("#cancel-reservation-btn")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${annuler_visible}
    ...    L'action Annuler n'est pas disponible


La réservation doit être refusée
    [Arguments]    ${reservation_id}

    Reload Page

    Wait Until Page Contains
    ...    Réservation #${reservation_id}
    ...    15s

    Page Should Contain
    ...    REFUSE


Ouvrir le formulaire des frais supplémentaires
    ${visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /frais/i.test((e.innerText||"").trim()));

    Should Be True
    ...    ${visible}
    ...    Le bouton Ajouter des frais supplémentaires n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /frais/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton frais supplémentaires introuvable");} e.click();

    Wait Until Page Contains
    ...    Frais supplémentaires
    ...    10s

    Element Should Be Visible
    ...    ${champ nom frais}

    Element Should Be Visible
    ...    ${champ valeur frais}

    Element Should Be Visible
    ...    ${bouton ajouter frais}

    Element Should Be Visible
    ...    ${bouton enregistrer frais}


Ouvrir le formulaire de remise
    ${visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /remise/i.test((e.innerText||"").trim()));

    Should Be True
    ...    ${visible}
    ...    Le bouton Faire une remise n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /remise/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton Faire une remise introuvable");} e.click();

    Wait Until Page Contains
    ...    Faire une remise
    ...    10s

    Element Should Be Visible
    ...    ${champ nom remise}

    Element Should Be Visible
    ...    ${champ valeur remise}

    Element Should Be Visible
    ...    ${bouton ajouter remise}

    Element Should Be Visible
    ...    ${bouton enregistrer remise}


Ouvrir la page de paiement de la réservation
    [Arguments]    ${reservation_id}

    Ouvrir la réservation côté Voyageur
    ...    ${reservation_id}

    ${payment_url}=    Execute JavaScript
    ...    return (()=>{const a=[...document.querySelectorAll("a[href]")].find(e=>e.offsetParent!==null && /reservation-payment/.test(e.href));return a?a.href:"";})();

    Should Not Be Empty
    ...    ${payment_url}
    ...    Le lien Payez maintenant est introuvable

    Go To
    ...    ${payment_url}

    Wait Until Location Contains
    ...    reservation-payment
    ...    15s


La page de paiement hors site doit être affichée
    Wait Until Page Contains
    ...    Paiement de la réservation
    ...    15s

    Page Should Contain
    ...    Veuillez effectuer le paiement hors-site

    Page Should Contain
    ...    information de paiement

    Page Should Contain
    ...    Méthode

    Page Should Contain
    ...    Nom du bénéficiaire

    Page Should Contain
    ...    Adresse


Ouvrir le profil de paiement Hôte
    Go To
    ...    ${url profil paiement hote}

    Wait Until Location Contains
    ...    payment-method
    ...    15s

    Wait Until Page Contains
    ...    information du bénéficiaire
    ...    15s


Le formulaire de paiement Hôte doit être complet
    Element Should Be Visible    ${champ paiement prenom}
    Element Should Be Visible    ${champ paiement nom}
    Element Should Be Visible    ${champ paiement compagnie}
    Element Should Be Visible    ${champ paiement fiscal}
    Element Should Be Visible    ${champ paiement adresse}
    Element Should Be Visible    ${champ paiement appt}
    Element Should Be Visible    ${champ paiement ville}
    Element Should Be Visible    ${champ paiement etat}
    Element Should Be Visible    ${champ paiement code postal}

    Page Should Contain
    ...    Virement bancaire

    Page Should Contain
    ...    Paiement lors de la réservation

    Page Should Contain
    ...    Règlement de la totalité

    Page Should Contain
    ...    Pourcentage(%)

    Page Should Contain
    ...    Dépôt de garantie

    Page Should Contain
    ...    Pas d'avance


Sélectionner le virement bancaire
    Execute JavaScript
    ...    const e=document.querySelector("input[name='payout_method'][value='wire']"); if(!e){throw new Error("Mode Virement bancaire introuvable");} e.click(); e.dispatchEvent(new Event("change",{bubbles:true}));

    Wait Until Page Contains
    ...    Informations de virement bancaire
    ...    10s

    Element Should Be Visible    ${champ iban}
    Element Should Be Visible    ${champ swift}
    Element Should Be Visible    ${champ banque}
    Element Should Be Visible    ${champ banque adresse}
    Element Should Be Visible    ${champ banque appt}
    Element Should Be Visible    ${champ banque ville}
    Element Should Be Visible    ${champ banque etat}
    Element Should Be Visible    ${champ banque code postal}