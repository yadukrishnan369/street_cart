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
  bool _isColorsTab = true;

  AdminProductConfigBloc({
    required GetProductConfig getProductConfig,
    required SaveColors saveColors,
    required SaveSizeGroups saveSizeGroups,
  }) : _getProductConfig = getProductConfig,
       _saveColors = saveColors,
       _saveSizeGroups = saveSizeGroups,
       super(const ProductConfigInitial(isColorsTab: true)) {
    on<LoadProductConfig>(_onLoad);
    on<AddColor>(_onAddColor);
    on<EditColor>(_onEditColor);
    on<DeleteColor>(_onDeleteColor);
    on<AddSizeGroup>(_onAddSizeGroup);
    on<EditSizeGroup>(_onEditSizeGroup);
    on<DeleteSizeGroup>(_onDeleteSizeGroup);
    on<AddSizeToGroup>(_onAddSizeToGroup);
    on<RemoveSizeFromGroup>(_onRemoveSizeFromGroup);
    on<ChangeTab>(_onChangeTab);
  }
  // Change Tab
  void _onChangeTab(ChangeTab event, Emitter<AdminProductConfigState> emit) {
    _isColorsTab = event.isColorsTab;
    if (state is ProductConfigLoaded) {
      emit(ProductConfigLoaded(_current, isColorsTab: _isColorsTab));
    } else if (state is ProductConfigActionSuccess) {
      emit(
        ProductConfigActionSuccess(
          message: (state as ProductConfigActionSuccess).message,
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    } else if (state is ProductConfigActionFailure) {
      emit(
        ProductConfigActionFailure(
          message: (state as ProductConfigActionFailure).message,
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    } else if (state is ProductConfigActionInProgress) {
      emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
    } else {
      emit(ProductConfigLoaded(_current, isColorsTab: _isColorsTab));
    }
  }

  // Load Config
  Future<void> _onLoad(
    LoadProductConfig event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigLoading(isColorsTab: _isColorsTab));
    try {
      _current = await _getProductConfig();
      emit(ProductConfigLoaded(_current, isColorsTab: _isColorsTab));
    } catch (e) {
      emit(ProductConfigLoadFailure(e.toString(), isColorsTab: _isColorsTab));
    }
  }

  // Add Color
  Future<void> _onAddColor(
    AddColor event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
    try {
      final updated = [..._current.colors, event.color];
      await _saveColors(updated);
      _current = _current.copyWith(colors: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Color added successfully',
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }

  // Edit Color
  Future<void> _onEditColor(
    EditColor event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
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
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }

  // Delete Color
  Future<void> _onDeleteColor(
    DeleteColor event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
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
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }

  // Add Size Group
  Future<void> _onAddSizeGroup(
    AddSizeGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
    try {
      final updated = [..._current.sizeGroups, event.group];
      await _saveSizeGroups(updated);
      _current = _current.copyWith(sizeGroups: updated);
      emit(
        ProductConfigActionSuccess(
          message: 'Size group added successfully',
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }

  // Edit Size Group
  Future<void> _onEditSizeGroup(
    EditSizeGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
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
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }

  // Delete Size Group
  Future<void> _onDeleteSizeGroup(
    DeleteSizeGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
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
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }

  // Add Size To Group
  Future<void> _onAddSizeToGroup(
    AddSizeToGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
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
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }

  // Remove Size From Group
  Future<void> _onRemoveSizeFromGroup(
    RemoveSizeFromGroup event,
    Emitter<AdminProductConfigState> emit,
  ) async {
    emit(ProductConfigActionInProgress(_current, isColorsTab: _isColorsTab));
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
          isColorsTab: _isColorsTab,
        ),
      );
    } catch (e) {
      emit(
        ProductConfigActionFailure(
          message: e.toString(),
          config: _current,
          isColorsTab: _isColorsTab,
        ),
      );
    }
  }
}
