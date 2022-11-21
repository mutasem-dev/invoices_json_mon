import 'dart:convert';

import 'package:flutter/material.dart';
import 'details_page.dart';
import 'invioces_page.dart';
import 'invoice.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(
      MaterialApp(
        home: MainPage(),
      )
  );
}
TextEditingController cnameController = TextEditingController();
TextEditingController pnameController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController quantityController = TextEditingController();

class MainPage extends StatefulWidget {
 List<Product> products = [];
//List<Invoice> invoices = [];
int invoiceNo = 1;


  @override
  _MainPageState createState() => _MainPageState();

 MainPage({Key? key}) : super(key: key);
}

class _MainPageState extends State<MainPage> {
   late Future<List<Invoice>> invoices;
  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text('Product Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(

                autofocus: false,
                controller: pnameController,
                decoration: InputDecoration(
                  labelText: 'product name',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: false,
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'price',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                autofocus: false,
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'quantity',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {

                  int q = 0;
                  double p = 0;
                  if(pnameController.text.isEmpty) {
                    const snackBar = SnackBar(
                      content: Text('Enter product name'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  try {
                    q = int.parse(quantityController.text);
                    p = double.parse(priceController.text);
                  }
                  catch(e) {
                    const snackBar = SnackBar(
                      content: Text('inter valid number'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  widget.products.add(Product(name: pnameController.text,
                      price: p,
                      quantity: q));
                  pnameController.clear();
                  priceController.clear();
                  quantityController.clear();
                  Navigator.of(context).pop();
                  setState(() {

                  });
                },
                child: Text('add')
            ),
            ElevatedButton(

                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('cancel')
            ),
          ],
        ),
    );
  }
  Future<List<Invoice>> fetchInvoices() async{
   List<Invoice> invoices = [];

     http.Response response = await http.get(Uri.parse('https://www.jsonkeeper.com/b/462B'));
     if(response.statusCode == 200) {
       print(response.body);
       var jsonObject = jsonDecode(response.body);
       var jsonArr = jsonObject['invoices'] as List;
       invoices = jsonArr.map((e) => Invoice.fromJson(e)).toList();
     }
   return invoices;
  }
  @override
  void initState() {
    super.initState();
    invoices = fetchInvoices();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice# ${widget.invoiceNo}'),
      ),
      body: Column(
        children: [
          TextField(
            autofocus: false,
            controller: cnameController,
            decoration: InputDecoration(
              labelText: 'customer name',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Products:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              ElevatedButton(
                  onPressed: () {
                    _showDialog(context);
                  },
                  child: Text('add product')
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.blue,
                      leading: Text(widget.products[index].name,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      title: Text('price: ${widget.products[index].price}'),
                      subtitle: Text('Quantity: ${widget.products[index].quantity}'),
                      trailing: IconButton(
                        onPressed: () {
                          widget.products.removeAt(index);
                          setState(() {

                          });
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  );
                },
            ),
          ),
          FutureBuilder<List<Invoice>>(
            future: invoices,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Invoice>? invs = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if(cnameController.text.isEmpty)
                            {
                              const snackBar = SnackBar(
                                content: Text('Enter customer name'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              return;
                            }
                            invs?.add(
                                Invoice(invoiceNo: widget.invoiceNo++,customerName: cnameController.text,products: widget.products)
                            );
                            cnameController.clear();
                            widget.products = [];
                            setState(() {

                            });
                          },
                          child: Text('add invoice')
                      ),
                      ElevatedButton(

                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => InvoicesPage(invs!),));
                          },
                          child: Text('show all invoices')
                      ),
                    ],
                  );
                } else if(snapshot.hasError) {
                  return Text('error ${snapshot.error.toString()}');
                }else {
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              },
          ),
        ],
      ),
    );
  }
}