*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Variables ***
${HOTE_USER}        %{HOMEY_HOTE_USER}
${HOTE_PASSWORD}    %{HOMEY_HOTE_PASSWORD}


*** Test Cases ***

US07 - Un visiteur non connecté peut accéder au formulaire de réservation
    [Tags]    US07    visiteur    formulaire

    Accéder à l'annonce Beautiful Cove

    Wait Until Element Is Visible
    ...    css=#homey_remove_on_mobile input[name='arrive']
    ...    10s

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile input[name='arrive']

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile input[name='depart']

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile input[name='guests']

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile #request_for_reservation


US07 - Un visiteur non connecté ne peut pas finaliser une réservation
    [Tags]    US07    visiteur    securite

    Accéder à l'annonce Beautiful Cove

    ${user_id}=    Execute JavaScript
    ...    return HOMEY_ajax_vars.user_id;

    Should Be Equal As Strings    ${user_id}    0

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile input[name='arrive']"); if(!e){throw new Error("Champ date de début introuvable");} e.click();

    Wait Until Page Contains Element
    ...    css=#homey_remove_on_mobile li.day-available.future-day
    ...    10s

    ${dates}=    Execute JavaScript
    ...    return (()=>{const e=[...document.querySelectorAll("#homey_remove_on_mobile li.day-available.future-day")];const s=new Set(e.map(x=>x.dataset.formattedDate));for(const x of e){const d=new Date(x.dataset.formattedDate+"T12:00:00");let ok=true;for(let i=1;i<=5;i++){const n=new Date(d);n.setDate(d.getDate()+i);const f=n.toISOString().slice(0,10);if(!s.has(f)){ok=false;break;}}if(ok){const n=new Date(d);n.setDate(d.getDate()+5);return [x.dataset.formattedDate,n.toISOString().slice(0,10)];}}return []})();

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

    Sleep    3s

    Page Should Not Contain
    ...    Demande de réservation envoyée

    ${user_id_apres}=    Execute JavaScript
    ...    return HOMEY_ajax_vars.user_id;

    Should Be Equal As Strings    ${user_id_apres}    0

    Page Should Contain Element
    ...    css=a[data-target='#modal-login']


US07 - Le formulaire de réservation doit contenir un message obligatoire
    [Tags]    US07    defect    message-obligatoire

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${champ mot de passe valide}

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s

    Go To    ${lien annonce attendu}

    Wait Until Page Contains
    ...    Beautiful Cove
    ...    10s

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile textarea[name='guest_message']


US07 - Un voyageur connecté peut envoyer une demande de réservation
    [Tags]    US07    nominal    voyageur

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${champ mot de passe valide}

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s

    Go To    ${lien annonce attendu}

    Wait Until Page Contains
    ...    Beautiful Cove
    ...    10s

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile input[name='arrive']"); if(!e){throw new Error("Champ date de début introuvable");} e.click();

    Wait Until Page Contains Element
    ...    css=#homey_remove_on_mobile li.day-available.future-day
    ...    10s

    ${dates}=    Execute JavaScript
    ...    return (()=>{const e=[...document.querySelectorAll("#homey_remove_on_mobile li.day-available.future-day")];const s=new Set(e.map(x=>x.dataset.formattedDate));for(const x of e){const d=new Date(x.dataset.formattedDate+"T12:00:00");let ok=true;for(let i=1;i<=5;i++){const n=new Date(d);n.setDate(d.getDate()+i);const f=n.toISOString().slice(0,10);if(!s.has(f)){ok=false;break;}}if(ok){const n=new Date(d);n.setDate(d.getDate()+5);return [x.dataset.formattedDate,n.toISOString().slice(0,10)];}}return []})();

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

    Wait Until Page Contains Element
    ...    css=#homey_remove_on_mobile #request_for_reservation
    ...    10s

    Execute JavaScript
    ...    const e=document.querySelector("#homey_remove_on_mobile #request_for_reservation"); if(!e){throw new Error("Bouton réservation introuvable");} e.click();

    Wait Until Page Contains
    ...    Demande de réservation envoyée
    ...    20s


US07 - Une demande envoyée apparaît dans les réservations de l'hôte
    [Tags]    US07    nominal    hote

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${champ mot de passe valide}

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s

    ${date_debut}    ${date_fin}=    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir les réservations de l'hôte

    La réservation doit être visible côté hôte
    ...    ${date_debut}
    ...    ${date_fin}


US07 - Une demande de réservation doit créer un message côté hôte
    [Tags]    US07    defect    message-hote

    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${champ mot de passe valide}

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s

    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir les messages de l'hôte

    Un nouveau message doit être visible côté hôte