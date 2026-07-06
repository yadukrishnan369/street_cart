import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_product_config.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_colors.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_size_groups.dart';
import 'admin_product_config_event.dart';
import 'admin_product_config_state.dart';

class AdminProductConfigBloc
    extends Bloc<AdminProductConfigEvent, AdminProductConfigState> {
  final GetProductConfig _getProductConfig;
  final SaveColors _saveColors;
  final SaveSizeGroups _saveSizeGroups;

  ProductConfigModel _current = const ProductConfigModel();

  AdminProductConfigBloc({
    required GetProductConfig getProductConfig,
    required SaveColors saveColors,
    required SaveSizeGroups saveSizeGroups,
  }) : _getProductConfig = getProductConfig,
       _saveColors = saveColors,
       _saveSizeGroups = saveSizeGroups,
       super(ProductConfigInitial()) {
    on<LoadProductConfig>(_onLoad);
    on<AddColor>(_onAddColor);
    on<EditColor>(_onEditColor);
    on<DeleteColor>(_onDeleteColor);
    on<AddSizeGroup>(_onAddSizeGroup);
    on<EditSizeGroup>(_onEditSizeGroup);
    on<DeleteSizeGroup>(_onDeleteSizeGroup);
    on<AddSizeToGroup>(_onAddSizeToGroup);
    on<RemoveSizeFromGroup>(_onRemoveSizeFromGroup);
  }

  Future<void> _onLoad(
    LoadProductConfig event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigLoading());
    try {
      _current = await _getProductConfig();
      emit(ProductConfigLoaded(_current));
    } catch (e) {
      emit(ProductConfigLoadFailure(e.toString()));
    }
  }

  Future<void> _onAddColor(
    AddColor event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = [..._current.colors, event.color];
      await _saveColors(updated);
      _current = _current.copyWith(colors: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Color added successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }

  Future<void> _onEditColor(
    EditColor event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = _current.colors
          .map((c) => c.id == event.color.id ? event.color : c)
          .toList();
      await _saveColors(updated);
      _current = _current.copyWith(colors: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Color updated successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }

  Future<void> _onDeleteColor(
    DeleteColor event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = _current.colors
          .where((c) => c.id != event.colorId)
          .toList();
      await _saveColors(updated);
      _current = _current.copyWith(colors: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Color deleted successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }

  Future<void> _onAddSizeGroup(
    AddSizeGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = [..._current.sizeGroups, event.group];
      await _saveSizeGroups(updated);
      _current = _current.copyWith(sizeGroups: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Size group added successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }

  Future<void> _onEditSizeGroup(
    EditSizeGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = _current.sizeGroups
          .map((g) => g.id == event.group.id ? event.group : g)
          .toList();
      await _saveSizeGroups(updated);
      _current = _current.copyWith(sizeGroups: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Size group updated successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }

  Future<void> _onDeleteSizeGroup(
    DeleteSizeGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = _current.sizeGroups
          .where((g) => g.id != event.groupId)
          .toList();
      await _saveSizeGroups(updated);
      _current = _current.copyWith(sizeGroups: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Size group deleted successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }

  Future<void> _onAddSizeToGroup(
    AddSizeToGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = _current.sizeGroups.map((g) {
        if (g.id == event.groupId) {
          return g.copyWith(sizes: [...g.sizes, event.size]);
        }
        return g;
      }).toList();
      await _saveSizeGroups(updated);
      _current = _current.copyWith(sizeGroups: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Size added successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }

  Future<void> _onRemoveSizeFromGroup(
    RemoveSizeFromGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current));
    try {
      final updated = _current.sizeGroups.map((g) {
        if (g.id == event.groupId) {
          return g.copyWith(
            sizes: g.sizes.where((s) => s != event.size).toList(),
          );
        }
        return g;
      }).toList();
      await _saveSizeGroups(updated);
      _current = _current.copyWith(sizeGroups: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Size removed successfully',
          config: _current,
        ),
      );
    } catch (e) {
      emit(ProductConfigActionFailure(message: e.toString(), config: _current));
    }
  }
}
