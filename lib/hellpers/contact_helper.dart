
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


String contactTable = "contactTable";
String idColumn = "idColumn";
String nameColumn = "nameColumn";
String emailColumn = "emailColumn";
String phoneColumn = "phoneColumn";
String imgColumn = "imgColumn";

class ContactHelper{

  static final ContactHelper _instance = ContactHelper.internal();

  ContactHelper.internal();

  factory ContactHelper() => _instance;

  Database _db;

  Future<Database> get db async {
    if (_db != null)
      return _db;
    else {
      _db = await _initDb();
      return _db;
    }
  }

    Future<Database> _initDb()async{
       final dataBasePath = await getDatabasesPath();
       final path = join(dataBasePath, "contactDb.db");

       return await openDatabase(path, version: 1, onCreate: _onCreate);
    }
    _onCreate(Database db, int newVersion) async{

    await db.execute("CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,"
        " $phoneColumn TEXT, $emailColumn TEXT, $imgColumn TEXT)");


  }

  Future<Contact> saveContact(Contact contact)async{
    Database contactDb = await db;
    contact.id = await contactDb.insert(contactTable, contact.toMap());
    return contact;

  }

  Future<Contact> getContact(int id)async{
    Database contactDb = await db;
   List< Map> map = await contactDb.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?", whereArgs: [id]);
    if(map!= null){
      return Contact.fromMap(map.first);
    }else{
      return null;
    }
  }

  Future<int> delete(int id)async{
    Database contactDb = await db;
    return contactDb.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<List> getAllContacts()async{
    Database contactDb = await db;
    List list = await contactDb.rawQuery("SELECT * FROM $contactTable");
    List<Contact> contactList =  List();
    for(Map m in list){
      contactList.add(Contact.fromMap(m));
    }
    return contactList;

  }
  Future<int> update(Contact contact) async{
    Database contactDb = await db;
    return await contactDb.update(contactTable,
        contact.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contact.id]
    );

  }
  Future<int> getNumber()async{
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT (*) FROM $contactTable"));
  }

  Future close()async{
    Database dbContact = await db;
    dbContact.close();
  }




}

class Contact{
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap(){
    Map<String, dynamic> map ={
      nameColumn:  name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img

    };

    if(id != null)  map[idColumn] = id;
    return map;
  }

  @override
  String toString() {
    return "Contact [nome: $name, email: $email, telefone: $phone]";
  }


}