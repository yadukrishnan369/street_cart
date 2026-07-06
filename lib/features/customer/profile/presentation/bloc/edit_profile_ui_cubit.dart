import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileUiState {
  final String? currentImageUrl;
  final bool isUploadingProfilePic;
  final String activeName;

  const EditProfileUiState({
    this.currentImageUrl,
    this.isUploadingProfilePic = false,
    this.activeName = '',
  });

  EditProfileUiState copyWith({
    String? currentImageUrl,
    bool? isUploadingProfilePic,
    String? activeName,
    bool clearImageUrl = false,
  }) {
    return EditProfileUiState(
      currentImageUrl: clearImageUrl ? null : (currentImageUrl ?? this.currentImageUrl),
      isUploadingProfilePic: isUploadingProfilePic ?? this.isUploadingProfilePic,
      activeName: activeName ?? this.activeName,
    );
  }
}

class EditProfileUiCubit extends Cubit<EditProfileUiState> {
  EditProfileUiCubit() : super(const EditProfileUiState());

  void init(String? imageUrl, String activeName) {
    emit(EditProfileUiState(currentImageUrl: imageUrl, activeName: activeName));
  }

  void updateActiveName(String name) {
    emit(state.copyWith(activeName: name));
  }

  void startUploading() {
    emit(state.copyWith(isUploadingProfilePic: true));
  }

  void finishUploading(String imageUrl) {
    emit(state.copyWith(
      isUploadingProfilePic: false,
      currentImageUrl: imageUrl,
    ));
  }

  void clearImageUrl() {
    emit(state.copyWith(clearImageUrl: true));
  }
}
