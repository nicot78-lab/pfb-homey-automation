*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL_RESERVATIONS}    http://livraison3.testacademy.fr/index.php/reservations/


*** Keywords ***

Ouvrir mes réservations
    Go To    ${URL_RESERVATIONS}

    Wait Until Page Contains
    ...    Arrivée
    ...    15s


Ouvrir le détail de la première réservation
    Wait Until Element Is Visible
    ...    xpath=(//a[contains(@href,'reservation_detail=')])[1]
    ...    10s

    Click Element
    ...    xpath=(//a[contains(@href,'reservation_detail=')])[1]

    Wait Until Location Contains
    ...    reservation_detail
    ...    15s