*** Settings ***
Resource    ../resources/commun.resource

Test Setup       ouvrir le navigateur et accéder à l'application
Test Teardown    fermer le navigateur


*** Test Cases ***

MDP-01 - Un utilisateur peut ouvrir la popup Mot de passe oublié
    [Tags]    mot-de-passe

    Ouvrir la popup Mot de passe oublié


MDP-02 - Un compte inconnu affiche un message d'erreur
    [Tags]    mot-de-passe    compte-inconnu

    ${email}=    Générer un email inconnu

    Ouvrir la popup Mot de passe oublié
    Soumettre une demande de réinitialisation    ${email}
    Attendre le message final

    Le compte inconnu doit afficher une erreur


MDP-03 - Un compte connu doit recevoir un email de réinitialisation
    [Tags]    mot-de-passe    compte-connu    defect

    ${email}=    Créer un compte Voyageur pour le test

    Ouvrir la popup Mot de passe oublié
    Soumettre une demande de réinitialisation    ${email}
    Attendre le message final

    Le compte connu doit confirmer l'envoi de réinitialisation