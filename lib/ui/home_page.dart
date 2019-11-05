import 'package:agenda_contatos/hellpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions{
  orderaz,
  orderza
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  ContactHelper helper = ContactHelper();

  List contacts = List();

  @override
  void initState() {
    super.initState();

    /*  Contact c = Contact();
    c.name = "Confucio";
    c.phone = "93i39i3";
    c.email = "lkjdfl";
    c.img = "lkjl";

    helper.saveContact(c);*/

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Contatos"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context)=> <PopupMenuEntry<OrderOptions>>[
            const PopupMenuItem<OrderOptions>(child: Text("A - Z"),
            value: OrderOptions.orderaz,),
            const PopupMenuItem<OrderOptions>(child: Text("Z - A"),
              value: OrderOptions.orderza,),
          ], onSelected: _orderList)
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           _goToContactPage();
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _cardBuild(context, index);
        },
      ),
    );
  }

  Widget _cardBuild(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                          "images/person.png") /*contacts[index] != null ? FileImage(File(contacts[index].img)): AssetImage("images/person.png")*/,
                    )

                  /*FileImage(File(contacts[index].img))?? AssetImage("images/person.png"),*/

                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contacts[index].name ?? "",
                    style:
                    TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    contacts[index].email ?? "",
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    contacts[index].phone ?? "",
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
//        _goToContactPage(contact: contacts[index]);
      _showModalButtonSheet(context, index);
      },
    );
  }

  _showModalButtonSheet(BuildContext context, int index) {
    showModalBottomSheet(context: context, builder: (context){
      return BottomSheet(
        onClosing: (){},
        builder: (context){
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Ligar", style: TextStyle(color: Colors.red),),
                  onPressed: (){
                    launch("tel:${contacts[index].phone}");
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Editar", style: TextStyle(color: Colors.red),),
                  onPressed: (){
                      Navigator.pop(context);
                      _goToContactPage(contact: contacts[index]);
                      print("clickei em Editar");
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Remover", style: TextStyle(color: Colors.red),),
                  onPressed: (){
                    setState(() {
                      print("clickei em remover");
                     helper.delete(contacts[index].id);
                     contacts.removeAt(index);
                     Navigator.pop(context);
                    });
                  },
                ),
              )
            ],
          ),
        );
        }
      );
    });
  }





  void _goToContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        helper.update(recContact);
      } else {
        helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
