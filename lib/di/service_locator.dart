import 'package:ca_new/core/network/network_info.dart';
import 'package:ca_new/core/network/network_info_impl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/http_handler.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/datasources/auth_local_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../features/homepage/data/datasources/home_remote_data_source.dart';
import '../features/homepage/data/repositories/home_repository_impl.dart';
import '../features/homepage/domain/repositories/home_repository.dart';
import '../features/homepage/domain/usecases/get_tasks_usecase.dart';
import '../features/homepage/presentation/blocs/home/home_bloc.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // External
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton(() => Connectivity());

  // Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(httpHandler: getIt()));
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt<NetworkInfo>()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerFactory<AuthBloc>(
      () => AuthBloc(loginUseCase: getIt(), logoutUseCase: getIt()));
  // Core
  getIt.registerLazySingleton<HttpHandler>(
      () => HttpHandler(client: getIt(), token: null));
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Initialize HttpHandler with token
  final token = await getIt<AuthRepository>().getToken();
  getIt<HttpHandler>().setToken(token);

  // Home Feature
  getIt.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(httpHandler: getIt()));
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
      remoteDataSource: getIt(), networkInfo: getIt<NetworkInfo>()));
  getIt.registerLazySingleton<GetTasksUseCase>(() => GetTasksUseCase(getIt()));
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getTasksUseCase: getIt()));
}
