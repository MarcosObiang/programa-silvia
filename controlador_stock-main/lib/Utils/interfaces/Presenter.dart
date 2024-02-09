import 'controller_layer.dart';

/// PresenterLayer: Es la capa encargada de gestionar la logica de presentacion y reflejar el estado de la capa controlador.
///
/// En su interior no encontraremos logica de negocio, solo llamadas a el controlador y recibiendo datos del controlador mediante Streams
///
///
abstract class PresenterLayer {
  late ControllerState state;
}
