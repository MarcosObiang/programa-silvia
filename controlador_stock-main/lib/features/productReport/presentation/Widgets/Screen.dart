// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors
import 'dart:ffi';

import 'package:cr_calendar/src/cr_calendar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stockcontrollerterminal/Utils/dependency_injection/dependency_injection.dart';
import 'package:stockcontrollerterminal/features/productReport/presentation/presentation.dart';
import 'package:stockcontrollerterminal/features/productReport/productRepoEntity.dart';
import 'package:stockcontrollerterminal/features/productReport/reportDetailsEntity.dart';

class ProductReportScreen extends StatefulWidget {
  String productName;
  String productId;
  DateTime initialDate;
  ProductReportScreen(
      {required this.productName,
      required this.productId,
      required this.initialDate});

  @override
  State<ProductReportScreen> createState() => _ProductReportScreenState();
}

class _ProductReportScreenState extends State<ProductReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  var format = DateFormat("dd/MM/y");

  @override
  void initState() {
    fromDate = widget.initialDate;
    toDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    Dependencies.productReportCreatorPresentationManager.clearReports();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Dependencies.productReportCreatorPresentationManager,
      child: Consumer<ProductReportCreatorPresentationManager>(builder:
          (BuildContext context,
              ProductReportCreatorPresentationManager
                  productReportCreatorPresentationManager,
              Widget? child) {
        return Material(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppBar(
                        title: Text("Informe de producto"),
                      ),
                      dateSelectBar(
                          context, productReportCreatorPresentationManager),
                      reportListWidget(
                          productReportCreatorPresentationManager, context)
                    ],
                  ),
                ),
                productReportCreatorPresentationManager
                            .createProductReportState ==
                        CreateProductReportState.loading
                    ? SizedBox.expand(
                        child: Container(
                            color: Color.fromARGB(19, 0, 0, 0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 200.h,
                                    width: 200.h,
                                    child: LoadingIndicator(
                                        indicatorType: Indicator.ballScale),
                                  ),
                                  Text(
                                    "Cargando",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Flexible reportListWidget(
      ProductReportCreatorPresentationManager
          productReportCreatorPresentationManager,
      BuildContext context) {
    return Flexible(
        flex: 7,
        fit: FlexFit.loose,
        child: SingleChildScrollView(
          child: ExpansionPanelList(
            children: productReportCreatorPresentationManager
                .productReportController.reportList
                .map<ExpansionPanel>((ProductReportEntity productReportEntity) {
              return ExpansionPanel(
                  isExpanded: true,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Nombre producto:      "),
                              productReportEntity.productName != null
                                  ? Text(productReportEntity.productName!)
                                  : Text(""),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  "   Desde: ${format.format(productReportEntity.fromDate!)}      "),
                              Text(
                                  "   Hasta: ${format.format(productReportEntity.toDate!)}        ")
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  body: SizedBox(
                    height: 500.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 9,
                          fit: FlexFit.tight,
                          child: DataTable2(
                              columns: const [
                                DataColumn2(label: Text("Fecha")),
                                DataColumn2(label: Text("Responsable")),
                                DataColumn2(label: Text("Departamento")),
                                DataColumn2(
                                  label: Text("Tipo movimiento"),
                                ),
                                DataColumn2(
                                    label: Text("Stock\nantes de movimiento")),
                                DataColumn2(
                                    label:
                                        Text("Stock\ndespues de movimiento")),
                                DataColumn2(label: Text("Retirada")),
                                DataColumn2(label: Text("Entrada"))
                              ],
                              rows: List.generate(
                                  productReportEntity.reportDetails!.length,
                                  (index) => customDataCellReport(
                                      reportDetailsEntity: productReportEntity
                                          .reportDetails![index]))),
                        ),
                        Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: SizedBox(
                              child: Row(
                                children: [
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        productReportCreatorPresentationManager
                                            .getMoreReports(
                                                productId: productReportEntity
                                                    .productId!,
                                                fromDate: fromDate!,
                                                toDate: toDate!);
                                      },
                                      icon: Icon(Icons.print),
                                      label: Text("Caargar mas detalles")),
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PrintPDFScreen(
                                                      reportDetails:
                                                          productReportEntity
                                                              .reportDetails!,
                                                    )));
                                      },
                                      icon: Icon(Icons.print),
                                      label: Text("Imprimir informe")),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ));
            }).toList(),
          ),
        ));
  }

  Flexible dateSelectBar(
      BuildContext context,
      ProductReportCreatorPresentationManager
          productReportCreatorPresentationManager) {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
                icon: Icon(Icons.calendar_month_sharp),
                onPressed: () async {
                  fromDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: widget.initialDate,
                      lastDate: DateTime.now());

                  fromDate ??= widget.initialDate;
                  setState(() {});
                },
                label: Text("Desde ${format.format(fromDate as DateTime)}")),
            TextButton.icon(
                icon: Icon(Icons.calendar_month_sharp),
                onPressed: () async {
                  toDate = await showDatePicker(
                      context: context,
                      firstDate: fromDate as DateTime,
                      lastDate: DateTime.now());

                  toDate ??= DateTime.now();
                  setState(() {});
                },
                label: Text("Hasta ${format.format(toDate as DateTime)}")),
            ElevatedButton(
                onPressed: () {
                  productReportCreatorPresentationManager.getProductReport(
                      productId: widget.productId,
                      fromDate: fromDate,
                      toDate: toDate);
                },
                child: Text("Crear Informe")),
          ],
        ),
      ),
    );
  }

  DataRow customDataCellReport(
      {required ReportDetailsEntity reportDetailsEntity,
      productViewerPresentationManager}) {
    var format = DateFormat("d/M/y HH:mm");

    return DataRow(
        selected: false,
        onSelectChanged: (value) {
          if (value != null) {
            if (value) {
              setState(() {});
            } else {
              setState(() {});
            }
          }
        },
        cells: [
          DataCell(Text(format.format(reportDetailsEntity.changeDateTime))),
          DataCell(Text(reportDetailsEntity.changedBy)),
          DataCell(Text(reportDetailsEntity.departments!["departmentName"])),
          DataCell(Text(reportDetailsEntity.changeType)),
          DataCell(
              Text(reportDetailsEntity.productCountBeforeChange.toString())),
          DataCell(
              Text(reportDetailsEntity.productCountAfterChange.toString())),
          DataCell(reportDetailsEntity.changeType == "WITHDRAWL_PRODUCT"
              ? Text(((reportDetailsEntity.productCountAfterChange -
                          reportDetailsEntity.productCountBeforeChange)
                      .abs())
                  .toString())
              : Text("--")),
          DataCell(reportDetailsEntity.changeType == "ADD_PRODUCT"
              ? Text(((reportDetailsEntity.productCountBeforeChange -
                          reportDetailsEntity.productCountAfterChange)
                      .abs())
                  .toString())
              : Text("--"))
        ]);
  }
}

class PrintPDFScreen extends StatefulWidget {
  List<ReportDetailsEntity> reportDetails;
  PrintPDFScreen({required this.reportDetails});

  @override
  State<PrintPDFScreen> createState() => _PrintPDFScreenState();
}

class _PrintPDFScreenState extends State<PrintPDFScreen> {
  var dateFormat = DateFormat("dd/MM/y HH:mm");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton.outlined(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back)),
          title: Text("Vista previa de informe"),
        ),
        body: PdfPreview(
          padding: EdgeInsets.all(100).w,
          build: (format) => _generatePdf(
            format,
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
    );
    int movementsNumber = widget.reportDetails.length;
    int cellToPrint = 0;
    int maxCells = 35;
    int cellToPrintAcumulator = 0;
    for (int i = 0; movementsNumber > 0; i++) {
      cellToPrint = 0;
      if (movementsNumber >= maxCells) {
        cellToPrint = maxCells;
        movementsNumber = movementsNumber - maxCells;
        cellToPrintAcumulator += cellToPrint;
      } else {
        cellToPrint = movementsNumber;
        movementsNumber = 0;
        cellToPrintAcumulator += cellToPrint;
      }

      List<pw.TableRow> dataList = List.generate(
        cellToPrint,
        (index) => tableRow(
            date: widget.reportDetails[cellToPrintAcumulator - index - 1]
                .changeDateTime,
            department: widget.reportDetails[cellToPrintAcumulator - index - 1]
                .departments!["departmentName"] as String,
            movementType: widget
                .reportDetails[cellToPrintAcumulator - index - 1].changeType,
            movedBy: widget
                .reportDetails[cellToPrintAcumulator - index - 1].changedBy,
            beforeCount: widget.reportDetails[cellToPrintAcumulator - index - 1]
                .productCountBeforeChange,
            afterCount: widget.reportDetails[cellToPrintAcumulator - index - 1]
                .productCountAfterChange),
      ).reversed.toList();
      pdf.addPage(
        pw.Page(
          pageFormat: format,
          margin: pw.EdgeInsets.all(5),
          build: (context) {
            if (kDebugMode) {
              print(format);
            }
            return pw.SizedBox.expand(
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Center(
                      child: pw.Text("Informe movimientos stock",
                          style: pw.TextStyle(fontSize: 20.sp)),
                    ),
                    pw.SizedBox.expand(
                        child: pw.Table(children: [
                      pw.TableRow(children: [
                        pw.Text("Fecha", style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Departamento",
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Tipo movimiento",
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Responsable",
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Antes", style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Despues", style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Retirada", style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Entrada", style: pw.TextStyle(fontSize: 7)),
                      ]),
                      ...dataList
                    ])),
                    pw.SizedBox(
                      child: pw.Center(
                        child: pw.Text("Página ${i.toString()}",
                            style: pw.TextStyle(fontSize: 10.sp)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  pw.TableRow firstTableRow() {
    return pw.TableRow(children: [
      pw.Text("Fecha", style: pw.TextStyle(fontSize: 7)),
      pw.Text("Departamento", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Tipo movimiento", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Retirado por", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Antes retirada", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Despues retirada", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Retirada", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Entrada", style: pw.TextStyle(fontSize: 6)),
    ]);
  }

  pw.TableRow tableRow({
    required DateTime date,
    required String department,
    required String movementType,
    required String movedBy,
    required int beforeCount,
    required int afterCount,
  }) {
    return pw.TableRow(children: [
      pw.Text(dateFormat.format(date), style: pw.TextStyle(fontSize: 5)),
      pw.Text(department, style: pw.TextStyle(fontSize: 5)),
      pw.Text(movementType, style: pw.TextStyle(fontSize: 5)),
      pw.Text(movedBy, style: pw.TextStyle(fontSize: 5)),
      pw.Text(beforeCount.toString(), style: pw.TextStyle(fontSize: 5)),
      pw.Text(afterCount.toString(), style: pw.TextStyle(fontSize: 5)),
      movementType == "WITHDRAWL_PRODUCT"
          ? pw.Text((beforeCount - afterCount).toString(),
              style: pw.TextStyle(fontSize: 5))
          : pw.Text("--", style: pw.TextStyle(fontSize: 5)),
      movementType == "ADD_PRODUCT"
          ? pw.Text((afterCount - beforeCount).toString(),
              style: pw.TextStyle(fontSize: 5))
          : pw.Text("--", style: pw.TextStyle(fontSize: 5)),
    ]);
  }
}
