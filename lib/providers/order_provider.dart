import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/db_helper.dart';
import 'package:ecom_user/models/order_model.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> userOrderList = [];

  getAllUserOrders() {
    DbHelper.getAllUserOrders(AuthService.currentUser!.uid).listen(
      (snapshot) {
        userOrderList = List.generate(
          snapshot.docs.length,
          (index) => OrderModel.fromJson(
            snapshot.docs[index].data(),
          ),
        );
        notifyListeners();
      },
    );
  }

  Future<void> addOrder(OrderModel orderModel) async {
    await DbHelper.addNewOrder(orderModel);
    return DbHelper.clearCart(
        AuthService.currentUser!.uid, orderModel.orderDetails);
  }
}
