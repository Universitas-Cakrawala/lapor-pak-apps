import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/users_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UsersRepository _usersRepo;

  ProfileCubit(this._usersRepo) : super(const ProfileState());

  Future<void> fetchProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await _usersRepo.getMe();
      if (user != null) {
        emit(state.copyWith(status: ProfileStatus.success, user: user));
      } else {
        emit(state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Sesi berakhir, silakan login kembali',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Gagal mengambil data profil',
      ));
    }
  }
}
