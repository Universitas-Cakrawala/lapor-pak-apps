import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/users/data/users_repository.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/users/presentation/bloc/profile_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<DioClient>().dio));
  sl.registerLazySingleton<UsersRepository>(() => UsersRepository(sl<DioClient>().dio));
  
  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>(), sl<UsersRepository>()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<UsersRepository>()));
}
