import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  @override
  void initState(){
    super.initState();

    Contact c = Contact(); 

    c.name = "Bronsilber";
    c.email = "bron.teixeira@gmail.com";
    c.phone = "31982430869";
    c.img = "iamge teste";

    print(c);

    helper.getAllContacts().then((listContacts) {
      print(listContacts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}