import 'dart:convert' as JSON;
import 'dart:io';

import 'package:comrade_app/json/config.dart';
import 'package:comrade_app/json/data.dart';
import 'package:comrade_app/json/user.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Settings {
    static List<User> users;
    static Map<String, User> userMap = Map();
    static String localPath;
    static Set<String> favorites;

    static Future<void> init() async {
        Settings.users = await loadUsers();
        users.forEach((user) {userMap.putIfAbsent(user.username, () => user);});
        Settings.localPath = await getLocalPath();
        Settings.favorites = await loadSettings();
    }

    static Future<List<User>> loadUsers() async {
        try {
            String contents = await getFileData('data/data.json');

            final json = JSON.json.decode(contents);
            Data data = Data.fromJson(json);
            print("data: " + data.colleges.length.toString());

            data.colleges.sort((user1, user2) {
                if (user1.last_name == user2.last_name) {
                    return user1.first_name.compareTo(user2.first_name);
                }
                return user1.last_name.compareTo(user2.last_name);
            });
            return data.colleges;
        } catch (e) {
            print(e);
            return new List();
        }
    }

    static Future<String> getFileData(String path) async {
        return await rootBundle.loadString(path);
    }

    static Future<String> getLocalPath() async {
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
    }

    static Future<Set<String>> loadSettings() async {
        File settingsFile = File('${localPath}/config.json');
        if (!settingsFile.existsSync()) {
            return Set();
        }
        try{
            var settingsJsonString = settingsFile.readAsStringSync();
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
        File settingsFile = File('${localPath}/config.json');
        settingsFile.writeAsStringSync(jsonToSave);
    }
}
