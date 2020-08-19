

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:flutter_proyecto/main.dart';

//eliminar el código de lista de temporizadores pendientes
void main() {

  group('Temporizador pendiente', () {
    TestExceptionReporter currentExceptionReporter;

    setUp(() {
      currentExceptionReporter = reportTestException;
    });

    tearDown(() {
      reportTestException = currentExceptionReporter;
    });

    testWidgets('Counter increments smoke test', (WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(home: MyPeliculasApp(storage: idiomaStorage())));

      //reporte de errores flutter temporizadores
      FlutterErrorDetails flutterErrorDetails;
      reportTestException = (FlutterErrorDetails details, String testDescription) {
        flutterErrorDetails = details;
      };

      expect(find.byType(AppBar), findsNWidgets(2));// se esperan tener dos appbar
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // finalizar los temporizadores pendientes
      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
      await binding.runTest(() async {
        final Timer timer = Timer(const Duration(seconds: 1), () {});
        expect(timer.isActive, true);
      }, () {});



    });

    /*

    test('Lanza mensaje de aserción sin código', () async {
      FlutterErrorDetails flutterErrorDetails;
      reportTestException = (FlutterErrorDetails details, String testDescription) {
        flutterErrorDetails = details;
      };

      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
      await binding.runTest(() async {
        final Timer timer = Timer(const Duration(seconds: 1), () {});
        expect(timer.isActive, true);
      }, () {});

      expect(flutterErrorDetails, isNotNull);
      expect(flutterErrorDetails.exception, isA<AssertionError>());
      expect(flutterErrorDetails.exception.message, 'A Timer is still pending even after the widget tree was disposed.');


    });*/
  });

}

/*
testWidgets('Counter increments smoke test', (WidgetTester tester) async {

await tester.pumpWidget(MaterialApp(home: MyPeliculasApp(storage: idiomaStorage())));
//await tester.pumpWidget(MyPeliculasApp(storage: idiomaStorage()),);
expect(find.byType(AppBar), findsNWidgets(2));// se esperan tener dos appbar
expect(find.byType(CircularProgressIndicator), findsOneWidget);

});
*/
