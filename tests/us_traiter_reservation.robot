*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


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

    Ouvrir réservation Voyageur par identifiant    ${reservation_id}
    La réservation Voyageur doit être disponible pour paiement


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

    Refuser la réservation    ${MOTIF_REFUS}
    La réservation doit être refusée    ${reservation_id}

    Se reconnecter comme Voyageur
    Ouvrir réservation Voyageur par identifiant    ${reservation_id}
    La réservation doit être refusée    ${reservation_id}


TR-05 - L'Hôte peut accéder aux frais supplémentaires et aux remises
    [Tags]    traitement-reservation    frais    remise

    ${date_debut}    ${date_fin}    ${reservation_id}    ${details_url}=
    ...    Créer une demande et ouvrir son détail côté Hôte

    Vérifier les frais supplémentaires

    Go To    ${details_url}
    Wait Until Location Contains    reservation_detail    15s
    Sleep    2s

    Vérifier les remises


TR-06 - Le profil Paiement Hôte propose le virement bancaire
    [Tags]    traitement-reservation    paiement

    Se connecter comme Hôte pour une réservation
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

    Ouvrir le paiement Voyageur    ${reservation_id}
    La page de paiement hors site doit être affichée