import 'dart:async';

/// Controller parser class: Usada para rescuchar los mensajes que vienen de un repositorio que sea [RealTImeRepositoryParser]
/// 
/// los mensajes seran gestionados pporn el controlador 

abstract class ControllerParser {

  /// Mediante esta suscripcion escucharemos 
  late StreamSubscription controllerParserSubscription;
  void controllerParser();
}
