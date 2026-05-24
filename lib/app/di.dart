import 'package:get_it/get_it.dart';
import '../features/musicbrainz/data/datasources/musicbrainz_api.dart';
import '../features/musicbrainz/data/repositories/musicbrainz_repository_impl.dart';
import '../features/musicbrainz/domain/repositories/musicbrainz_repository.dart';
import '../features/musicbrainz/domain/usecases/search_artists.dart';
import '../features/musicbrainz/domain/usecases/get_artist_relationships.dart';
import '../features/musicbrainz/presentation/bloc/musicbrainz_bloc.dart';
import '../features/canvas/presentation/bloc/canvas_bloc.dart';
import '../features/wikidata/data/datasources/wikidata_api.dart';
import '../features/wikidata/data/repositories/wikidata_repository_impl.dart';
import '../features/wikidata/domain/repositories/wikidata_repository.dart';
import '../features/wikidata/domain/usecases/get_macro_evolution.dart';

// Auth Imports
import '../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/observe_auth_state.dart';
import '../features/auth/domain/usecases/sign_in_with_email.dart';
import '../features/auth/domain/usecases/sign_up_with_email.dart';
import '../features/auth/domain/usecases/sign_in_with_social_provider.dart';
import '../features/auth/domain/usecases/sign_out.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Services
  getIt.registerLazySingleton<MusicBrainzApi>(() => MusicBrainzApi());
  getIt.registerLazySingleton<WikidataApi>(() => WikidataApi());
  getIt.registerLazySingleton<FirebaseAuthDatasource>(
    () => FirebaseAuthDatasource(),
  );

  // Repositories
  getIt.registerLazySingleton<MusicBrainzRepository>(
    () => MusicBrainzRepositoryImpl(getIt<MusicBrainzApi>()),
  );
  getIt.registerLazySingleton<WikidataRepository>(
    () => WikidataRepositoryImpl(api: getIt<WikidataApi>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuthDatasource>()),
  );

  // Usecases
  getIt.registerLazySingleton<SearchArtists>(
    () => SearchArtists(getIt<MusicBrainzRepository>()),
  );
  getIt.registerLazySingleton<GetArtistRelationships>(
    () => GetArtistRelationships(getIt<MusicBrainzRepository>()),
  );
  getIt.registerLazySingleton<GetMacroEvolution>(
    () => GetMacroEvolution(getIt<WikidataRepository>()),
  );
  getIt.registerLazySingleton<ObserveAuthState>(
    () => ObserveAuthState(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignInWithEmail>(
    () => SignInWithEmail(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUpWithEmail>(
    () => SignUpWithEmail(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignInWithSocialProvider>(
    () => SignInWithSocialProvider(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignOut>(() => SignOut(getIt<AuthRepository>()));

  // BLoCs
  getIt.registerFactory<MusicBrainzBloc>(
    () => MusicBrainzBloc(searchArtists: getIt<SearchArtists>()),
  );
  getIt.registerFactory<CanvasBloc>(
    () => CanvasBloc(
      getArtistRelationships: getIt<GetArtistRelationships>(),
      getMacroEvolution: getIt<GetMacroEvolution>(),
    ),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      observeAuthState: getIt<ObserveAuthState>(),
      signInWithEmail: getIt<SignInWithEmail>(),
      signUpWithEmail: getIt<SignUpWithEmail>(),
      signInWithSocialProvider: getIt<SignInWithSocialProvider>(),
      signOut: getIt<SignOut>(),
    ),
  );
}
