import 'dart:async';

///RealTimeRepositoryParser: Cuando exista la necesidadad de escuchar eventos desde la capa de datos de forma asincrona
///
///y necesitemos transformar los datos para enviarselos al controlador
///

abstract class RealTImeRepositoryParser {
  late StreamController<Map<String, dynamic>>
      realTimeRepositoryStreamController;
  late StreamSubscription realTimeRepositoryStreamSubscription;

  void repsitoryParser();
}
