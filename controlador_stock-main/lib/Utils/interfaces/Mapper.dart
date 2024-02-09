///Clase base la cual se implementa en clases encargadas de transformar datos entre capas
///
///Actualmente esta implementada en dos clases
///
///FromEntity: usada cuando nos alejamos de la capa del dominio, transformamos las entidades en los tipos mas simples que requiere la infraestructura para funcionar
///
///Por ejemplo:   Entidad mensaje ---------> Map{String mensaje,String id,int date.....}
///
///Podemos decir que se encarga de desencapsular la informacion de la entidad (que proviene del dominio) en informacion mas simple para que la capa de datos no deba transformar nada mas
///
///
///ToEntity: usada cuando nos acercamos a la capa de dominio, transformamos datos simples que provienen de la capa de infraestructura en los datos complejos que se requiren en la capa de dominio (entidades)
///
///Por ejemplo:  Map{String mensaje,String id,int date.....}  -------> Entidad mensaje
///
///
///Podemos decir que se encarga de encapsular datos simples que vienen de la capa de infraestructura en datos mas complejos que se dirigen a la capa de dominio

abstract class ObjectMapper {}

///FromEntity: usada cuando nos alejamos de la capa del dominio, transformamos las entidades en los tipos mas simples que requiere la infraestructura para funcionar
///
///Por ejemplo:   Entidad mensaje ---------> Map{String mensaje,String id,int date.....}
///
///Podemos decir que se encarga de desencapsular la informacion de la entidad (que proviene del dominio) en informacion mas simple para que la capa de datos no deba transformar nada mas
abstract class FromEntity<T> extends ObjectMapper {
  Map<String, dynamic> toMap(T data);
}

///ToEntity: usada cuando nos acercamos a la capa de dominio, transformamos datos simples que provienen de la capa de infraestructura en los datos complejos que se requiren en la capa de dominio (entidades)
///
///Por ejemplo:  Map{String mensaje,String id,int date.....}  -------> Entidad mensaje
///
///
///Podemos decir que se encarga de encapsular datos simples que vienen de la capa de infraestructura en datos mas complejos que se dirigen a la capa de dominio
abstract class ToEntity<T> extends ObjectMapper {
  T fromMap({required Map data});
}
