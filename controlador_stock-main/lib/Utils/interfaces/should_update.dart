import 'dart:async';

///Para notificar al presentador de cambios en tiempo real de forma asincrona
///
///
///(por ejemplo dentro de un stream) usaremos tres tipos de Streams
///
///
///
///
///ShouldUpdate:Desde el controlador hasta el presentador para notificar al presentador que algo ha cambiado en el controlador y que se debe reflejar en la interfaz ( en el presentador debe usarse dentro de la funcion PresenterUpdate.presenterUpdate())
///
///
///
///
///ShouldRemove:Desde el controlador hasta el presentador para notificar al presentador que algo ha sido eliminado en el controlador y que se debe reflejar en la interfaz ( en el presentador debe usarse dentro de la funcion PresenterRemove.presenterRemove())
///
///
///
///
///ShouldAddData:Desde el controlador hasta el presentador para notificar al presentador que algo ha sido añadido en el controlador y que se debe reflejar en la interfaz ( en el presentador debe usarse dentro de la funcion PresenterAddData.presenterAddData())

abstract class ShouldUpdate {
  late StreamController<Map<String, dynamic>> updateController;
  void sendUpdateData();
}
