import 'product.dart';

class Invoice {
  int invoiceNo;
  String customerName;
  List<Product> products;

  Invoice({required this.invoiceNo,required this.customerName,required this.products});
  factory Invoice.fromJson(dynamic jsonObject) {
    var jsonArr = jsonObject['products'] as List;
    List<Product> prds = jsonArr.map((e) => Product.fromJson(e)).toList();
    return Invoice(
      customerName: jsonObject['customerName'],
      invoiceNo: jsonObject['invoiceNo'],
      products: prds
    );
  }
}