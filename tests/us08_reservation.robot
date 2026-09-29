*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    Close All Browsers


*** Test Cases ***

US08 - Le voyageur connecté accède à son tableau de bord de réservations
    [Tags]    US08    voyageur

    Se connecter avec un compte valide

    Page Should Contain    Tableau de bord
    Page Should Contain    Mes réservations


US08 - Une demande de réservation est visible côté voyageur
    [Tags]    US08    voyageur

    Se connecter avec un compte valide
    Ouvrir mes réservations

    Page Should Contain    Arrivée
    Page Should Contain    Départ
    Page Should Contain    Voyageurs
    Page Should Contain    Animaux domestiques
    Page Should Contain    Total


US08 - Le voyageur peut accéder au détail de sa réservation
    [Tags]    US08    voyageur

    Se connecter avec un compte valide
    Ouvrir mes réservations
    Ouvrir le détail de la première réservation

    Location Should Contain    reservation_detail


US08 - Une nouvelle demande doit avoir le statut NOUVEAU
    [Tags]    US08    defect

    Se connecter avec un compte valide
    Ouvrir mes réservations
    Ouvrir le détail de la première réservation

    Page Should Contain    NOUVEAU


US08 - Une réservation initiale doit proposer l'action Annuler au voyageur
    [Tags]    US08    defect

    Se connecter avec un compte valide
    Ouvrir mes réservations
    Ouvrir le détail de la première réservation

    Page Should Contain    Annuler