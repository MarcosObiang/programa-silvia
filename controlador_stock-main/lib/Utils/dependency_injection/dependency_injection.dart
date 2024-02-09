import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/Utils/services/ServerService/server.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportController.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportDataSource.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportMapper.dart';
import 'package:stockcontrollerterminal/features/departmentReport/departmentReportRepository.dart';
import 'package:stockcontrollerterminal/features/departmentReport/presentation/presentation.dart';
import 'package:stockcontrollerterminal/features/departments/departmentController.dart';
import 'package:stockcontrollerterminal/features/departments/departmentDataSource.dart';
import 'package:stockcontrollerterminal/features/departments/departmentRepository.dart';
import 'package:stockcontrollerterminal/features/departments/presentation/presentationManager.dart';
import 'package:stockcontrollerterminal/features/employee_creator/productCreatorController.dart';
import 'package:stockcontrollerterminal/features/employee_creator/productCreatorDataSource.dart';
import 'package:stockcontrollerterminal/features/employee_creator/productCreatorRepository.dart';
import 'package:stockcontrollerterminal/features/productReport/presentation/presentation.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportController.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportDataSource.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportMapper.dart';
import 'package:stockcontrollerterminal/features/productReport/productReportRepo.dart';
import 'package:stockcontrollerterminal/features/productViewer/productMapper.dart';
import 'package:stockcontrollerterminal/features/employee_creator/product_creator_presentation/product_creator_presentation_manager.dart';
import 'package:stockcontrollerterminal/features/productViewer/productViewerController.dart';
import 'package:stockcontrollerterminal/features/productViewer/productViewerDataSource.dart';
import 'package:stockcontrollerterminal/features/productViewer/productViewerRepository.dart';
import 'package:stockcontrollerterminal/features/productViewer/product_viewer_presentation/product_viewer_presentation_manager.dart';
import 'package:stockcontrollerterminal/features/stock_change/presentation/stock_changer_presentation_manager.dart';
import 'package:stockcontrollerterminal/features/stock_change/stockChangeEntity.dart';
import 'package:stockcontrollerterminal/features/stock_change/stock_change_controller.dart';
import 'package:stockcontrollerterminal/features/stock_change/stock_change_datasource.dart';
import 'package:stockcontrollerterminal/features/stock_change/stock_change_mapper.dart';
import 'package:stockcontrollerterminal/features/stock_change/stock_change_repository.dart';

import '../../features/productViewer/ProductEntity.dart';

class Dependencies {
  static final Server server = Server();
  static final ProductCreatorDataSource employeeDataSource =
      ProductCreatorDataSourceImpl(server: server);
  static final FromEntity<ProductEntity> fromEntity = ProductMapper();
  static final ProductCreatorRepository productCreatorRepository =
      ProductCreatorRepositoryImpl(
          fromEntity: fromEntity, productCreatorDataSource: employeeDataSource);
  static final ProductCreatorController productCreatorController =
      ProductCreatorControllerImpl(
          productCreatorRepository: productCreatorRepository);
  static final ProductCreatorPresentatorManager
      productCreatorPresentatorManager = ProductCreatorPresentatorManager(
          productCreatorcontroller: productCreatorController);

  static final ProductViewerDataSource productViewerDataSource =
      ProductViewerDataSourceImpl(server: server);
  static final ProductViewerRepository productViewerRepository =
      ProductViewerRepositoryImpl(
          productViewerDataSource: productViewerDataSource);
  static final ProductViewerController productViewerController =
      ProductViewerControllerImpl(
          productViewerRepository: productViewerRepository);
  static final ProductViewerPresentationManager
      productViewerPresentationManager = ProductViewerPresentationManager(
          productViewerController: productViewerController);

  static final StockChangerDataSource stockChangerDataSource =
      StockChangerDataSourceImpl(server: server);
  static final FromEntity<StockChangeEntity> fromEntityStockChangeentity =
      StockChangeMapper();

  static final ToEntity<StockChangeEntity> toEntityStockChangeEntity =
      StockChangeMapper();

  static final StockChangerRepository stockChangerRepository =
      StockChangerRepositoryImpl(
          fromEntity: fromEntityStockChangeentity,
          toEntity: toEntityStockChangeEntity,
          stockChangerDataSource: stockChangerDataSource);
  static final StockChangerController stockChangerController =
      StockChangerControllerImpl(
          departmentController: departmentController,
          stockChangerRepository: stockChangerRepository);
  static final StockChangerPresentationManager stockChangerPresentationManager =
      StockChangerPresentationManager(
          stockChangerController: stockChangerController);

  static final DepartmentDataSource departmentDataSource =
      DepartmentDataSourceImpl(server: server);
  static final DepartmentRepository departmentRepository =
      DepartmentRepositoryImpl(departmentDataSource: departmentDataSource);
  static final DepartmentController departmentController =
      DepartmentControllerImpl(departmentRepository: departmentRepository);
  static final DepartmentPresentationManager departmentPresentationManager =
      DepartmentPresentationManager(departmentController: departmentController);

  static final ProductReportDataSource productReportDataSource =
      ProductReportDataSourceImpl(server: server);
  static late final ProductReportMapper productReportMapper =
      ProductReportMapper();
  static late final ProductReportRepo productReportRepo = ProductReportRepoImpl(
      productReportDataSource: productReportDataSource,
      productReportMapper: productReportMapper);

  static late final ProductReportController productReportController =
      ProductReportControllerImpl(productReportRepo: productReportRepo);
  static late final ProductReportCreatorPresentationManager
      productReportCreatorPresentationManager =
      ProductReportCreatorPresentationManager(
          productReportController: productReportController);

  static late final DepartmentReportDataSource departmentReportDataSource =
      DepartmentReportDataSourceImpl(server: server);
  static late final DepartmentReportMapper departmentReportMapper =
      DepartmentReportMapper();
  static late final DepartmetntReportRepository departmentReportRepository =
      DepartmentReportRepositoryImpl(
          departmentReportMapper: departmentReportMapper,
          departmentReportDataSource: departmentReportDataSource);

  static late final DepartmentReportController departmentReportController =
      DepartmentReportControllerImpl(
          departmentReportRepository: departmentReportRepository);
  static final DepartmentReportCreatorPresentationManager
      departmentReportPresentatorManager =
      DepartmentReportCreatorPresentationManager(
          departmentReportController: departmentReportController);
  static startDependencies() {
    productCreatorPresentatorManager.initVariables();
    productViewerPresentationManager.initVariables();
    stockChangerPresentationManager.initVariables();
    departmentPresentationManager.initVariables();
    productReportCreatorPresentationManager.initVariables();
    departmentReportPresentatorManager.initVariables();
  }
}
