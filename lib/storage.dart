import 'dart:convert' as JSON;
import 'dart:io';

import 'package:comrade_app/json/config.dart';
import 'package:comrade_app/json/data.dart';
import 'package:comrade_app/json/user.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Storage {
    static PathStorage pathStorage;

    static List<User> users;
    static Map<String, User> userMap = Map();
    static Set<String> favorites;

    static Future<void> init(PathStorage pathStorage) async {
        Storage.pathStorage = pathStorage;
        Storage.users = await loadUsers();
        users.forEach((user) {userMap.putIfAbsent(user.username, () => user);});
        Storage.favorites = await loadSettings();
    }

    static Future<List<User>> loadUsers() async {
        try {
            print('loadUsers');
            String contents = await pathStorage.loadData();
            final json = JSON.json.decode(contents);
            Data data = Data.fromJson(json);

            data.colleges.sort();
            return data.colleges;
        } catch (e) {
            print(e);
            return new List();
        }
    }

    static Future<Set<String>> loadSettings() async {
        if (!pathStorage.configJson.existsSync()) {
            return Set();
        }
        try{
            var settingsJsonString = pathStorage.configJson.readAsStringSync();
            print("reading config: ${settingsJsonString}");
            Map configMap = JSON.json.decode(settingsJsonString);
            var config = Config.fromJson(configMap);
            return config.favorites;
        } catch (e) {
            print(e.toString());
            return Set();
        }
    }

    static void saveSettings() {
        var config = Config(favorites);
        String jsonToSave = JSON.json.encode(config);
        print('saving config: ${jsonToSave}');
        pathStorage.configJson.writeAsStringSync(jsonToSave);
    }

    static void importData(String filePath) {
        //TODO: validate json file
        File(filePath).copySync(pathStorage._localPath + '/data.json');
        loadUsers();
    }
}

class PathStorage {
    String _localPath;      // Application data directory.

    String _dataPath;       // Data file full path.
    File _configJsonFile;   // Local configuration file.

    static Future<PathStorage> create([String localPath]) async {
        var pathStorage = new PathStorage();
        if (localPath != null) {
            pathStorage._localPath = localPath;
        } else {
            pathStorage._localPath = await pathStorage._getLocalPath();
        }

        pathStorage._configJsonFile = File('${pathStorage._localPath}/config.json');

        pathStorage._dataPath = pathStorage._localPath + '/data.json';
        return pathStorage;
    }

    Future<String> loadData() async {
        if (File(_dataPath).existsSync()) {
            print('loadData() file');
            return File(_dataPath).readAsStringSync();
        }
        print('loadData() none');
        return '';
    }

    static Future<bool> assetExists(String asset) {
        // Ok to load it, because it will be cached and is guaranteed to be used later anyways
        return rootBundle.load(asset).then((_) => true).catchError(() => false);
    }

    String get localPath => _localPath;
    File get configJson => _configJsonFile;
    String get dataPath => _dataPath;

    Future<String> _getLocalPath() async {
        try {
            final directory = await getApplicationDocumentsDirectory();
            return directory.path;
        } catch (e) {
            print(e);
            return '.';
        }
    }


}