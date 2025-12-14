
import 'package:ecommerce_sem4/models/user/order/response/order_item_response.dart';
import 'package:ecommerce_sem4/screens/user/account/views/components/label_item_component.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class UserOrderDetailScreen extends StatefulWidget {
  final OrderItemResponse? userOrder;

  const UserOrderDetailScreen({super.key, required this.userOrder});

  @override
  State<StatefulWidget> createState() => _UserOrderDetail();
}

class _UserOrderDetail extends State<UserOrderDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  final imageUrl = "http://10.0.2.2:5069/images/";
  final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenBgColor,
            automaticallyImplyLeading: true,
            foregroundColor: whiteColor,
            title: const Text("Chi Tiết Đơn Hàng"),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelItem(
                                        labelName: "Mã đơn:",
                                        content: widget.userOrder!.orderId
                                            .toString()),
                                    LabelItem(
                                      labelName: "Tên khách hàng:",
                                      content:
                                          widget.userOrder!.userName.toString(),
                                    ),
                                    LabelItem(
                                      labelName: "Email:",
                                      content:
                                          widget.userOrder!.email.toString(),
                                    ),
                                    LabelItem(
                                      labelName: "Số điện thoại:",
                                      content: (widget.userOrder!.phone
                                                  .toString() ==
                                              'null'
                                          ? ""
                                          : widget.userOrder!.phone.toString()),
                                    ),
                                    LabelItem(
                                      labelName: "Ngày đặt:",
                                      content: DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                              widget.userOrder!.orderDate!)),
                                    ),
                                    LabelItem(
                                      labelName: "Địa chỉ giao hàng:",
                                      content:
                                          widget.userOrder!.shippingAddress!,
                                    ),
                                    LabelItem(
                                      labelName: "Trạng thái:",
                                      content:
                                          widget.userOrder!.status.toString(),
                                    ),
                                    LabelItem(
                                      labelName: "Tổng tiền:",
                                      content: formatCurrency
                                          .format((widget.userOrder!.totalPrice ?? 0) + 30000),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                                      child: DataTable(
                                        columns: const [
                                          DataColumn(label: Text('STT')),
                                          DataColumn(label: Text('Tên sản phẩm')),
                                          DataColumn(label: Text('Số lượng')),
                                          DataColumn(label: Text('Giá')),
                                          DataColumn(label: Text('Tạm tính')),
                                        ],
                                        rows: widget.userOrder!.orderItems!.asMap().map((index, item) {
                                          return MapEntry(index, DataRow(cells: [
                                            DataCell(Text((index + 1).toString())), // Index starts from 0, so add 1 to show it correctly
                                            DataCell(Text(item.productName!)),
                                            DataCell(Text(item.quantity.toString())),  // Make sure quantity is a string or convert it
                                            DataCell(Text(formatCurrency.format(item.price))),    // Same here for price
                                            DataCell(Text(formatCurrency.format(item.subTotal))), // Same for subtotal
                                          ]));
                                        }).values.toList(), // Convert the Map values to a List of DataRow
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Tạm tính:",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                formatCurrency.format(
                                                  widget.userOrder!.orderItems!.fold(0.0, (sum, item) => sum + (item.subTotal ?? 0))
                                                ),
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Phí vận chuyển:",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                formatCurrency.format(30000),
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 20, thickness: 1),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Tổng cộng:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                formatCurrency.format((widget.userOrder!.totalPrice ?? 0) + 30000),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //BottomButton(buttonName: "Add to cart",price: widget.product!.price,quantity: _quantity,event: _addToCart,)
            ],
          )),
    );
  }
}
