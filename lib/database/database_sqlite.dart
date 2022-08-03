import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseSqLite {
  Future<void> openConnection() async {
    final databasePath = await getDatabasesPath();
    final databaseFinalPaht = join(databasePath, 'SQLITE_EXAMPLE');

    await openDatabase(
      databaseFinalPaht,
      version: 1,
      onConfigure: (db) async{
        await db.execute("PRAGMA foreing_keys = ON");
      },
      // chamado somente no momento de criação do banco de dados
      // primeira vez que carrega o aplicativo
      onCreate: (Database db, int version) {
        final batch = db.batch();

        batch.execute(
            ''' 
          create table teste(
            id integer primary key autoincrement,
            nome varchar(200)
          )
        ''');

        batch.commit();
      },

      // será chamado sempre que ouver uma alteração no version incrementa(1 -> 2)
      onUpgrade: (Database db, int oldVersion, int version) {
        final batch = db.batch();
        if (oldVersion == 1) {
          batch.execute(
              ''' 
          create table produto(
            id integer primary key autoincrement,
            nome varchar(200)
          )
        ''');
        }

        batch.commit();
      },

      // será chamado sempre que ouver uma alteração no version decremental(2 -> 1)
      onDowngrade: (Database db, int oldVersion, int version) {},
    );
  }
}
