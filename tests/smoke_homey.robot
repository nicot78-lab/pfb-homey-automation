*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}        http://livraison3.testacademy.fr/
${BROWSER}    chrome

*** Test Cases ***
Vérifier que Homey est accessible
    Open Browser    ${URL}    ${BROWSER}
    Location Should Contain    livraison3.testacademy.fr
    [Teardown]    Close All Browsers