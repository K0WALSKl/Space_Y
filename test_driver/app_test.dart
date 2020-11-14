import 'dart:convert';
import 'dart:math';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

String randomString(int length) {
  final Random kRandom = Random.secure();
  final List<int> values = List<int>.generate(length, (int i) =>  kRandom.nextInt(255));
  return base64UrlEncode(values);
}

void main() {
  // Boutons
  final SerializableFinder kSignUpButton =  find.byValueKey('fromStartupPageGoToSignUp');
  final SerializableFinder kLogoutButton = find.byValueKey('LogoutButton');
  final SerializableFinder kLoginSubmitButton = find.byValueKey('loginSubmitButton');
  final SerializableFinder kBookTicketButton = find.byValueKey('BookTicketButton');
  final SerializableFinder kFromBoughtTicketDoneButton = find.byValueKey('TicketDoneButton');

  // TextFields
  final SerializableFinder kUsernameTextField = find.byValueKey('UsernameTextField');
  final SerializableFinder kEmailTextField = find.byValueKey('EmailTextField');
  final SerializableFinder kPasswordTextField = find.byValueKey('PasswordTextField');
  final SerializableFinder kSignUpSubmitButton = find.byValueKey('SignUpSubmitButton');
  final SerializableFinder kLoginEmailTextField = find.byValueKey('LoginEmailTextField');
  final SerializableFinder kLoginPasswordTextField = find.byValueKey('LoginPasswordTextField');

  // Scrollable
  final SerializableFinder kScrollableStartupPage = find.byValueKey('StartupScrollablePage');
  final SerializableFinder kSignUpScrollableContainer = find.byValueKey('SignUpScrollableContainer');
  final SerializableFinder kLoginScrollableColumn = find.byValueKey('loginScrollableColumn');
  final SerializableFinder kProfileScrollable = find.byValueKey('ProfileScrollable');

  // Checkbox
  final SerializableFinder kMassageCheckbox = find.byValueKey('MassageCheckBox');
  final SerializableFinder kNoGravityMeal = find.byValueKey('NoGravityMealCheckbox');

  // Valeurs test

  // Sert à créer un nouveau profil aléatoire à chaque test
  final String randomCharacters = randomString(8).replaceAll(RegExp(r'[^\w\s]+'),'');

  final String kUsername = 'KsumNole' + randomCharacters ;
  final String kEmail = 'KsumNole' + randomCharacters + '@spaceY.com';
  const String kPassword = 'azertyuiopqsdfghj';
  final String kDatePlusTenDays = DateFormat.yMMMd().format(DateTime.now().add(const Duration(days: 10))).toString();

  FlutterDriver driver;
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    driver.close();
  });
  group('Inscription & Connexion', () {
    test("Inscription Depuis l'écran d'accueil suivi d'une déconnexion", () async {
      // Clique sur le bouton d'inscription
      await driver.tap(kSignUpButton);

      // Remplis tous les champs
      await driver.tap(kUsernameTextField);
      await driver.enterText(kUsername);

      await driver.tap(kEmailTextField);
      await driver.enterText(kEmail);

      await driver.tap(kPasswordTextField);
      await driver.enterText(kPassword);

      // Scroll en bas de la page (pour les petits écrans) et appuie sur le bouton d'inscription
      await driver.scrollUntilVisible(
          kSignUpScrollableContainer,
          kSignUpSubmitButton,
          dyScroll: -3000);
      await driver.tap(find.text('Inscription'));

      await driver.tap(find.text('Profile'));

      // Scroll sur le bouton de logout
      await driver.scrollUntilVisible(
          kProfileScrollable,
          kLogoutButton,
          dyScroll: -3000);


      // Clique sur le bouton de logout
      await driver.tap(kLogoutButton);
    }, timeout: const Timeout(Duration(minutes: 2)));

    test("Connexion depuis l'écran d'accueil", () async {
      await driver.scrollUntilVisible(
          kScrollableStartupPage,
          kLoginEmailTextField,
        dxScroll: 3000
      );

      await driver.tap(kLoginEmailTextField);
      await driver.enterText(kEmail);

      await driver.tap(kLoginPasswordTextField);
      await driver.enterText(kPassword);

      await driver.scrollUntilVisible(
          kLoginScrollableColumn,
          kLoginSubmitButton,
          dyScroll: -3000
      );

      await driver.tap(kLoginSubmitButton);
    }, timeout: const Timeout(Duration(minutes: 2)));
  });

  group('Gestion de tickets', () {
    test('Achat d\'un ticket', () async {
      await driver.tap(kMassageCheckbox);
      await driver.tap(kNoGravityMeal);
      await driver.tap(kBookTicketButton);
      await driver.tap(kFromBoughtTicketDoneButton);
    }, timeout: const Timeout(Duration(minutes: 2)));
    test('Vérification de la présence des tickets', () async {
      await driver.tap(find.text('My Tickets'));
      await driver.tap(find.text(kDatePlusTenDays));
      await driver.tap(find.text('Massage'));
      await driver.tap(find.text('No gravity meal'));

      // Le test ayant l'air de se lancer 2 fois sur codemagic, un deuxième logout est nécessaire.
      await driver.tap(find.text('Profile'));

      // Scroll sur le bouton de logout
      await driver.scrollUntilVisible(
          kProfileScrollable,
          kLogoutButton,
          dyScroll: -3000);


      // Clique sur le bouton de logout
      await driver.tap(kLogoutButton);
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}