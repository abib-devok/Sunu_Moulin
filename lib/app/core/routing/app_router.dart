import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matheasy_sn/app/di/injector.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';
import 'package:matheasy_sn/presentation/screens/auth/login_screen.dart';
import 'package:matheasy_sn/presentation/screens/auth/register_screen.dart';
import 'package:matheasy_sn/presentation/screens/bfem/bfem_quiz_screen.dart';
import 'package:matheasy_sn/presentation/screens/bfem/bfem_screen.dart';
import 'package:matheasy_sn/presentation/screens/bfem/pdf_viewer_screen.dart';
import 'package:matheasy_sn/presentation/screens/course/course_detail_screen.dart';
import 'package:matheasy_sn/presentation/screens/course/courses_list_screen.dart';
import 'package:matheasy_sn/presentation/screens/exercise/exercises_screen.dart';
import 'package:matheasy_sn/presentation/screens/home/home_screen.dart';
import 'package:matheasy_sn/presentation/screens/progress/progress_screen.dart';
import 'package:matheasy_sn/presentation/screens/splash/initial_download_screen.dart';
import 'package:matheasy_sn/presentation/screens/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String initialDownload = '/initial-download';
  static const String home = '/home';
  static const String courses = '/courses';
  static const String courseDetail = '/course-detail';
  static const String exercises = '/exercises';
  static const String bfem = '/bfem';
  static const String bfemQuiz = 'quiz/:year';
  static const String pdfViewer = '/pdf-viewer';
  static const String progress = '/progress';

  static GoRouter getRouter(BuildContext context) {
    final sharedPreferences = sl<SharedPreferences>();

    return GoRouter(
      initialLocation: splash,
      refreshListenable: GoRouterRefreshStream(context.read<AuthBloc>().stream),
      routes: [
        GoRoute(path: splash, name: splash, builder: (context, state) => const SplashScreen()),
        GoRoute(path: login, name: login, builder: (context, state) => const LoginScreen()),
        GoRoute(path: register, name: register, builder: (context, state) => const RegisterScreen()),
        GoRoute(path: initialDownload, name: initialDownload, builder: (context, state) => const InitialDownloadScreen()),
        GoRoute(path: home, name: home, builder: (context, state) => const HomeScreen()),
        GoRoute(path: courses, name: courses, builder: (context, state) => const CoursesListScreen()),
        GoRoute(path: '$courseDetail/:slug', name: courseDetail, builder: (context, state) => CourseDetailScreen(slug: state.pathParameters['slug']!)),
        GoRoute(path: '$exercises/:chapterSlug', name: exercises, builder: (context, state) => ExercisesScreen(chapterSlug: state.pathParameters['chapterSlug']!)),
        GoRoute(
          path: bfem,
          name: bfem,
          builder: (context, state) => const BfemScreen(),
          routes: [
            GoRoute(path: bfemQuiz, name: 'bfem-quiz', builder: (context, state) => BfemQuizScreen(year: int.parse(state.pathParameters['year']!))),
          ],
        ),
        GoRoute(path: pdfViewer, name: 'pdf-viewer', builder: (context, state) => PdfViewerScreen(filePath: state.uri.queryParameters['filePath']!, title: state.uri.queryParameters['title'] ?? 'Document')),
        GoRoute(path: progress, name: progress, builder: (context, state) => const ProgressScreen()),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = context.read<AuthBloc>().state;
        final location = state.uri.toString();

        final publicRoutes = [login, register];

        // Si l'application est en cours de chargement (par exemple, lors d'une tentative de connexion), on affiche le splash screen.
        if (authState is AuthLoading) {
            return splash;
        }

        // Si l'utilisateur n'est pas authentifié
        if (authState is AuthUnauthenticated || authState is AuthRegistrationSuccess) {
            // S'il est déjà sur une page publique (login/register), on ne fait rien.
            if (publicRoutes.contains(location)) {
                return null;
            }
            // Sinon, on le redirige vers le login.
            return login;
        }

        // Si l'utilisateur est authentifié
        if (authState is AuthAuthenticated) {
          final isContentDownloaded = sharedPreferences.getBool('content_downloaded') ?? false;

          if (!isContentDownloaded) {
            // S'il n'a pas téléchargé le contenu, on le force à aller sur l'écran de téléchargement.
            return location == initialDownload ? null : initialDownload;
          }

          // Si le contenu est téléchargé et qu'il est sur une page publique ou de téléchargement, on le redirige vers l'accueil.
          if (publicRoutes.contains(location) || location == initialDownload || location == splash) {
            return home;
          }
        }

        // Dans tous les autres cas (y compris l'état initial qui est maintenant géré par le délai du splash), on ne redirige pas.
        return null;
      },
      errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Page non trouvée: ${state.error}'))),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }
}