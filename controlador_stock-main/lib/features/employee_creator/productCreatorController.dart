import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/controller_layer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/errors/exceptions/Exceptions.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_add_data.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_remove.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/should_update.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_disposer.dart';
import 'package:stockcontrollerterminal/Utils/interfaces/variables_initializer.dart';
import 'package:stockcontrollerterminal/features/employee_creator/productCreatorRepository.dart';

import '../../Utils/interfaces/service.dart';
import '../../Utils/services/ImagePicker/image_picker_service.dart';

abstract class ProductCreatorController
    implements
        ControllerLayer,
        VariablesDisposer,
        VariablesInitializer,
        ShouldUpdate {
  late ProductCreatorRepository productCreatorRepository;

  /// Crea un nuevo empleado despues de rellenar el formulario y obtener la imagen desde el sistema
  Future<Either<Exception, bool>> createProduct(
      {required Map<String, dynamic> datosEmpleado});
}

class ProductCreatorControllerImpl implements ProductCreatorController {
  @override
  ControllerState state = ControllerState.notLoaded;

  @override
  StreamController<Map<String, dynamic>> updateController = StreamController();

  ProductCreatorControllerImpl({required this.productCreatorRepository});
  @override
  ProductCreatorRepository productCreatorRepository;

  late Uint8List imagenEmpleado;

  @override
  Future<Either<Exception, bool>> createProduct(
      {required Map<String, dynamic> datosEmpleado}) async {
    return productCreatorRepository.createProduct(productData: datosEmpleado);
  }

  @override
  void disposeVariables() {
    try {
      state = ControllerState.notLoaded;
      if (updateController.isClosed == false) {
        updateController.close();
      }
      updateController = StreamController();
      sendUpdateData();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initVariables() {
    state = ControllerState.ready;
    sendUpdateData();
  }

  @override
  void sendUpdateData() {
    updateController.add({"state": state});
  }
}
