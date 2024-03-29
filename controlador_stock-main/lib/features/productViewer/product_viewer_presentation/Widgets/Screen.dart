// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stockcontrollerterminal/Utils/dependency_injection/dependency_injection.dart';
import 'package:stockcontrollerterminal/features/departments/presentation/widgets/screen.dart';
import 'package:stockcontrollerterminal/features/employee_creator/product_creator_presentation/Widgets/Screen.dart';
import 'package:stockcontrollerterminal/features/productReport/presentation/Widgets/Screen.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/product_viewer_presentation_manager.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import '../../ProductEntity.dart';

late BuildContext maincontext;

class TabBarSystemView extends StatefulWidget {
  static String routeName = "/TabBarSystemViewScreen";

  const TabBarSystemView({super.key});

  @override
  State<TabBarSystemView> createState() => _TabBarSystemViewState();
}

class _TabBarSystemViewState extends State<TabBarSystemView> {
  int _currentIndex = 0;
  List<fluent_ui.NavigationPaneItem> items = List.empty(growable: true);
  @override
  void initState() {
    /* items.add(fluent_ui.PaneItemHeader(
        header: Container(
                  height: 200.h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://equatorialoil.com/wp-content/uploads/2022/04/Sonagas.jpg"))))));*/
    items.add(fluent_ui.PaneItem(
        icon: Icon(fluent_ui.FluentIcons.product),
        title: const Text("Productos"),
        body: ProductViewerScreen()));

    items.add(fluent_ui.PaneItem(
        body: DepartmentScreen(),
        icon: Icon(fluent_ui.FluentIcons.table),
        title: const Text("Departamentos")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maincontext = context;
    ScreenUtil.init(
      context,
      designSize: const Size(1920, 1080),
    );

    return MaterialApp(
      title: 'Onventario',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            fluent_ui.Padding(
              padding: EdgeInsets.all(8).w,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: fluent_ui.Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SideMenu(
                    hasResizer: false,
                    hasResizerToggle: false,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    mode: SideMenuMode.open,
                    builder: (data) {
                      return SideMenuData(
                        header: fluent_ui.Padding(
                          padding: EdgeInsets.all(10).w,
                          child: Container(
                              height: 200.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.white),
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: NetworkImage(
                                          "https://equatorialoil.com/wp-content/uploads/2022/04/Sonagas.jpg")))),
                        ),
                        items: [
                          SideMenuItemDataTile(
                            isSelected: _currentIndex == 0,
                            onTap: () => setState(() => _currentIndex = 0),
                            title: 'Productos',
                            borderRadius: BorderRadius.circular(5),
                            highlightSelectedColor:
                                Theme.of(context).colorScheme.background,
                            titleStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            selectedTitleStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            icon: Icon(
                              Icons.circle_outlined,
                              size: 15.sp,
                            ),
                            selectedIcon: Icon(
                              Icons.circle,
                              size: 20.sp,
                            ),
                          ),
                          SideMenuItemDataTile(
                            isSelected: _currentIndex == 1,
                            onTap: () => setState(() => _currentIndex = 1),
                            title: 'Departamentos',
                            borderRadius: BorderRadius.circular(5),
                            highlightSelectedColor:
                                Theme.of(context).colorScheme.background,
                            titleStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            selectedTitleStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            icon: Icon(
                              Icons.circle_outlined,
                              size: 15.sp,
                            ),
                            selectedIcon: Icon(
                              Icons.circle,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
                child: IndexedStack(
              index: _currentIndex,
              children: [
                const ProductViewerScreen(),
                const DepartmentScreen(),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class ProductViewerScreen extends StatefulWidget {
  static String routeName = "/ProductViewScreen";

  const ProductViewerScreen({super.key});

  @override
  State<ProductViewerScreen> createState() => _ProductViewerScreenState();
}

class _ProductViewerScreenState extends State<ProductViewerScreen>
    with TickerProviderStateMixin {
  bool showMultipleStockUpdateButton = false;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: ChangeNotifierProvider.value(
          value: Dependencies.productViewerPresentationManager,
          child: Consumer<ProductViewerPresentationManager>(
            builder: (BuildContext buildContext,
                ProductViewerPresentationManager
                    productViewerPresentationManager,
                Widget? widget) {
              return SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.all(20).w,
                  child: Column(
                    children: [
                      Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: fluent_ui.Text(
                                  "Productos",
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: SizedBox(
                                  height: 50.h,
                                  width: 500.w,
                                  child: SearchField(
                                      hint:
                                          "Buscar producto por nombre o identificador",
                                      onSuggestionTap: (suggestionClicked) {
                                        productViewerPresentationManager
                                            .productViewerController
                                            .putSuggestionFirst(
                                                productId: suggestionClicked
                                                    .searchKey);
                                      },
                                      onSearchTextChanged: (value) {
                                        if (value.isNotEmpty) {
                                          productViewerPresentationManager
                                              .productViewerController
                                              .searchSuggestions(input: value);
                                        }
                                      },
                                      suggestions:
                                          productViewerPresentationManager
                                              .productViewerController
                                              .suggestionsList
                                              .map((e) => SearchFieldListItem(
                                                  e["productId"],
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(e["productName"]),
                                                        Text(e["productId"]),
                                                      ],
                                                    ),
                                                  )))
                                              .toList()),
                                ),
                              ),
                            ],
                          )),
                      Flexible(
                          flex: 12,
                          fit: FlexFit.tight,
                          child: Card(
                            elevation: 5,
                            shadowColor: Theme.of(context).colorScheme.primary,
                            borderOnForeground: true,
                            child: Padding(
                              padding: const EdgeInsets.all(10).w,
                              child: tablaProductos(
                                  productViewerPresentationManager, context),
                            ),
                          )),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.loose,
                        child: botonesPantallaProducto(
                            productViewerPresentationManager),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Center botonesPantallaProducto(
      ProductViewerPresentationManager productViewerPresentationManager) {
    return Center(
      child: Row(
        children: [
          showMultipleStockUpdateButton
              ? ElevatedButton.icon(
                  onPressed: () {
                    productViewerPresentationManager
                        .showStockChangeDialogWithMultipleProducts();
                  },
                  icon: const Icon(Icons.edit_attributes),
                  label: const Text("Actualizar productos"))
              : Container(),
          ElevatedButton.icon(
              onPressed: () {
                showAddProductDialog();
              },
              icon: const Icon(Icons.new_label),
              label: const Text("Nuevo producto")),
        ],
      ),
    );
  }

  DataTable2 tablaProductos(
      ProductViewerPresentationManager productViewerPresentationManager,
      BuildContext context) {
    return DataTable2(
        decoration: BoxDecoration(),
        showCheckboxColumn: true,
        onSelectAll: (value) {
          if (value != null) {
            if (value) {
              showMultipleStockUpdateButton = true;
              productViewerPresentationManager.productViewerController
                  .selectAllProducts();
            } else {
              showMultipleStockUpdateButton = false;
              productViewerPresentationManager.productViewerController
                  .unselectAllProducts();
            }
          }
        },
        columns: [
          DataColumn2(
            label: Text(
              "Nombre\nproducto",
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
            size: ColumnSize.S,
            label: Text(
              "Total\nentradas",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              "Total\nsalidas",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              "En stock",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              "",
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              "",
            ),
          ),
          DataColumn2(
            size: ColumnSize.S,
            label: Text(
              "",
            ),
          ),
        ],
        rows: List.generate(
            productViewerPresentationManager
                .productViewerController.productsList.length,
            (index) => customDataCell(
                productViewerPresentationManager:
                    productViewerPresentationManager,
                productentity: productViewerPresentationManager
                    .productViewerController.productsList[index])));
  }

  void showAddProductDialog() {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return ProductCreatorScreen();
              }));
        }));
  }

  void showDepartmentDialog() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DepartmentScreen()));
  }

  void showSingleProductReport(
      {required String prodcutId,
      required String productName,
      required DateTime initialDate}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductReportScreen(
                  initialDate: initialDate,
                  productId: prodcutId,
                  productName: productName,
                )));
  }

  DataRow customDataCell(
      {required ProductEntity productentity,
      required ProductViewerPresentationManager
          productViewerPresentationManager}) {
    var format = DateFormat("d/M/y HH:mm");

    return DataRow(
        selected: productentity.productSelected ?? false,
        onSelectChanged: (value) {
          if (value != null) {
            if (value) {
              setState(() {});
              showMultipleStockUpdateButton = true;
              productViewerPresentationManager.productViewerController
                  .selectProduct(idProduct: productentity.productId);
            } else {
              setState(() {});
              showMultipleStockUpdateButton = false;
              productViewerPresentationManager.productViewerController
                  .unselectProduct(idProduct: productentity.productId);
            }
          }
        },
        cells: [
          DataCell(Text(productentity.productName)),
          DataCell(Text(productentity.productId)),
          DataCell(Text(productentity.productsIn.toString())),
          DataCell(Text(productentity.productsOut.toString())),
          DataCell(Text(productentity.productCount.toString())),
          DataCell(IconButton(onPressed: () {}, icon: Icon(Icons.delete))),
          DataCell(TextButton(
              onPressed: () {
                productViewerPresentationManager.showStockUpdateOptions(
                    productId: [productentity.productId]);
              },
              child: Icon(fluent_ui.FluentIcons.edit_note))),
          DataCell(TextButton(
              onPressed: () {
                showSingleProductReport(
                    initialDate: productentity.productCreationDate as DateTime,
                    prodcutId: productentity.productId,
                    productName: productentity.productName);
              },
              child: Icon(Icons.info))),
        ]);
  }
}
