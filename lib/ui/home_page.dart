import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderAZ, orderZA}
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
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>> [
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderAZ,
              ),
               const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderZA,
              )
            ],
            onSelected: _orderList,
          )
        ],
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
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, index) {
    showModalBottomSheet(
      context:  context, 
      builder: (context) {
        return BottomSheet(
          onClosing: () {}, 
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        launch("tel:${contacts[index].phone}");
                        Navigator.pop(context);
                      }, 
                      child: Text("Ligar", 
                      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showContactpage(contact: contacts[index]);
                      }, 
                      child: Text("Editar", 
                      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        helper.deleteContact(contacts[index].id);
                        setState(() {
                          contacts.removeAt(index);
                          Navigator.pop(context);
                        });
                      }, 
                      child: Text("Excluir", 
                      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                      )
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }

  void _showContactpage({Contact contact}) async{
    final recContact = await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );
    if(recContact != null) {
      if(contact != null){
        await helper.updateContact(recContact);
      }
      else {
        await helper.saveContact(recContact);
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

  void _orderList(OrderOptions result) {
    switch(result) {
      case OrderOptions.orderAZ:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        }); 
      break;
      case OrderOptions.orderZA:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        }); 
      break;
    }
    setState(() {});
  }

}