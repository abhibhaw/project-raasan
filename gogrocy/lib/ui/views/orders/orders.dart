import 'package:flutter/material.dart';
import 'package:gogrocy/core/enums/viewstate.dart';
import 'package:gogrocy/core/models/orders.dart';
import 'package:gogrocy/core/models/order_details_arguments.dart';
import 'package:gogrocy/core/services/navigation_service.dart';
import 'package:gogrocy/core/viewModels/order_list_model.dart';
import 'package:gogrocy/service_locator.dart';
import 'package:gogrocy/ui/views/base_view.dart';
import 'package:gogrocy/ui/widgets/appbars/main_appbar.dart';
import 'package:gogrocy/ui/shared/colors.dart' as colors;
import 'package:gogrocy/ui/shared/constants.dart' as constants;

class OrderView extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigationService.goBack();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: MainAppBar(),
          body: BaseView<OrderViewModel>(
            onModelReady: (model) {
              model.getOrders();
            },
            builder: (context, model, child) {
              if (model.state == ViewState.Busy)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                if (model.orders.empty)
                  return emptyOrders();
                else
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: <Widget>[
                              Image.asset("assets/images/orders.png"),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Orders",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemCount: model.orders.result.bills.length,
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemBuilder: (context, index) {
                                String time = model.orders.result.bills[index]
                                    .details[0].orderDate;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Order number " +
                                                model.orders.result.bills[index]
                                                    .billId,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("Order placed on " +
                                              getDate(time) +
                                              " " +
                                              getMonth(time) +
                                              " " +
                                              getYear(time)),
                                          Text("Grand total " +
                                              totalCost(model.orders.result
                                                  .bills[index].details)),
                                          Text(model.orders.result.bills[index]
                                                  .details.length
                                                  .toString() +
                                              "  items"),
                                          //orderStatus(int.parse(model.orders.result.bills[index].details[0].status)),
                                        ],
                                      ),
                                      RawMaterialButton(
                                        elevation: 0.0,
                                        onPressed: () {
                                          /*if (model.orders.result.bills[index]
                                                  .details[0].status !=
                                              '-1')*/
                                          _navigationService.navigateTo(
                                              'orderDetails',
                                              arguments: OrderDetailsArguments(
                                                  orders: model.orders,
                                                  index: index));
                                        },
                                        fillColor:
                                            colors.viewAllButtonBackground,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Details',
                                            style: TextStyle(
                                                color: colors.viewAllButtonText,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  String getDate(String time) {
    return time.substring(8, 10);
  }

  String getMonth(String time) {
    String monthNo = time.substring(5, 7);
    print(monthNo);
    switch (monthNo) {
      case "01":
        return "Jan";
      case "02":
        return "Feb";
      case "03":
        return "Mar";
      case "04":
        return "Apr";
      case "05":
        return "May";
      case "06":
        return "Jun";
      case "07":
        return "Jul";
      case "08":
        return "Aug";
      case "09":
        return "Sept";
      case "10":
        return "Oct";
      case "11":
        return "Nov";
      case "12":
        return "Dec";
      default:
        return "Invalid month";
    }
  }

  String getYear(String time) {
    return time.substring(0, 4);
  }

  String totalCost(List<Details> list) {
    double totalCost = 0;
    for (int i = 0; i < list.length; i++) {
      totalCost += double.parse(list[i].price) * double.parse(list[i].orderQty);
    }
    totalCost = totalCost > 499 ? totalCost : totalCost + constants.deliveryCharges;
    return "₹ " + totalCost.toString();
  }

  Widget emptyOrders() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: 0.146 * constants.screenWidth,
              height: 0.146 * constants.screenWidth,
              child: Image(
                image: AssetImage("assets/images/no_products.png"),
              )),
          Text(
            "You don't have any orders",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 0.044 * constants.screenWidth,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
