import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
    "type": "service_account",
  "project_id": "rpl-gshit",
  "private_key_id": "45b28a2b5ec8b1edac1ce8ac0b83c27579e30129",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCwa3Ey/OblhDXY\nKNkbNGsU5RINiE3BEMvQQ+9l5BJFikHuP24WJZG/JlhQjc4YlLkJR9ILsSF5fbwF\nELgadY5LYq65oDDJu88AW5b4l6/oZ0s3mgCZB3WmGrourXCdt52X+ze0r9hYC+oP\nZB+a60oTpWc/HtU59N6v2JHgQq5RlhRS8LltD32aubrbiYp4pNgOTWItmnK2Ogt1\nbXVIsRco1jaa702wcgk/MAkFrSIzOtywQYwfbfCLyefE+bPsWNXnI6V707lHM75R\nxq0y7sRaPQXRqlQsZiveiq0zjGEs382IsjveHFCE2X/8bvl+atThvdRrdz0ech9e\nXyyIFKYJAgMBAAECggEAC0Bi+RVDlZ5Dv9xFEnTaonvElbvcd6R+VzNJ/KXZ23kI\noO0HNJ7jR31m0wZkP1GW5oZf2VKL979i4zDQiRF3yIuL6LdUfT0+478zpvmnpKsX\n0z09bgUZhgU83BbAMLLh+GwzfpDbe6wQ2rfwQxVgBVY+ejpZb4eUP0NQ9GxUSUwt\nsDKlv2zk4dzAZDs0s6SM/wUYzwWCtj8dOHEt5YBHCYaL7rjmN2faG55dvltiWRbb\nchDBZffGv7gQeBPUUfwsGNYhpNbqp+F8VHKtg9Ez1wOL42vkc+XNXUY1g6t5I4u/\npgjmboFNncVji1O4lYfSjxw3qrrqsQ0X0EuvdHw3PQKBgQDd0QsQZC5HAf2k8Qc9\nn8EjND05nRWrENDmuCSix+S/dcw2mfEZhsyegQ287WPWjNPFGckuyL4m1YDlCVrL\nuZZOb2Fxo6svpjqM0XfB4L3ZXa++mJPmOQgR/D/fWHWYEnqxPqLAdIgXOxWeZg3N\nRoqO8J8vVu5Db6pY423pcJwXvQKBgQDLm26g9fnkfmPXwC5Nl2phsD2ViD75TWC5\nVpAb8X+kj9zJVtOcGLzT+7xEXS6f+XEmYkJwMHEt9aByDqOVW1osZFgrLfpbbgmM\nhPKDmTHH9HV1d4sFrIy1uVf4UryzsiSa0zDo+ZqWCxACEOuBjS87NlvMitCEdOYx\nbO6c8mfWPQKBgQCvu1qpnMSxCtm5YB8dakBoNI3A5DtzcHogH4ke0YDfUmL8aw+A\n6rOXa6THpcbwBlgMEja58t37BDD+w1+EgT6cW0926XTI5kgCojzfg77Ew51lQZoC\nzfIf1ZmAx6M6XIGJhJcKJAhhZzTkbfPHSnihb+6dYaCYGpJ5o4zDYay4fQKBgQCx\n85xiI/oPgYPD6pzNhfwde0qn6ZeYjs9tzUFQmubDrlT6x99U+6313Hv0iDia6wnA\n0Xpd0Yjp8VcUuMSyYlBSojUJMDszM942qW/IItmGeJs8WonwIJourdo8GBwDNjyV\n8OU7igRZBTwtghpDdWEFcIIVKHIMgps6MYnvNFIaxQKBgFyw7n8anDEWl/GjTeGQ\nir8rJdQFOnBrcDl8EPbFwsPOxX/eXVhFxxNAjdm/Ou2HocxOaVhZJkfGFhNnPrau\ntl3Qah6bWjSbhAoYfcElQ02fUeIX4wf/r4Duhq3uxuOG74V9Ct0Q6h6pNgcNYxBU\nBq0ToAZ071aGvvqd6B1UzPvT\n-----END PRIVATE KEY-----\n",
  "client_email": "rpl-gshit@rpl-gshit.iam.gserviceaccount.com",
  "client_id": "114132118450327979022",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/rpl-gshit%40rpl-gshit.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '17WlRZ0t7fABW62k4CWRQ82tTNvhLXw7C4JmSedHpbuA';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfNotes = 0;
  static List<List<dynamic>> currentNotes = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    // now we know how many notes to load, now let's load them!
    loadNotes();
  }

  // load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add([
          newNote,
          int.parse(await _worksheet!.values.value(column: 2, row: i + 1))
        ]);
      }
    }

    loading = false;
  }

  // insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add([note, 0]);
    await _worksheet!.values.appendRow([note, 0]);
  }

  static Future update(int index, int isTaskCompleted) async {
    _worksheet!.values.insertValue(isTaskCompleted, column: 2, row: index + 1);
  }
}
