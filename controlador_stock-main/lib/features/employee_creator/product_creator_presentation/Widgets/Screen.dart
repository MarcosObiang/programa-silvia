// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stockcontrollerterminal/Utils/dependency_injection/dependency_injection.dart';
import 'package:stockcontrollerterminal/features/employee_creator/product_creator_presentation/product_creator_presentation_manager.dart';

class ProductCreatorScreen extends StatefulWidget {
  static String routeName = "/ProductCreatorScreen";

  const ProductCreatorScreen();

  @override
  State<ProductCreatorScreen> createState() => _ProductCreatorScreenState();
}

class _ProductCreatorScreenState extends State<ProductCreatorScreen> {
  String productName = "";
  String productId = "";
  int productCount = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Dependencies.productCreatorPresentatorManager,
      child: Consumer<ProductCreatorPresentatorManager>(builder:
          (BuildContext context,
              ProductCreatorPresentatorManager productCreatorPresentatorManager,
              Widget? child) {
        return Material(
          color: Theme.of(context).colorScheme.surface,
          child: SizedBox(
            height: ScreenUtil().screenHeight / 1.5,
            width: ScreenUtil().screenWidth / 1.5,
            child: Padding(
              padding: EdgeInsets.all(30).w,
              child: productCreatorPresentatorManager
                          .createProductProcessState ==
                      CreateProductProcessState.not_loadiing
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.loose,
                          child: Text(
                            "Agrega un producto",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.apply(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          fit: FlexFit.tight,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa un nombre';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer), // Cambia 'Colors.red' al color que desees
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // Agrega esta línea
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    labelText: "Nombre del prodcuto",
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.apply(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                  onChanged: (value) => productName = value,
                                ),
                                Divider(
                                  height: 30.h,
                                  color: Colors.transparent,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa un identificador';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface), // Cambia 'Colors.red' al color que desees
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // Agrega esta línea
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    labelText: "Identificador",
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.apply(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                  onChanged: (value) => productId = value,
                                ),
                                Divider(
                                  height: 30.h,
                                  color: Colors.transparent,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa una cantidad';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  cursorColor: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors
                                              .red), // Cambia 'Colors.red' al color que desees
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // Agrega esta línea
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    labelText: "Cantidad",
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.apply(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                  onChanged: (value) =>
                                      productCount = int.parse(value),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            productCreatorPresentatorManager
                                                .createProduct(
                                                    productName: productName,
                                                    productId: productId,
                                                    productCount: productCount);
                                          }
                                        },
                                        icon: Icon(Icons.done),
                                        label: Text("Crear producto")),
                                    Padding(
                                        padding: EdgeInsets.only(left: 30.w)),
                                    ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close),
                                        label: Text("Cancelar"))
                                  ],
                                ),
                              ),
                            ))
                      ],
                    )
                  : productCreatorPresentatorManager
                              .createProductProcessState ==
                          CreateProductProcessState.loading
                      ? SizedBox(
                          child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200.h,
                                width: 200.h,
                                child: LoadingIndicator(
                                    indicatorType: Indicator.ballScaleMultiple),
                              ),
                              Text(
                                "Cargando",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.apply(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeightDelta: 2),
                              ),
                            ],
                          ),
                        ))
                      : Container(),
            ),
          ),
        );
      }),
    );
  }
}
