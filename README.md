<img src="assets/images/logo_space_y.png" width="450"/>

[![Codemagic build status](https://api.codemagic.io/apps/5f9573523e7e08934dd07031/5f9573523e7e08934dd07030/status_badge.svg)](https://codemagic.io/apps/5f9573523e7e08934dd07031/5f9573523e7e08934dd07030/latest_build)

La célèbre entreprise à but très lucrative vous offre un ticket pour l'espace!
## Instructions
* flutter pub get && flutter run

## Sujet
L'application réalise des requêtes HTTP vers une API afin de :
* S'inscrire (username, email, password)
* Se connecter (attribution d'un token)
* Acheter un ticket avec des options (siège massant, repas sans gravité, <a href="https://youtu.be/qeaiVveZWD8?t=31">piscine sans gravité</a>)
* Lister les tickets achetés
* Connaître sa position ou son adresse (les coordonnées GPS s'affichent si aucune adresse n'a été retourné par l'API du gouvernement)
* Se déconnecter

## Les fonctionnalités
* Gestionnaire de session avec token
* Utilisation du GPS du téléphone afin de récupérer la position
* Requêtes POST & GET afin de créer un utilisateur, récupérer ses informations, créer une demande de ticket, afficher les tickets
* Flutter drive test (Inscription, connexion, déconnexion, créer un ticket et vérifier sa présence)
* Utilisation de l'architecture BloC

### Exemple d'un flutter drive test ci-dessous
![e2eTest record](readme_res/flutterDriveTest.gif)

### Captures d'écran de l'application
<img src="readme_res/screenshots/LandingPage.png" width="300"/>
<img src="readme_res/screenshots/SignUpPage.png" width="300"/>
<img src="readme_res/screenshots/LoginPage.png" width="300"/>
<img src="readme_res/screenshots/getFreeTicket.png" width="300"/>
<img src="readme_res/screenshots/listMyTickets.png" width="300"/>
<img src="readme_res/screenshots/ProfilePage.png" width="300"/>
<img src="readme_res/screenshots/displayAddressPage.png" width="300"/>

