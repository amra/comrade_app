import 'dart:io';

import 'package:comrade_app/storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    test('Settings load', () async {
//        print(rootBundle.loadString('data/data.json'));
//        print(File('data/data.json').readAsStringSync());
        PathStorage pathStorage = await PathStorage.create(Directory.current.path);
        await Storage.init(pathStorage);
        expect(Storage.users, isNotNull);
        expect(Storage.users.length, equals(377));
    });
}