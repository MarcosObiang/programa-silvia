import 'dart:async';

import 'package:stockcontrollerterminal/Utils/interfaces/should_add_data.dart';

///Clase que nos da un metodo dentro del cual debemos escuchar al stream expeusto por la clase [ShouldAddData]
///
///y aplicar la logica de presentacion dentro de este
///
/// ```dart
///  void presenterAddData(){
/// ShouldAddData.addDataController.stream.listen((event){
/// // Aqui recibes la informacion que el controlador indica que se ha añadido y que debe reflejarse en la interfaz
/// });
/// }
/// ```
abstract class PresenterShouldAddData {
  ///Esta subscripcion debe usarse para escuchar al stream expeusto por la clase [ShouldAddData],
  ///
  ///es necesario para poder reiniciar el presentador y con ello al stream  expeusto por la clase [ShouldAddData],
  ///
  /// ```dart
  ///  void presenterAddData(){
  ///    presenterUpdateDataStreamSubscription  = ShouldAddData.addDataController.stream.listen((event){
  /// // Aqui recibes la informacion que el controlador indica que se ha añadido y que debe reflejarse en la interfaz
  /// });
  /// }
  /// ```

  late StreamSubscription<Map<String, dynamic>>
      presenterUpdateDataStreamSubscription;

  /// Recibe la informcion que el controlador considere que debe actualizar el estado de la interfaz
  ///
  /// ```dart
  ///  void presenterAddData(){
  ///    presenterUpdateDataStreamSubscription  = ShouldAddData.addDataController.stream.listen((event){
  /// // Aqui recibes la informacion que el controlador indica que se ha añadido y que debe reflejarse en la interfaz
  /// });
  /// }
  /// ```

  void presenterAddData();
}
