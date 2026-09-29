*** Settings ***
Library     SeleniumLibrary
Resource    ../navigateur.resource
Resource    ../variables.robot
Resource    page_connexion.resource
Resource    page_reservation.resource


*** Keywords ***

Se connecter comme Hôte pour une réservation
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

    Se connecter comme Hôte pour une réservation

    ${details_url}=
    ...    Ouvrir le détail Hôte de la réservation correspondant aux dates
    ...    ${date_debut}
    ...    ${date_fin}

    ${reservation_id}=
    ...    Récupérer l'identifiant de la réservation courante

    RETURN    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}


Ouvrir réservation Voyageur par identifiant
    [Arguments]    ${reservation_id}

    Go To    ${url reservations}?reservation_detail=${reservation_id}

    Wait Until Location Contains
    ...    reservation_detail=${reservation_id}
    ...    20s

    Wait Until Page Contains
    ...    #${reservation_id}
    ...    20s


La réservation Voyageur doit être disponible pour paiement
    Wait Until Page Contains    DISPONIBLE    20s
    Page Should Contain    Payez maintenant
    Page Should Contain    Annuler


Ouvrir le paiement Voyageur
    [Arguments]    ${reservation_id}

    Ouvrir réservation Voyageur par identifiant    ${reservation_id}

    ${payment_url}=    Execute JavaScript
    ...    return (()=>{const a=[...document.querySelectorAll("a[href]")].find(e=>e.offsetParent!==null && /reservation-payment/.test(e.href));return a?a.href:"";})();

    Should Not Be Empty    ${payment_url}

    Go To    ${payment_url}

    Wait Until Location Contains    reservation-payment    20s


Vérifier les frais supplémentaires
    ${bouton_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /frais/i.test((e.innerText||"").trim()));

    Should Be True    ${bouton_visible}

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /frais/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton Frais introuvable");} e.click();

    Sleep    2s

    Element Should Be Visible
    ...    css=input[placeholder='Entrez le nom de la dépense']

    Element Should Be Visible
    ...    css=input[placeholder='Entrez le prix de la dépense']


Vérifier les remises
    ${bouton_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button")].some(e=>e.offsetParent!==null && /remise/i.test((e.innerText||"").trim()));

    Should Be True    ${bouton_visible}

    Execute JavaScript
    ...    const e=[...document.querySelectorAll("a,button")].find(x=>x.offsetParent!==null && /remise/i.test((x.innerText||"").trim())); if(!e){throw new Error("Bouton Remise introuvable");} e.click();

    Sleep    2s

    Element Should Be Visible
    ...    css=input[placeholder='Entrez le nom de la remise']

    Element Should Be Visible
    ...    css=input[placeholder='Entrez la valeur de la remise']