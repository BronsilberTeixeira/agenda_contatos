import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
    void initState() {
      super.initState();

      _getAllContacts();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
       backgroundColor: Colors.blueGrey[100],
       floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactpage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }
        ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img != null ? 
                      FileImage(File(contacts[index].img)) :
                        AssetImage("images/person.png")
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "", 
                      style: TextStyle(fontSize: 22, 
                      fontWeight: FontWeight.bold),
                    ),
                     Text(contacts[index].email ?? "", 
                      style: TextStyle(fontSize: 15),
                    ),
                     Text(contacts[index].phone ?? "", 
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
               ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showContactpage(contact:  contacts[index]);
      },
    );
  }

  _getAllContacts() {
       helper.getAllContacts().then((list) {
        setState(() {
          contacts = list;
        });
      });
  }

  void _showContactpage({Contact contact}) async{
    final recContact = await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );
    if(recContact != null) {
      if(contacts != null){
        await helper.updateContact(recContact);
      }
      else {
        await helper.saveContact(recContact);
      }
        _getAllContacts();
    }
  }
}