/// State: Define el estado de un controlador despues de iniciar todas sus dependencias (Datasource,Repository) y a si misma.
///
///
///
/// State.loading: Se esta cargando el controlador, aun no hay resultado definitivo
///
/// State.ready: El controlador no ha experimentado ninguna exceocion y esta listo para su uso
///
/// State.error: ha habido un error al inicializar o durante el uso del controlador, hay que reiniciar
///
/// State.notLoaded: estado inicial del controlador con todas las variables en estado inicial

enum ControllerState { loading, ready, error, notLoaded }

/// ControllerLayer: Es la capa encargada de gestionar la logica de negocio y aplicarla a las entidades, depende de la capa repositorio para conectarse con el exterior.
///
/// En su interior encontraremos solo logica de negocio, la capa Presenter depende de la capa ControllerLayer
///
///
abstract class ControllerLayer {
  late ControllerState state;
}
