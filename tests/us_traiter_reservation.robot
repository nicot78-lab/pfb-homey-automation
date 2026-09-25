*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup    ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Variables ***
${HOTE_USER}    %{HOMEY_HOTE_USER}
${HOTE_PASSWORD}    %{HOMEY_HOTE_PASSWORD}

${MOTIF_REFUS}    Indisponible pour ces dates
${URL_RESERVATIONS}    http://livraison3.testacademy.fr/index.php/reservations/


*** Test Cases ***

TR-01 - Une nouvelle demande affiche les informations attendues côté Hôte
    [Tags]    traitement-reservation    hote    nouveau

    Se connecter avec un compte valide

    ${date_debut}    ${date_fin}=    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    Page Should Contain    NOUVEAU
    Page Should Contain    ${date_debut}
    Page Should Contain    ${date_fin}
    Page Should Contain    Voyageur
    Page Should Contain    Total


TR-02 - La confirmation Hôte rend la réservation DISPONIBLE au Voyageur
    [Tags]    traitement-reservation    confirmation    nominal

    Se connecter avec un compte valide

    ${date_debut}    ${date_fin}=    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    ${reservation_id}=    Récupérer l'identifiant de la réservation courante

    Confirmer la disponibilité de la réservation

    Sleep    3s

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter avec un compte valide

    Ouvrir réservation Voyageur par identifiant
    ...    ${reservation_id}

    Wait Until Page Contains
    ...    DISPONIBLE
    ...    20s

    Page Should Contain
    ...    Payez maintenant

    Page Should Contain
    ...    Annuler


TR-03 - Après confirmation le statut Hôte doit être ATTENTE DE PAIEMENT
    [Tags]    traitement-reservation    confirmation    defect    statut-hote

    Se connecter avec un compte valide

    ${date_debut}    ${date_fin}=    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    ${reservation_id}=    Récupérer l'identifiant de la réservation courante

    Confirmer la disponibilité de la réservation

    Sleep    3s

    Reload Page

    Wait Until Page Contains
    ...    Réservation #${reservation_id}
    ...    20s

    Page Should Contain
    ...    ATTENTE DE PAIEMENT


TR-04 - Le refus Hôte rend la réservation REFUSE des deux côtés
    [Tags]    traitement-reservation    refus    defect    statut-refus

    Se connecter avec un compte valide

    ${date_debut}    ${date_fin}=    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    ${reservation_id}=    Récupérer l'identifiant de la réservation courante

    Refuser réservation visible
    ...    ${MOTIF_REFUS}

    Sleep    4s

    Reload Page

    Wait Until Page Contains
    ...    REFUSE
    ...    20s

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter avec un compte valide

    Ouvrir réservation Voyageur par identifiant
    ...    ${reservation_id}

    Wait Until Page Contains
    ...    REFUSE
    ...    20s


TR-05 - L'Hôte peut accéder aux frais supplémentaires et aux remises
    [Tags]    traitement-reservation    frais    remise

    Se connecter avec un compte valide

    ${date_debut}    ${date_fin}=    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    ${details_url}=    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    Vérifier formulaire frais supplémentaires

    Go To
    ...    ${details_url}

    Wait Until Location Contains
    ...    reservation_detail
    ...    15s

    Sleep    2s

    Vérifier formulaire remise


TR-06 - Le profil Paiement Hôte propose le virement bancaire
    [Tags]    traitement-reservation    paiement    hote

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir le profil de paiement Hôte

    Le formulaire de paiement Hôte doit être complet

    Sélectionner le virement bancaire

    Page Should Contain
    ...    Code IBAN

    Page Should Contain
    ...    Code SWIFT

    Page Should Contain
    ...    Nom de banque


TR-07 - Le Voyageur accède à la page de paiement hors site après confirmation
    [Tags]    traitement-reservation    paiement    voyageur

    Se connecter avec un compte valide

    ${date_debut}    ${date_fin}=    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    ${reservation_id}=    Récupérer l'identifiant de la réservation courante

    Confirmer la disponibilité de la réservation

    Sleep    3s

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter avec un compte valide

    Ouvrir réservation Voyageur par identifiant
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
    ...    20s

    Wait Until Page Contains
    ...    Paiement de la réservation
    ...    20s

    Page Should Contain
    ...    paiement hors-site

    Page Should Contain
    ...    information de paiement


*** Keywords ***

Ouvrir réservation Voyageur par identifiant
    [Arguments]    ${reservation_id}

    Go To
    ...    ${URL_RESERVATIONS}

    Wait Until Page Contains
    ...    #${reservation_id}
    ...    20s

    ${details_url}=    Execute JavaScript
    ...    return (()=>{const a=[...document.querySelectorAll("a[href]")].find(e=>e.href.includes("reservation_detail=${reservation_id}"));return a?a.href:"";})();

    Should Not Be Empty
    ...    ${details_url}
    ...    Impossible de trouver la réservation #${reservation_id} côté Voyageur

    Go To
    ...    ${details_url}

    Wait Until Location Contains
    ...    reservation_detail=${reservation_id}
    ...    20s

    Wait Until Page Contains
    ...    #${reservation_id}
    ...    20s


Refuser réservation visible
    [Arguments]    ${motif}

    ${bouton_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("#decline-reservation-btn")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${bouton_visible}
    ...    Le bouton Refuser n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("#decline-reservation-btn")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Bouton Refuser introuvable");} e.click();

    Wait Until Keyword Succeeds
    ...    5x
    ...    1s
    ...    Le champ de refus visible doit exister

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("textarea[name='reason']")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Champ motif visible introuvable");} e.value="${motif}"; e.dispatchEvent(new Event("input",{bubbles:true})); e.dispatchEvent(new Event("change",{bubbles:true}));

    ${soumettre_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("#decline")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${soumettre_visible}
    ...    Le bouton Soumettre du refus n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("#decline")].find(x=>x.offsetParent!==null); if(!e){throw new Error("Bouton Soumettre introuvable");} e.click();


Le champ de refus visible doit exister
    ${visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("textarea[name='reason']")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${visible}
    ...    Le formulaire de refus n'est pas encore visible


Vérifier formulaire frais supplémentaires
    ${bouton_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /frais/i.test((e.innerText||"").trim()));

    Should Be True
    ...    ${bouton_visible}
    ...    Le bouton Frais supplémentaires n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /frais/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton Frais introuvable");} e.click();

    Sleep    2s

    ${nom_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("input[placeholder='Entrez le nom de la dépense']")].some(e=>e.offsetParent!==null);

    ${valeur_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("input[placeholder='Entrez le prix de la dépense']")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${nom_visible}
    ...    Le champ Nom de la dépense n'est pas visible

    Should Be True
    ...    ${valeur_visible}
    ...    Le champ Valeur des frais n'est pas visible

    Page Should Contain
    ...    Frais supplémentaires

    Page Should Contain
    ...    Ajouter plus

    Page Should Contain
    ...    Enregistrer les frais


Vérifier formulaire remise
    ${bouton_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /remise/i.test((e.innerText||"").trim()));

    Should Be True
    ...    ${bouton_visible}
    ...    Le bouton Faire une remise n'est pas visible

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /remise/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton Remise introuvable");} e.click();

    Sleep    2s

    ${nom_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("input[placeholder='Entrez le nom de la remise']")].some(e=>e.offsetParent!==null);

    ${valeur_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("input[placeholder='Entrez la valeur de la remise']")].some(e=>e.offsetParent!==null);

    Should Be True
    ...    ${nom_visible}
    ...    Le champ Nom de la remise n'est pas visible

    Should Be True
    ...    ${valeur_visible}
    ...    Le champ Valeur de la remise n'est pas visible

    Page Should Contain
    ...    Faire une remise

    Page Should Contain
    ...    Enregistrer les réductions