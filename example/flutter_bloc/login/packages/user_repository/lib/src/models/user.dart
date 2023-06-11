
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id);
  final String id;


  static const empty = User('-');

  @override
  // TODO: implement props
  List<Object?> get props => [id];


}