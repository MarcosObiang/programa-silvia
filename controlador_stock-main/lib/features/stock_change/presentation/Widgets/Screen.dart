// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stockcontrollerterminal/Utils/dependency_injection/dependency_injection.dart';
import 'package:stockcontrollerterminal/features/productViewer/ProductEntity.dart';
import 'package:stockcontrollerterminal/features/stock_change/presentation/stock_changer_presentation_manager.dart';
import 'package:stockcontrollerterminal/features/stock_change/stockChangeEntity.dart';

class StockChangerScreen extends StatefulWidget {
  ///  Cada mapa debe contener:
  ///
  ///  {"productName":productName,
  ///
  /// "productId":productId,
  ///

  ///
  /// "productsCount":productsCount}
  List<String> productsToChange;
  StockChangerScreen({required this.productsToChange});

  @override
  State<StockChangerScreen> createState() => _StockChangerScreenState();
}

class _StockChangerScreenState extends State<StockChangerScreen> {
  String departmentSelected = "Seleccionar departamento";
  final _formKey = GlobalKey<FormState>();
  final _tableFormKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeys = List.empty(growable: true);

  @override
  void initState() {
    departmentSelected = Dependencies
        .stockChangerPresentationManager
        .stockChangerController
        .departmentController
        .departmentList
        .first
        .departmentId;
    Dependencies.stockChangerPresentationManager
        .selectProductsToChange(productsToChange: widget.productsToChange);
    formKeys = List.generate(
        widget.productsToChange.length, (index) => GlobalKey<FormState>());

    super.initState();
  }

  @override
  void dispose() {
    Dependencies.stockChangerPresentationManager.unselectProductsToChange();
    super.dispose();
  }

  TextEditingController numericFieldTextEditingController =
      TextEditingController(text: "0");
  TextEditingController changedByTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: ChangeNotifierProvider.value(
        value: Dependencies.stockChangerPresentationManager,
        child: Consumer<StockChangerPresentationManager>(builder:
            (BuildContext context,
                StockChangerPresentationManager stockChangerPresentationManager,
                Widget? child) {
          return Center(
            child: SizedBox(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: stockChangerPresentationManager
                            .changeStockProcessState ==
                        ChangeStockProcessState.not_loading
                    ? Column(
                        children: [
                          SizedBox(
                            height: kBottomNavigationBarHeight,
                            child: AppBar(
                              title: Text("Actualizar inventario"),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Departamento     ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.apply(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .onBackground)),
                                              SizedBox(
                                                  child: DropdownButton(
                                                      hint: Text(
                                                          departmentSelected,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.apply(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onBackground)),
                                                      dropdownColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .background,
                                                      value: departmentSelected,
                                                      items: List.generate(
                                                          stockChangerPresentationManager
                                                              .stockChangerController
                                                              .departmentController
                                                              .departmentList
                                                              .length, (index) {
                                                        return departmentDropDown(
                                                            departmentData: {
                                                              "departmentName": stockChangerPresentationManager
                                                                  .stockChangerController
                                                                  .departmentController
                                                                  .departmentList[
                                                                      index]
                                                                  .departmentName,
                                                              "departmentId": stockChangerPresentationManager
                                                                  .stockChangerController
                                                                  .departmentController
                                                                  .departmentList[
                                                                      index]
                                                                  .departmentId
                                                            });
                                                      }),
                                                      onChanged:
                                                          (dropDownValue) {
                                                        departmentSelected =
                                                            dropDownValue ??
                                                                "Seleccionar departamento";
                                                        setState(() {});
                                                      })),
                                            ],
                                          ),
                                          VerticalDivider(
                                            color: Colors.transparent,
                                            width: 100.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Responsable   ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.apply(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground),
                                              ),
                                              SizedBox(
                                                  height: 100.h,
                                                  width: 500.w,
                                                  child: Form(
                                                    key: _formKey,
                                                    child: TextFormField(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.apply(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onBackground),
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "¿Quien retira el producto?",
                                                          fillColor:
                                                              Colors.white),
                                                      controller:
                                                          changedByTextEditingController,
                                                      validator: (value) => value!
                                                              .isEmpty
                                                          ? "El campo '¿Quien retira el producto?' no puede estar vacio"
                                                          : null,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                Flexible(
                                  flex: 8,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.5),
                                            width: 1),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.w,
                                          right: 10.w,
                                          top: 10.h,
                                          bottom: 10.h),
                                      child: DataTable2(
                                          columns: [
                                            DataColumn2(
                                              size: ColumnSize.L,
                                              label: Text(
                                                "Producto",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.apply(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground),
                                              ),
                                            ),
                                            DataColumn2(
                                              size: ColumnSize.S,
                                              label: Text(
                                                "Identificador",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.apply(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground),
                                              ),
                                            ),
                                            DataColumn2(
                                              size: ColumnSize.S,
                                              label: Text(
                                                "En stock",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.apply(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground),
                                              ),
                                            ),
                                            DataColumn2(
                                              size: ColumnSize.S,
                                              label: Text(
                                                "Accion",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.apply(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground),
                                              ),
                                            ),
                                            DataColumn2(
                                              size: ColumnSize.S,
                                              label: Text(
                                                "Cantidad",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.apply(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground),
                                              ),
                                            ),
                                          ],
                                          rows: List.generate(
                                              widget.productsToChange.length,
                                              (index) {
                                            if (stockChangerPresentationManager
                                                    .stockChangerController
                                                    .productStockChangeList[
                                                        index]
                                                    .productSelectedToBeChanged !=
                                                null) {
                                              if (stockChangerPresentationManager
                                                  .stockChangerController
                                                  .productStockChangeList[index]
                                                  .productSelectedToBeChanged!) {
                                                return customDataCell(
                                                    stockChangerPresentationManager:
                                                        stockChangerPresentationManager,
                                                    productData:
                                                        stockChangerPresentationManager
                                                            .stockChangerController
                                                            .productStockChangeList[index],
                                                    formKey: formKeys[index]);
                                              } else {
                                                return emptyDataCell();
                                              }
                                            } else {
                                              return emptyDataCell();
                                            }
                                          })),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: ElevatedButton.icon(
                                              onPressed: () {
                                                bool areTablesValid =
                                                    validateForms();

                                                if (_formKey.currentState!
                                                            .validate() ==
                                                        true &&
                                                    areTablesValid) {
                                                  stockChangerPresentationManager
                                                      .changeStock(
                                                          changedBy:
                                                              changedByTextEditingController
                                                                  .text,
                                                          departmentId:
                                                              departmentSelected);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              icon: Icon(Icons.refresh_sharp),
                                              label: Text("Actualizar")),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 300.h,
                                width: 300.h,
                                child: LoadingIndicator(
                                    indicatorType: Indicator.ballScaleMultiple),
                              ),
                              Text("Cargando",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.apply(color: Colors.white))
                            ]),
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  bool validateForms() {
    bool isValid = true;
    for (var element in formKeys) {
      if (!element.currentState!.validate()) {
        isValid = false;
      }
    }
    return isValid;
  }

  DropdownMenuItem<String> departmentDropDown(
      {required Map<String, dynamic> departmentData}) {
    String departmentName = departmentData["departmentName"];
    String departmentId = departmentData["departmentId"];
    return DropdownMenuItem<String>(
      value: departmentId,
      child: Text(departmentName,
          style: Theme.of(context).textTheme.bodyLarge?.apply(
              color: Theme.of(context).colorScheme.onSecondaryContainer)),
    );
  }

  DataRow emptyDataCell() {
    return const DataRow(cells: [
      DataCell.empty,
      DataCell.empty,
      DataCell.empty,
      DataCell.empty,
      DataCell.empty,
    ]);
  }

  DataRow customDataCell(
      {required StockChangeEntity productData,
      required StockChangerPresentationManager stockChangerPresentationManager,
      required GlobalKey<FormState> formKey}) {
    TextEditingController countTextController = TextEditingController();
    String productName = productData.productName;
    String productId = productData.productId;
    int productCount = productData.productCount;
    String retire = ChangeType.RETIRE.name;
    String add = ChangeType.ADD.name;
    String selectType = ChangeType.ADD.name;
    String changeType = productData.changeType!;

    var format = DateFormat("d/M/y HH:mm");

    return DataRow(cells: [
      DataCell(SizedBox(
        height: 500.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(productName,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.apply(color: Theme.of(context).colorScheme.onBackground)),
        ),
      )),
      DataCell(SizedBox(
        height: 500.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(productId,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.apply(color: Theme.of(context).colorScheme.onBackground)),
        ),
      )),
      DataCell(SizedBox(
        height: 500.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(productCount.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.apply(color: Theme.of(context).colorScheme.onBackground)),
        ),
      )),
      DataCell(SizedBox(
        height: 500.h,
        child: DropdownButton(
            borderRadius: BorderRadius.circular(10),
            elevation: 1,
            dropdownColor: Theme.of(context).colorScheme.surface,
            value: changeType,
            items: [
              DropdownMenuItem<String>(
                value: add,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Entrada",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.apply(color: Colors.green)),
                ),
              ),
              DropdownMenuItem<String>(
                  value: retire,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Retirada",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.apply(color: Colors.red)),
                  )),
            ],
            onChanged: (dropDownValue) {
              if (dropDownValue != null) {
                if (dropDownValue == ChangeType.ADD.name) {
                  productData.selectChangeType(changeType: ChangeType.ADD);
                } else {
                  productData.selectChangeType(changeType: ChangeType.RETIRE);
                }

                changeType = dropDownValue;
                setState(() {});
              }
            }),
      )),
      DataCell(SizedBox(
        height: 500.h,
        child: Form(
          key: formKey,
          child: TextFormField(
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.apply(color: Theme.of(context).colorScheme.onBackground),
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintText: "0",
            ),
            controller: countTextController,
            onChanged: (value) {
              if (num.parse(value) > productCount &&
                  changeType == ChangeType.RETIRE.name) {
                //   countTextController.text = "";
              } else {
                productData.amountToChange = int.parse(value);
              }
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value!.isEmpty) {
                print("object");
                return "El campo 'Cantidad' no puede estar vacio";
              } else {
                if (num.parse(value) > productCount &&
                    changeType == ChangeType.RETIRE.name) {
                  return "'Cantidad' no puede ser mayor a 'En stock'";
                } else if (num.parse(value) == 0) {
                  return "'Cantidad' no puede ser 0";
                } else if (num.parse(value) < 0) {
                  return "'Cantidad' no puede menor a 0";
                } else {
                  return null;
                }
              }
            },
          ),
        ),
      ))
    ]);
  }

  SizedBox stockChangeType() {
    return SizedBox(
      height: 100.h,
      child: Card(
        elevation: 3,
        child: Row(
          children: [
            Text("data"),
            Text("data"),
            DropdownButton(
                value: "valor 1",
                items: const [
                  DropdownMenuItem<String>(
                      value: "valor 1", child: Text("Entrada")),
                  DropdownMenuItem<String>(
                      value: "valor 2", child: Text("Retirada"))
                ],
                onChanged: (dropDownValue) {})
          ],
        ),
      ),
    );
  }
}
