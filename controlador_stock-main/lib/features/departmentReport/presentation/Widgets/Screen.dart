import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:stockcontrollerterminal/Utils/dependency_injection/dependency_injection.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportDetailsEntity.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportEntity.dart';
import 'package:stockcontrollerterminal/features/departmentReport/presentation/presentation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class DepartmentReportScreen extends StatefulWidget {
  String productName;
  String productId;
  DateTime initialDate;
  DepartmentReportScreen(
      {required this.productName,
      required this.productId,
      required this.initialDate});
  @override
  State<DepartmentReportScreen> createState() => _DepartmentReportScreenState();
}

class _DepartmentReportScreenState extends State<DepartmentReportScreen> {
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
    Dependencies.departmentReportPresentatorManager.departmentReportController
        .clearReportMemory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Dependencies.departmentReportPresentatorManager,
      child: Consumer<DepartmentReportCreatorPresentationManager>(builder:
          (BuildContext context,
              DepartmentReportCreatorPresentationManager
                  departmentReportCreatorPresentationManager,
              Widget? child) {
        return Material(
          color: Colors.red,
          child: Container(
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)),
                            Text(
                              "Informe de departamento",
                              style: TextStyle(fontSize: 30.sp),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                                label:
                                    Text("Desde ${format.format(fromDate!)}"),
                                onPressed: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate:widget.initialDate,
                                      firstDate: widget.initialDate,
                                      lastDate: DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      fromDate = date;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.calendar_today)),
                            TextButton.icon(
                                label: Text("Hasta ${format.format(toDate!)}"),
                                onPressed: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: toDate!,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now());
                                  if (date != null) {
                                    setState(() {
                                      toDate = date;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.calendar_today)),
                            ElevatedButton(
                                onPressed: () async {
                                  departmentReportCreatorPresentationManager
                                      .getProductReport(
                                          departmentId: widget.productId,
                                          fromDate: fromDate,
                                          toDate: toDate);
                                },
                                child: const Text("Crear informe"))
                          ],
                        ),
                      ),
                      departmentReportListWidget(
                          departmentReportCreatorPresentationManager)
                    ],
                  ),
                ),
                departmentReportCreatorPresentationManager
                            .createDepartmentReportState ==
                        CreateDepartmentReportState.loading
                    ? SizedBox.expand(
                        child: Container(
                            color: const Color.fromARGB(91, 0, 0, 0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 200.h,
                                    width: 200.h,
                                    child: const LoadingIndicator(
                                        indicatorType: Indicator.ballScale),
                                  ),
                                  const Text(
                                    "Cargando",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        );
      }),
    );
  }

  Flexible departmentReportListWidget(
      DepartmentReportCreatorPresentationManager manager) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 8,
      child: SizedBox.expand(
          child: SingleChildScrollView(
        child: ExpansionPanelList(
          children: manager.departmentReportController.departmentReports
              .map<ExpansionPanel>(
                  (DepartmentReportEntity departmentReportEntity) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(departmentReportEntity.departmentName),
                      Padding(
                        padding: EdgeInsets.only(left: 50.w, right: 50.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Desde:  ${format.format(fromDate!)}"),
                            Padding(padding: EdgeInsets.only(left: 50.w)),
                            Text("Hasta:  ${format.format(toDate!)}"),
                          ],
                        ),
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
                          DataColumn2(label: Text("Producto")),
                          DataColumn2(label: Text("Tipo")),
                          DataColumn2(
                              label: Text("Stock\nantes de movimiento")),
                          DataColumn2(
                              label: Text("Stock\ndespues de movimiento")),
                          DataColumn2(label: Text("Retirada")),
                          DataColumn2(label: Text("Entrada"))
                        ],
                        rows: departmentReportEntity.reportDetails
                            .map<DataRow2>((DepartmentReportDetailsEntity
                                reportDetailsEntity) {
                          return DataRow2(
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
                                DataCell(Text(format.format(
                                    reportDetailsEntity.changeDateTime))),
                                DataCell(Text(reportDetailsEntity.changedBy)),
                                DataCell(Text(reportDetailsEntity.productName)),
                                DataCell(Text(reportDetailsEntity.changeType)),
                                DataCell(Text(reportDetailsEntity
                                    .productCountBeforeChange
                                    .toString())),
                                DataCell(Text(reportDetailsEntity
                                    .productCountAfterChange
                                    .toString())),
                                DataCell(reportDetailsEntity.changeType ==
                                        "WITHDRAWL_PRODUCT"
                                    ? Text(((reportDetailsEntity
                                                    .productCountAfterChange -
                                                reportDetailsEntity
                                                    .productCountBeforeChange)
                                            .abs())
                                        .toString())
                                    : const Text("--")),
                                DataCell(reportDetailsEntity.changeType ==
                                        "ADD_PRODUCT"
                                    ? Text(((reportDetailsEntity
                                                    .productCountBeforeChange -
                                                reportDetailsEntity
                                                    .productCountAfterChange)
                                            .abs())
                                        .toString())
                                    : const Text("--"))
                              ]);
                        }).toList(),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        fit: FlexFit.loose,
                        child: SizedBox(
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    manager.getMoreReports(
                                        departmentId:
                                            departmentReportEntity.departmentId,
                                        fromDate: fromDate as DateTime,
                                        toDate: toDate as DateTime);
                                  },
                                  icon: const Icon(Icons.print),
                                  label: const Text("Cargar mas movimientos")),
                              Padding(padding: EdgeInsets.only(left: 100.w)),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PrintPDFDepScreen(
                                                    reportDetails:
                                                        departmentReportEntity
                                                            .reportDetails)));
                                  },
                                  icon: const Icon(Icons.print),
                                  label: const Text("Imprimir informe")),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              isExpanded: true,
            );
          }).toList(),
        ),
      )),
    );
  }
}

class PrintPDFDepScreen extends StatefulWidget {
  List<DepartmentReportDetailsEntity> reportDetails;
  PrintPDFDepScreen({required this.reportDetails});

  @override
  State<PrintPDFDepScreen> createState() => _PrintPDFDepScreenState();
}

class _PrintPDFDepScreenState extends State<PrintPDFDepScreen> {
  var format = DateFormat("dd/MM/y");
  @override
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
            responsible: widget
                .reportDetails[cellToPrintAcumulator - index - 1].changedBy,
            movementType: widget
                .reportDetails[cellToPrintAcumulator - index - 1].changeType,
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
                        pw.Text("Responsable",
                            style: pw.TextStyle(fontSize: 7)),
                        pw.Text("Tipo movimiento",
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
      pw.Text("Responsable", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Producto", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Tipo movimiento", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Antes retirada", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Despues retirada", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Retirada", style: pw.TextStyle(fontSize: 6)),
      pw.Text("Entrada", style: pw.TextStyle(fontSize: 6)),
    ]);
  }

  pw.TableRow tableRow({
    required DateTime date,
    required String responsible,
    required String movementType,
    required int beforeCount,
    required int afterCount,
  }) {
    return pw.TableRow(children: [
      pw.Text(format.format(date), style: pw.TextStyle(fontSize: 5)),
      pw.Text(responsible, style: pw.TextStyle(fontSize: 5)),
      pw.Text(movementType, style: pw.TextStyle(fontSize: 5)),
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
