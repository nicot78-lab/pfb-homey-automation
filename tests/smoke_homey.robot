*** Settings ***
Library     SeleniumLibrary
Resource    ../resources/variables.robot


*** Test Cases ***

Vérifier que Homey est accessible
    Open Browser    ${URL}    ${navigateur}
    Location Should Contain    livraison3.testacademy.fr

    [Teardown]    Close All Browsers