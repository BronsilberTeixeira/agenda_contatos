import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String numeroColumn = "numeroColumn";
final String imagemColumn = "imagemColumn";


class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async { 
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

   return await openDatabase(path, version: 1, 
    onCreate: (Database db, int newer) async{
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, "
          "$emailColumn TEXT, $numeroColumn TEXT, $imagemColumn TEXT)"
      );
    });
  }

  Future<Contact> saveContato(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async{
    Database dbContact = await db;
    List<Map> map = await dbContact.query(contactTable, 
    columns: [idColumn, nomeColumn, emailColumn, numeroColumn, imagemColumn],
    where: "idColumn = ?",
    whereArgs: [id]);
    if(map.length > 0){
      return Contact.fromMap(map.first);
    }
    return null;
  }

  Future<int> deleteContact(int id) async{
     Database dbContact = await db;
    return await dbContact.delete(contactTable, where: "idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contato) async{
    Database dbContact = await db;
    return await  dbContact.update(contactTable, contato.toMap(), 
    where: "idColumn = ?", whereArgs: [contato.id]);
  }

  Future<List> getAllContacts() async{
    Database dbContact = await db;
    List<Map> listMap = await dbContact.rawQuery("SELECT * FROM ${contactTable}");
    List<Contact> listContacts = List();
    for(Map m in listMap){
      listContacts.add(Contact.fromMap(m));
    }
    if(listContacts.length > 0){
      return listContacts;
    }
    return null;
  }

  Future<int> getnumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM ${contactTable}"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  int id;
  String nome;
  String email;
  String numero;
  String imagem;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    numero = map[numeroColumn];
    imagem = map[imagemColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      numeroColumn: numero,
      imagemColumn: imagem
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Contact (id: $id, nome: $nome,email: $email, numero: $numero, imagem: $imagem)";
  }
}