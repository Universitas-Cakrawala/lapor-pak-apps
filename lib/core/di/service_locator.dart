import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<DioClient>().dio));
  
  // Cubits
  // sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>(), ...));
}
