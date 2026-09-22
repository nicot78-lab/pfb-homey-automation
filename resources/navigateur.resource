*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL}    http://livraison3.testacademy.fr/
${navigateur}    Chrome

${JENKINS_URL}    %{JENKINS_URL=}


*** Keywords ***

ouvrir le navigateur et accéder à l'application
    ${options}=    Evaluate
    ...    selenium.webdriver.ChromeOptions()
    ...    modules=selenium.webdriver

    Call Method
    ...    ${options}
    ...    add_argument
    ...    --window-size\=1920,1080

    Call Method
    ...    ${options}
    ...    add_argument
    ...    --disable-notifications

    Call Method
    ...    ${options}
    ...    add_argument
    ...    --disable-popup-blocking

    IF    $JENKINS_URL
        Call Method
        ...    ${options}
        ...    add_argument
        ...    --headless\=new
    END

    Open Browser
    ...    ${URL}
    ...    ${navigateur}
    ...    options=${options}

    Set Window Size    1920    1080

    Wait Until Page Contains Element
    ...    css=body
    ...    15s


fermer le navigateur
    Close All Browsers