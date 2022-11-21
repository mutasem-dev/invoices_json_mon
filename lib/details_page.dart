import 'package:flutter/material.dart';
import 'invioces_page.dart';
import 'main.dart';
import 'product.dart';

import 'invoice.dart';
class DetailsPage extends StatelessWidget {
  Invoice invoice;
  DetailsPage(this.invoice, {Key? key}) : super(key: key);
  String total() {

    String result = '';
    int quantity = 0;
    double totalPrice = 0;
    for (var p in invoice.products) {
      quantity += p.quantity;
      totalPrice += p.quantity*p.price;
    }
    result += 'Total Price: $totalPrice \nTotal Quantity: $quantity';
    return result;
  }
  String getProducts() {

    String prd = '';
    // for(int i=0;i<inv.products.length;i++) {
    //   prd += '${inv.products[i].name} Price: ${inv.products[i].price} Quantity: ${inv.products[i].quantity}\n';
    // }
    // for(Product p in inv.products) {
    //   prd += '${p.name} Price: ${p.price} Quantity: ${p.quantity}\n';
    // }
    int i = 1;
    invoice.products.forEach((p) {
      prd += '${i++}- ${p.name}, Price: ${p.price}, Quantity: ${p.quantity}\n';
    });
    return prd;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.customerName),
      ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invoice no: ${invoice.invoiceNo}',style: TextStyle(fontSize: 22),),
        const SizedBox(height: 10,),
        const Text('Products:',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
        const SizedBox(height: 5,),
        Text(getProducts(),style: const TextStyle(fontSize:20),),
        Text(total(),style: const TextStyle(fontSize: 22),),
      ],
    ),
    );
  }
}
