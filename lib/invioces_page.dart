import 'package:flutter/material.dart';
import 'main.dart';

import 'details_page.dart';
import 'invoice.dart';
class InvoicesPage extends StatelessWidget {
  List<Invoice> invoices;
   InvoicesPage(this.invoices,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Customers'),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(invoices[index]),));
              },
              tileColor: Colors.blueAccent,
              leading: Text(invoices[index].customerName,style: TextStyle(fontSize: 22),),
            ),
          ),
      ),
    );
  }
}
