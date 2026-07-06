import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class AdminProductConfigEvent extends Equatable {
  const AdminProductConfigEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductConfig extends AdminProductConfigEvent {}

class AddColor extends AdminProductConfigEvent {
  final ColorModel color;
  const AddColor(this.color);
  @override
  List<Object?> get props => [color];
}

class EditColor extends AdminProductConfigEvent {
  final ColorModel color;
  const EditColor(this.color);
  @override
  List<Object?> get props => [color];
}

class DeleteColor extends AdminProductConfigEvent {
  final String colorId;
  const DeleteColor(this.colorId);
  @override
  List<Object?> get props => [colorId];
}

class AddSizeGroup extends AdminProductConfigEvent {
  final SizeGroupModel group;
  const AddSizeGroup(this.group);
  @override
  List<Object?> get props => [group];
}

class EditSizeGroup extends AdminProductConfigEvent {
  final SizeGroupModel group;
  const EditSizeGroup(this.group);
  @override
  List<Object?> get props => [group];
}

class DeleteSizeGroup extends AdminProductConfigEvent {
  final String groupId;
  const DeleteSizeGroup(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

class AddSizeToGroup extends AdminProductConfigEvent {
  final String groupId;
  final String size;
  const AddSizeToGroup({required this.groupId, required this.size});
  @override
  List<Object?> get props => [groupId, size];
}

class RemoveSizeFromGroup extends AdminProductConfigEvent {
  final String groupId;
  final String size;
  const RemoveSizeFromGroup({required this.groupId, required this.size});
  @override
  List<Object?> get props => [groupId, size];
}
