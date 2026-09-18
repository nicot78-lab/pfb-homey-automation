*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup    ouvrir le navigateur et accéder à l'application
Test Teardown    Close All Browsers


*** Test Cases ***

US08 - Le voyageur connecté accède à son tableau de bord de réservations
    [Tags]    US08    voyageur    reservations

    Se connecter avec un compte valide

    Wait Until Page Contains    Tableau de bord    10s

    Page Should Contain    Mes réservations


US08 - Une demande de réservation est visible côté voyageur
    [Tags]    US08    voyageur    affichage

    Se connecter avec un compte valide

    Wait Until Page Contains    Tableau de bord    10s

    ${reservations_url}=    Execute JavaScript
    ...    return (()=>{const links=[...document.querySelectorAll('a[href]')];const a=links.find(x=>/reservation/i.test(x.href));return a ? a.href : '';})();

    Should Not Be Empty
    ...    ${reservations_url}
    ...    Impossible de trouver une URL de réservation dans le tableau de bord

    Go To    ${reservations_url}

    Wait Until Page Contains    Beautiful Cove    15s

    Page Should Contain    Beautiful Cove
    Page Should Contain    Arrivée
    Page Should Contain    Départ
    Page Should Contain    Voyageurs
    Page Should Contain    Animaux domestiques
    Page Should Contain    Total


US08 - Le voyageur peut accéder au détail de sa réservation
    [Tags]    US08    voyageur    details

    Se connecter avec un compte valide

    Wait Until Page Contains    Tableau de bord    10s

    ${reservations_url}=    Execute JavaScript
    ...    return (()=>{const links=[...document.querySelectorAll('a[href]')];const a=links.find(x=>/reservation/i.test(x.href));return a ? a.href : '';})();

    Should Not Be Empty
    ...    ${reservations_url}
    ...    Impossible de trouver une URL de réservation

    Go To    ${reservations_url}

    Wait Until Page Contains    Beautiful Cove    15s

    ${details_url}=    Execute JavaScript
    ...    return (()=>{const links=[...document.querySelectorAll('a[href]')];const a=links.find(x=>/détail|detail/i.test(x.textContent) || /reservation_detail|reservation-detail/i.test(x.href));return a ? a.href : '';})();

    Should Not Be Empty
    ...    ${details_url}
    ...    Impossible de trouver le lien vers le détail de la réservation

    Go To    ${details_url}

    Wait Until Page Contains    Beautiful Cove    10s

    Page Should Contain    Beautiful Cove

    ${url_actuelle}=    Get Location

    Should Contain
    ...    ${url_actuelle}
    ...    reservation_detail


US08 - Une nouvelle demande doit avoir le statut NOUVEAU
    [Tags]    US08    defect    statut-initial

    Se connecter avec un compte valide

    Wait Until Page Contains    Tableau de bord    10s

    ${reservations_url}=    Execute JavaScript
    ...    return (()=>{const links=[...document.querySelectorAll('a[href]')];const a=links.find(x=>/reservation/i.test(x.href));return a ? a.href : '';})();

    Should Not Be Empty    ${reservations_url}

    Go To    ${reservations_url}

    Wait Until Page Contains    Beautiful Cove    15s

    ${details_url}=    Execute JavaScript
    ...    return (()=>{const links=[...document.querySelectorAll('a[href]')];const a=links.find(x=>/détail|detail/i.test(x.textContent) || /reservation_detail|reservation-detail/i.test(x.href));return a ? a.href : '';})();

    Should Not Be Empty    ${details_url}

    Go To    ${details_url}

    Wait Until Page Contains    Beautiful Cove    10s

    Page Should Contain    NOUVEAU


US08 - Une réservation initiale doit proposer l'action Annuler au voyageur
    [Tags]    US08    defect    annulation

    Se connecter avec un compte valide

    Wait Until Page Contains    Tableau de bord    10s

    ${reservations_url}=    Execute JavaScript
    ...    return (()=>{const links=[...document.querySelectorAll('a[href]')];const a=links.find(x=>/reservation/i.test(x.href));return a ? a.href : '';})();

    Should Not Be Empty    ${reservations_url}

    Go To    ${reservations_url}

    Wait Until Page Contains    Beautiful Cove    15s

    ${details_url}=    Execute JavaScript
    ...    return (()=>{const links=[...document.querySelectorAll('a[href]')];const a=links.find(x=>/détail|detail/i.test(x.textContent) || /reservation_detail|reservation-detail/i.test(x.href));return a ? a.href : '';})();

    Should Not Be Empty    ${details_url}

    Go To    ${details_url}

    Wait Until Page Contains    Beautiful Cove    10s

    ${annuler_visible}=    Execute JavaScript
    ...    return [...document.querySelectorAll("a,button,input[type='submit'],input[type='button']")].some(e=>{const texte=(e.innerText||e.value||e.title||e.getAttribute('aria-label')||'').replace(/\s+/g,' ').trim().toLowerCase();return texte.includes('annuler') && e.getClientRects().length>0 && getComputedStyle(e).visibility!=='hidden';});

    Should Be True
    ...    ${annuler_visible}
    ...    L'action Annuler attendue par l'US-08 n'est pas visible pour le Voyageur