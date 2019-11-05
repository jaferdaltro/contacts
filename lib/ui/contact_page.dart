

import 'dart:io';

import 'package:agenda_contatos/hellpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;


  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}



class _ContactPageState extends State<ContactPage> {

  Contact _editContact;

    bool _userEdited = false;

   final _nameController = TextEditingController();
   final _phoneController = TextEditingController();
   final _emailController = TextEditingController();

   final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.contact != null){
        _editContact = Contact.fromMap(widget.contact.toMap());
        _nameController.text = _editContact.name;
        _emailController.text = _editContact.email;
        _phoneController.text = _editContact.phone;

    }else{
      _editContact = Contact();

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editContact.name ?? "Novo"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: (){
            if(_editContact.name != null && _editContact.name.isNotEmpty){
              Navigator.pop(context, _editContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
        ),
        body: _bodyBuilding()
      ),
    );
  }

  Widget _bodyBuilding(){
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:  _editContact.img != null ? FileImage(File(_editContact.img)): AssetImage("images/person.png"),
                )
            ),
          ),
          onTap: (){
            ImagePicker.pickImage(source: ImageSource.camera).then((file){
              if(file == null)return;
              setState(() {
                _editContact.img = file.path;
              });
            });
          },
        ),
        TextField(
          controller: _nameController,
          focusNode: _nameFocus,
          decoration: InputDecoration(labelText: "name"),
          onChanged: (text){
            _userEdited = true;
            setState(() {
              _editContact.name = text;
            });
          },
          keyboardType: TextInputType.text,
        ),TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: "email"),
          onChanged: (text){
            _userEdited = true;
           _editContact.email = text;
          },
          keyboardType: TextInputType.emailAddress,
        ),TextField(
          controller: _phoneController,
          decoration: InputDecoration(labelText: "phone"),
          onChanged: (text){
            _userEdited = true;
           _editContact.phone = text;
          },
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
        return AlertDialog(
          title: Text('Descartar alterações?'),
          content: Text('as alterações serão perdidas'),
          actions: <Widget>[
            FlatButton(
              child: Text('cancelar'),
              onPressed: (){
                Navigator.pop(context);
              },

            ),FlatButton(
              child: Text('ok'),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },

            ),
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

}
