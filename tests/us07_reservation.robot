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
    [Tags]    US07    visiteur

    Accéder à l'annonce Beautiful Cove

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile input[name='arrive']

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile input[name='depart']

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile input[name='guests']

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile #request_for_reservation


US07 - Un visiteur non connecté ne peut pas finaliser une réservation
    [Tags]    US07    visiteur

    Accéder à l'annonce Beautiful Cove

    Page Should Not Contain
    ...    Demande de réservation envoyée

    Page Should Contain Element
    ...    css=a[data-target='#modal-login']


US07 - Le formulaire de réservation doit contenir un message obligatoire
    [Tags]    US07    defect

    Se connecter comme voyageur

    Go To    ${lien annonce attendu}

    Wait Until Page Contains
    ...    Beautiful Cove
    ...    10s

    Element Should Be Visible
    ...    css=#homey_remove_on_mobile textarea[name='guest_message']


US07 - Un voyageur connecté peut envoyer une demande de réservation
    [Tags]    US07    nominal

    Se connecter comme voyageur

    Envoyer une demande sur l'annonce de l'hôte test

    Page Should Contain
    ...    Demande de réservation envoyée


US07 - Une demande envoyée apparaît dans les réservations de l'hôte
    [Tags]    US07    nominal

    Se connecter comme voyageur

    ${date_debut}    ${date_fin}=
    ...    Envoyer une demande sur l'annonce de l'hôte test

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
    [Tags]    US07    defect

    Se connecter comme voyageur

    Envoyer une demande sur l'annonce de l'hôte test

    fermer le navigateur
    ouvrir le navigateur et accéder à l'application

    Se connecter en tant qu'hôte
    ...    ${HOTE_USER}
    ...    ${HOTE_PASSWORD}

    Ouvrir les messages de l'hôte

    Un nouveau message doit être visible côté hôte


*** Keywords ***

Se connecter comme voyageur
    acceder à la page de connexion

    Saisir le nom d'utilisateur et le mot de passe
    ...    ${champ utilisateur valide}
    ...    ${champ mot de passe valide}

    Soumettre le formulaire de connexion

    Wait Until Location Contains
    ...    /dashboard/
    ...    20s