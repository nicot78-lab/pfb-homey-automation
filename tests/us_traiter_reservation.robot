*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Variables ***
${HOTE_USER}        %{HOMEY_HOTE_USER}
${HOTE_PASSWORD}    %{HOMEY_HOTE_PASSWORD}

${MOTIF_REFUS}          Indisponible pour ces dates
${URL_RESERVATIONS}     http://livraison3.testacademy.fr/index.php/reservations/


*** Test Cases ***

TR-01 - Une nouvelle demande affiche les informations attendues côté Hôte
    [Tags]    traitement-reservation    hote

    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}=
    ...    Créer une demande et ouvrir son détail côté Hôte

    Page Should Contain    NOUVEAU
    Page Should Contain    ${date_debut}
    Page Should Contain    ${date_fin}
    Page Should Contain    Voyageur
    Page Should Contain    Total


TR-02 - La confirmation Hôte rend la réservation DISPONIBLE au Voyageur
    [Tags]    traitement-reservation    confirmation

    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}=
    ...    Créer une demande et ouvrir son détail côté Hôte

    Confirmer la disponibilité de la réservation

    Sleep    3s

    Se reconnecter comme Voyageur

    Ouvrir réservation Voyageur par identifiant
    ...    ${reservation_id}

    Wait Until Page Contains
    ...    DISPONIBLE
    ...    20s

    Page Should Contain    Payez maintenant
    Page Should Contain    Annuler


TR-03 - Après confirmation le statut Hôte doit être ATTENTE DE PAIEMENT
    [Tags]    traitement-reservation    defect

    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}=
    ...    Créer une demande et ouvrir son détail côté Hôte

    Confirmer la disponibilité de la réservation

    Sleep    3s
    Reload Page

    Page Should Contain    ATTENTE DE PAIEMENT


TR-04 - Le refus Hôte rend la réservation REFUSE des deux côtés
    [Tags]    traitement-reservation    defect

    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}=
    ...    Créer une demande et ouvrir son détail côté Hôte

    Refuser la réservation
    ...    ${MOTIF_REFUS}

    Sleep    3s
    Reload Page

    Page Should Contain    REFUSE

    Se reconnecter comme Voyageur

    Ouvrir réservation Voyageur par identifiant
    ...    ${reservation_id}

    Page Should Contain    REFUSE


TR-05 - L'Hôte peut accéder aux frais supplémentaires et aux remises
    [Tags]    traitement-reservation    frais    remise

    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}=
    ...    Créer une demande et ouvrir son détail côté Hôte

    Vérifier les frais supplémentaires

    Go To    ${details_url}

    Wait Until Location Contains
    ...    reservation_detail
    ...    15s

    Sleep    2s

    Vérifier les remises


TR-06 - Le profil Paiement Hôte propose le virement bancaire
    [Tags]    traitement-reservation    paiement

    Se connecter comme Hôte

    Ouvrir le profil de paiement Hôte

    Le formulaire de paiement Hôte doit être complet

    Sélectionner le virement bancaire

    Page Should Contain    Code IBAN
    Page Should Contain    Code SWIFT
    Page Should Contain    Nom de banque


TR-07 - Le Voyageur accède à la page de paiement hors site après confirmation
    [Tags]    traitement-reservation    paiement

    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}=
    ...    Créer une demande et ouvrir son détail côté Hôte

    Confirmer la disponibilité de la réservation

    Sleep    3s

    Se reconnecter comme Voyageur

    Ouvrir réservation Voyageur par identifiant
    ...    ${reservation_id}

    Ouvrir la page de paiement

    Page Should Contain    Paiement de la réservation
    Page Should Contain    paiement hors-site
    Page Should Contain    information de paiement


*** Keywords ***

Se connecter comme Hôte
    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}


Se reconnecter comme Voyageur
    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter avec un compte valide


Créer une demande et ouvrir son détail côté Hôte
    Se connecter avec un compte valide

    ${date_debut}    ${date_fin}=
    ...    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter comme Hôte

    ${details_url}=
    ...    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    ${reservation_id}=
    ...    Récupérer l'identifiant de la réservation courante

    RETURN
    ...    ${date_debut}
    ...    ${date_fin}
    ...    ${reservation_id}
    ...    ${details_url}


Ouvrir réservation Voyageur par identifiant
    [Arguments]    ${reservation_id}

    Go To
    ...    ${URL_RESERVATIONS}?reservation_detail=${reservation_id}

    Wait Until Location Contains
    ...    reservation_detail=${reservation_id}
    ...    20s

    Wait Until Page Contains
    ...    #${reservation_id}
    ...    20s


Refuser la réservation
    [Arguments]    ${motif}

    Wait Until Element Is Visible
    ...    id=decline-reservation-btn
    ...    10s

    Click Element
    ...    id=decline-reservation-btn

    Wait Until Element Is Visible
    ...    css=textarea[name='reason']
    ...    10s

    Input Text
    ...    css=textarea[name='reason']
    ...    ${motif}

    Click Element
    ...    id=decline


Vérifier les frais supplémentaires
    ${bouton_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /frais/i.test((e.innerText||"").trim()));

    Should Be True
    ...    ${bouton_visible}

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /frais/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton Frais introuvable");} e.click();

    Sleep    2s

    Element Should Be Visible
    ...    css=input[placeholder='Entrez le nom de la dépense']

    Element Should Be Visible
    ...    css=input[placeholder='Entrez le prix de la dépense']

    Page Should Contain    Frais supplémentaires
    Page Should Contain    Ajouter plus
    Page Should Contain    Enregistrer les frais


Vérifier les remises
    ${bouton_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /remise/i.test((e.innerText||"").trim()));

    Should Be True
    ...    ${bouton_visible}

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /remise/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton Remise introuvable");} e.click();

    Sleep    2s

    Element Should Be Visible
    ...    css=input[placeholder='Entrez le nom de la remise']

    Element Should Be Visible
    ...    css=input[placeholder='Entrez la valeur de la remise']

    Page Should Contain    Faire une remise
    Page Should Contain    Enregistrer les réductions


Ouvrir la page de paiement
    ${payment_url}=    Execute JavaScript
    ...    return (()=>{const a=[...document.querySelectorAll("a[href]")].find(e=>e.offsetParent!==null && /reservation-payment/.test(e.href));return a?a.href:"";})();

    Should Not Be Empty
    ...    ${payment_url}
    ...    Le lien Payez maintenant est introuvable

    Go To    ${payment_url}

    Wait Until Location Contains
    ...    reservation-payment
    ...    20s

    Wait Until Page Contains
    ...    Paiement de la réservation
    ...    20s