import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/users/data/users_repository.dart';
import '../../features/reports/data/reports_repository.dart';
import '../../features/media/data/media_repository.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/users/presentation/bloc/profile_cubit.dart';
import '../../features/reports/presentation/bloc/home_stats_cubit.dart';
import '../../features/reports/presentation/bloc/report_list_cubit.dart';
import '../../features/reports/presentation/bloc/report_detail_cubit.dart';
import '../../features/reports/presentation/bloc/report_form_cubit.dart';
import '../../features/reports/data/status_repository.dart';
import '../../features/reports/presentation/bloc/admin_update_status_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<DioClient>().dio));
  sl.registerLazySingleton<UsersRepository>(() => UsersRepository(sl<DioClient>().dio));
  sl.registerLazySingleton<ReportsRepository>(() => ReportsRepository(sl<DioClient>().dio));
  sl.registerLazySingleton<MediaRepository>(() => MediaRepository(sl<DioClient>().dio));
  sl.registerLazySingleton<StatusRepository>(() => StatusRepository(sl<DioClient>().dio));
  
  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>(), sl<UsersRepository>()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<UsersRepository>()));
  sl.registerFactory<HomeStatsCubit>(() => HomeStatsCubit(sl<ReportsRepository>()));
  sl.registerFactory<ReportListCubit>(() => ReportListCubit(sl<ReportsRepository>()));
  sl.registerFactory<ReportDetailCubit>(() => ReportDetailCubit(sl<ReportsRepository>(), sl<UsersRepository>()));
  sl.registerFactory<ReportFormCubit>(() => ReportFormCubit(sl<ReportsRepository>(), sl<MediaRepository>()));
  sl.registerFactory<AdminUpdateStatusCubit>(() => AdminUpdateStatusCubit(sl<StatusRepository>(), sl<MediaRepository>()));
}
