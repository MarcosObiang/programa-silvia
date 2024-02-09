// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stockcontrollerterminal/Utils/dependency_injection/dependency_injection.dart';
import 'package:stockcontrollerterminal/features/departmentReport/presentation/Widgets/Screen.dart';
import 'package:stockcontrollerterminal/features/departments/departmentEntity.dart';
import 'package:stockcontrollerterminal/features/departments/presentation/presentationManager.dart';

class DepartmentScreen extends StatefulWidget {
  static String routeName = "/DepartmentScreen";

  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  bool showMultipleStockUpdateButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: Dependencies.departmentPresentationManager,
        child: Consumer<DepartmentPresentationManager>(builder:
            (BuildContext context,
                DepartmentPresentationManager departmentPresentationManager,
                Widget? child) {
          return Padding(
            padding: EdgeInsets.all(50).w,
            child: Center(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Departamentos",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 12,
                        fit: FlexFit.tight,
                        child: DataTable2(
                          showCheckboxColumn: true,
                          columns: [
                            DataColumn2(
                              label: Text(
                                "Departamento",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            DataColumn2(
                              label: Text(
                                "Identificador",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            DataColumn2(
                              label: Text(
                                "Entradas",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            DataColumn2(
                              label: Text(
                                "Salidas",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            DataColumn2(
                              label: Text(
                                "",
                              ),
                            ),
                            DataColumn2(
                              label: Text(
                                "",
                              ),
                            ),
                          ],
                          rows: List.generate(
                              departmentPresentationManager
                                  .departmentController.departmentList.length,
                              (index) => customDataCell(
                                  departmentPresentationManager:
                                      departmentPresentationManager,
                                  departmentEntity:
                                      departmentPresentationManager
                                          .departmentController
                                          .departmentList[index])),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                showDepartmentCreationDialog(
                                    departmentPresentationManager:
                                        departmentPresentationManager,
                                    buildContext: context);
                              },
                              icon: Icon(Icons.create),
                              label: Text("Crear departamento")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  DataRow customDataCell(
      {required DepartmentEntity departmentEntity,
      required DepartmentPresentationManager departmentPresentationManager}) {
    return DataRow(
        selected: departmentEntity.isDepartmenSelectedInTable,
        onSelectChanged: (value) {
          if (value != null) {
            if (value) {
              setState(() {});
              showMultipleStockUpdateButton = true;
              departmentPresentationManager.departmentController
                  .selectDepartment(
                      departmentId: departmentEntity.departmentId);
            } else {
              setState(() {});
              showMultipleStockUpdateButton = false;
              departmentPresentationManager.departmentController
                  .unselectDepartment(
                      departmentId: departmentEntity.departmentId);
            }
          }
        },
        cells: [
          DataCell(Text(departmentEntity.departmentName)),
          DataCell(Text(departmentEntity.departmentId)),
          DataCell(Text(departmentEntity.productAddCount.toString())),
          DataCell(Text(departmentEntity.productWithdrawlCount.toString())),
          DataCell(IconButton(onPressed: () {}, icon: Icon(Icons.delete))),
          DataCell(TextButton(
              onPressed: () {
                showSingleDepartmentReport(
                    departmentId: departmentEntity.departmentId,
                    productName: departmentEntity.departmentName,
                    initialDate: DateTime.now());
              },
              child: Text("Informe"))),
        ]);
  }

  void showSingleDepartmentReport(
      {required String departmentId,
      required String productName,
      required DateTime initialDate}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DepartmentReportScreen(
                  initialDate: initialDate,
                  productId: departmentId,
                  productName: productName,
                )));
  }

  void showDepartmentCreationDialog(
      {required DepartmentPresentationManager departmentPresentationManager,
      required BuildContext buildContext}) {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
        context: context,
        builder: ((buildContext) {
          return AlertDialog(
              content: StatefulBuilder(builder: (buildContext, setState) {
            return SizedBox(
              height: 300.h,
              width: 500.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Crear departaments")),
                  CupertinoTextField(
                    controller: textEditingController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            departmentPresentationManager.createDepartment(
                                departmentEntity: DepartmentEntity(
                                    departmentCreationDate: DateTime.now(),
                                    departmentName: textEditingController.text,
                                    departmentId: ""));
                          },
                          icon: Icon(Icons.check),
                          label: Text("Aceptar")),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.exit_to_app),
                          label: Text("Atrás")),
                    ],
                  )
                ],
              ),
            );
          }));
        }));
  }
}
