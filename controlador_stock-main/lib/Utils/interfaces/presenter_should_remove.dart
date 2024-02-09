import 'dart:async';

import 'package:stockcontrollerterminal/Utils/interfaces/should_remove.dart';

///Clase que nos da un metodo dentro del cual debemos escuchar al stream expeusto por la clase [ShouldRemove]
///
///y aplicar la logica de presentacion dentro de este
///
/// ```dart
///  void presenterRemove(){
/// ShouldRemove.removeController.stream.listen((event){
///
/// });// Aqui recibes la informacion que el controlador indica que se ha eliminado y que debe reflejarse en la interfaz
/// }
/// ```
abstract class PresenterShouldRemove {
  ///Esta subscripcion debe usarse para escuchar al stream expeusto por la clase [ShouldRemove],
  ///
  ///es necesario para poder reiniciar el presentador y con ello al stream  expeusto por la clase [ShouldRemove],
  ///
  /// ```dart
  ///  void presenterAddData(){
  ///    presenterUpdateDataStreamSubscription  = ShouldRemove.removeController.stream.listen((event){
  /// // Aqui recibes la informacion que el controlador indica que se ha añadido y que debe reflejarse en la interfaz
  /// });
  /// }
  /// ```

  late StreamSubscription<Map<String, dynamic>> presenterUpdateDataSubscription;

  /// Recibe la informcion que el controlador considere que debe actualizar el estado de la interfaz
  ///
  /// ```dart
  ///  void presenterRemove(){
  /// ShouldRemove.removeController.stream.listen((event){
  /// // Aqui recibes la informacion que el controlador indica que se ha eliminado y que debe reflejarse en la interfaz
  /// });
  /// }
  /// ```

  void presenterRemove();
}
