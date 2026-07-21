import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class AdminProductConfigEvent extends Equatable {
  const AdminProductConfigEvent();

  @override
  List<Object?> get props => [];
}

// Load Product Config Event
class LoadProductConfig extends AdminProductConfigEvent {}

// Add Color Event
class AddColor extends AdminProductConfigEvent {
  final ColorModel color;
  const AddColor(this.color);
  @override
  List<Object?> get props => [color];
}

// Edit Color Event
class EditColor extends AdminProductConfigEvent {
  final ColorModel color;
  const EditColor(this.color);
  @override
  List<Object?> get props => [color];
}

// Delete Color Event
class DeleteColor extends AdminProductConfigEvent {
  final String colorId;
  const DeleteColor(this.colorId);
  @override
  List<Object?> get props => [colorId];
}

// Add Size Group Event
class AddSizeGroup extends AdminProductConfigEvent {
  final SizeGroupModel group;
  const AddSizeGroup(this.group);
  @override
  List<Object?> get props => [group];
}

// Edit Size Group Event
class EditSizeGroup extends AdminProductConfigEvent {
  final SizeGroupModel group;
  const EditSizeGroup(this.group);
  @override
  List<Object?> get props => [group];
}

// Delete Size Group Event
class DeleteSizeGroup extends AdminProductConfigEvent {
  final String groupId;
  const DeleteSizeGroup(this.groupId);
  @override
  List<Object?> get props => [groupId];
}

// Add Size To Group Event
class AddSizeToGroup extends AdminProductConfigEvent {
  final String groupId;
  final String size;
  const AddSizeToGroup({required this.groupId, required this.size});
  @override
  List<Object?> get props => [groupId, size];
}

// Remove Size From Group Event
class RemoveSizeFromGroup extends AdminProductConfigEvent {
  final String groupId;
  final String size;
  const RemoveSizeFromGroup({required this.groupId, required this.size});
  @override
  List<Object?> get props => [groupId, size];
}

// Change Tab Event
class ChangeTab extends AdminProductConfigEvent {
  final bool isColorsTab;
  const ChangeTab({required this.isColorsTab});
  @override
  List<Object?> get props => [isColorsTab];
}
