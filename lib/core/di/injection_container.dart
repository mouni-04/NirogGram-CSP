import 'package:get_it/get_it.dart';

import '../services/auth_service.dart';
import '../services/firestore_complaint_service.dart';
import '../services/image_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  sl.registerLazySingleton<FirestoreComplaintService>(() => FirestoreComplaintService());
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<LocationService>(() => LocationService());
  sl.registerLazySingleton<ImageService>(() => ImageService());
}
