import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';
import 'package:matheasy_sn/presentation/screens/auth/login_screen.dart';
import 'package:matheasy_sn/presentation/screens/auth/register_screen.dart';
import 'package:matheasy_sn/presentation/screens/bfem/bfem_screen.dart';
import 'package:matheasy_sn/presentation/screens/course/course_detail_screen.dart';
import 'package:matheasy_sn/presentation/screens/course/courses_list_screen.dart';
import 'package:matheasy_sn/presentation/screens/exercise/exercises_screen.dart';
import 'package:matheasy_sn/presentation/screens/home/home_screen.dart';
import 'package:matheasy_sn/presentation/screens/bfem/bfem_quiz_screen.dart';
import 'package:matheasy_sn/presentation/screens/bfem/pdf_viewer_screen.dart';
import 'package:matheasy_sn/presentation/screens/progress/progress_screen.dart';
import 'package:matheasy_sn/presentation/screens/splash/splash_screen.dart';

/// Configuration du routeur de l'application.
///
/// Gère la navigation entre les différents écrans de l'application
/// en utilisant des routes nommées pour un accès facile et maintenable.
/// Intègre une logique de redirection basée sur l'état d'authentification.
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String courses = '/courses';
  static const String courseDetail = '/course-detail';
  static const String exercises = '/exercises';
  static const String bfem = '/bfem';
  static const String pdfViewer = '/pdf-viewer';
  static const String progress = '/progress';

  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: splash,
      refreshListenable: GoRouterRefreshStream(context.read<AuthBloc>().stream),
      routes: [
        GoRoute(
          path: splash,
          name: splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          name: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: register,
          name: register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: home,
          name: home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: courses,
          name: courses,
          builder: (context, state) => const CoursesListScreen(),
        ),
        GoRoute(
          path: '$courseDetail/:slug',
          name: courseDetail,
          builder: (context, state) {
            final slug = state.pathParameters['slug']!;
            return CourseDetailScreen(slug: slug);
          },
        ),
        GoRoute(
          path: '$exercises/:chapterSlug',
          name: exercises,
          builder: (context, state) {
            final chapterSlug = state.pathParameters['chapterSlug']!;
            return ExercisesScreen(chapterSlug: chapterSlug);
          },
        ),
        GoRoute(
          path: bfem,
          name: bfem,
          builder: (context, state) => const BfemScreen(),
        routes: [
          GoRoute(
            path: 'quiz/:year',
            name: 'bfem-quiz',
            builder: (context, state) {
              final year = int.parse(state.pathParameters['year']!);
              return BfemQuizScreen(year: year);
            },
          ),
        ],
        ),
        GoRoute(
        path: '/pdf-viewer',
        name: 'pdf-viewer',
        builder: (context, state) {
          final filePath = state.uri.queryParameters['filePath']!;
          final title = state.uri.queryParameters['title'] ?? 'Document';
          return PdfViewerScreen(filePath: filePath, title: title);
        },
      ),
      GoRoute(
          path: progress,
          name: progress,
          builder: (context, state) => const ProgressScreen(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = context.read<AuthBloc>().state;
        final location = state.uri.toString();

        final isAuthRoute = location == login || location == register;

        // Pendant le chargement ou l'état initial, on reste sur le splash
        if (authState is AuthInitial || authState is AuthLoading) {
            return splash;
        }

        // Si l'utilisateur n'est pas authentifié
        if (authState is AuthUnauthenticated) {
            // S'il est sur une page d'auth, on le laisse, sinon on le redirige vers le login
            return isAuthRoute ? null : login;
        }

        // Si l'utilisateur est authentifié
        if (authState is AuthAuthenticated) {
            // S'il est sur une page d'auth ou le splash, on le redirige vers l'accueil
            return isAuthRoute || location == splash ? home : null;
        }

        return null; // Pas de redirection
      },
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page non trouvée: ${state.error}'),
        ),
      ),
    );
  }
}

/// Permet à GoRouter d'écouter les changements d'un Stream pour rafraîchir
/// l'état de la navigation. Utilisé ici pour écouter les changements
/// d'état du AuthBloc.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }
}