import 'package:flutter/material.dart';

void main() {
  runApp(const StudyPalApp());
}

// ============================================================
// APP
// ============================================================

class StudyPalApp extends StatelessWidget {
  const StudyPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'StudyPal',
      routerDelegate: studyRouter,
      routeInformationParser: StudyRouteInformationParser(),
    );
  }
}

// ============================================================
// ROUTER
// ============================================================

final StudyRouterDelegate studyRouter = StudyRouterDelegate();

class StudyRouteInformationParser
    extends RouteInformationParser<StudyPage> {
  @override
  Future<StudyPage> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.path == '/exams') {
      return const StudyPage.exams();
    }

    if (uri.path == '/teachers') {
      return const StudyPage.teachers();
    }

    return const StudyPage.home();
  }

  @override
  RouteInformation restoreRouteInformation(
    StudyPage configuration,
  ) {
    if (configuration.showTeachers) {
      return RouteInformation(
        uri: Uri.parse('/teachers'),
      );
    }

    if (configuration.showExams) {
      return RouteInformation(
        uri: Uri.parse('/exams'),
      );
    }

    return RouteInformation(
      uri: Uri.parse('/'),
    );
  }
}

// ============================================================
// ROUTER DELEGATE - NAVIGATOR 2.0
// ============================================================

class StudyRouterDelegate extends RouterDelegate<StudyPage>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StudyPage> {
  StudyRouterDelegate()
      : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  bool showExams = false;
  bool showTeachers = false;

  // ----------------------------
  // GO TO EXAMS
  // ----------------------------

  void goToExams() {
    showExams = true;
    showTeachers = false;
    notifyListeners();
  }

  // ----------------------------
  // GO TO TEACHERS
  // ----------------------------

  void goToTeachers() {
    showExams = true;
    showTeachers = true;
    notifyListeners();
  }

  // ----------------------------
  // GO HOME
  // ----------------------------

  void goHome() {
    showExams = false;
    showTeachers = false;
    notifyListeners();
  }

  // ----------------------------
  // GO BACK TO EXAMS
  // ----------------------------

  void goBackToExams() {
    showTeachers = false;
    showExams = true;
    notifyListeners();
  }

  // ----------------------------
  // CURRENT ROUTE
  // ----------------------------

  @override
  StudyPage? get currentConfiguration {
    if (showTeachers) {
      return const StudyPage.teachers();
    }

    if (showExams) {
      return const StudyPage.exams();
    }

    return const StudyPage.home();
  }

  // ----------------------------
  // NAVIGATOR
  // ----------------------------

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // SCREEN 1
        const MaterialPage(
          key: ValueKey('HomePage'),
          child: StudyHomeScreen(),
        ),

        // SCREEN 2
        if (showExams)
          MaterialPage(
            key: const ValueKey('ExamsPage'),
            child: ExamsScreen(
              onBack: goHome,
              onTeachers: goToTeachers,
            ),
          ),

        // SCREEN 3
        if (showTeachers)
          MaterialPage(
            key: const ValueKey('TeachersPage'),
            child: TeachersScreen(
              onBack: goBackToExams,
            ),
          ),
      ],
      onDidRemovePage: (page) {
        if (showTeachers) {
          goBackToExams();
        } else if (showExams) {
          goHome();
        }
      },
    );
  }

  // ----------------------------
  // URL ROUTING
  // ----------------------------

  @override
  Future<void> setNewRoutePath(
    StudyPage configuration,
  ) async {
    showExams = configuration.showExams;
    showTeachers = configuration.showTeachers;
    notifyListeners();
  }
}

// ============================================================
// ROUTE CONFIGURATION
// ============================================================

class StudyPage {
  final bool showExams;
  final bool showTeachers;

  const StudyPage.home()
      : showExams = false,
        showTeachers = false;

  const StudyPage.exams()
      : showExams = true,
        showTeachers = false;

  const StudyPage.teachers()
      : showExams = true,
        showTeachers = true;
}

// ============================================================
// SCREEN 1 - STUDYPAL WELCOME
// ============================================================

class StudyHomeScreen extends StatelessWidget {
  const StudyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF737AA8),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                25,
                45,
                25,
                35,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F0F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.school_outlined,
                        size: 115,
                        color: Color(0xFF737AA8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'StudyPal',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF343434),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your pocket guide\nfor school',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Color(0xFF666666),
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: studyRouter.goToExams,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF737AA8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Begin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 2 - EXAMS
// ============================================================

class ExamsScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onTeachers;

  const ExamsScreen({
    super.key,
    required this.onBack,
    required this.onTeachers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF737AA8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // TOP BAR
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Exams',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upcoming Exams',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ExamCard(
                        subject: 'Basic Algebra',
                        department: 'Maths II',
                        date: 'October 10, 2026',
                        color: const Color(0xFF737AA8),
                        icon: Icons.calculate_outlined,
                      ),

                      const SizedBox(height: 15),

                      ExamCard(
                        subject: 'Skills in Production',
                        department: 'Proficiency Course',
                        date: 'November 1, 2026',
                        color: const Color(0xFFD99A35),
                        icon: Icons.auto_graph,
                      ),

                      const Spacer(),

                      // GO TO SCREEN 3
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: onTeachers,
                          icon: const Icon(
                            Icons.people_outline,
                          ),
                          label: const Text(
                            'View Teachers',
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF737AA8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sign up for another exam',
                                ),
                              ),
                            );
                          },
                          style:
                              OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color(0xFF737AA8),
                            side: const BorderSide(
                              color: Color(0xFF737AA8),
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Sign up for another exam',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EXAM CARD
// ============================================================

class ExamCard extends StatelessWidget {
  final String subject;
  final String department;
  final String date;
  final Color color;
  final IconData icon;

  const ExamCard({
    super.key,
    required this.subject,
    required this.department,
    required this.date,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      department,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      'Selected $subject',
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SCREEN 3 - TEACHERS
// ============================================================

class TeachersScreen extends StatelessWidget {
  final VoidCallback onBack;

  const TeachersScreen({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF737AA8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // TOP BAR
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Teachers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 18),

              // TEACHERS CONTAINER
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Teachers',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TeacherCard(name: 'Mr. Han'),

                      const SizedBox(height: 10),

                      TeacherCard(name: 'Ms. Cat'),

                      const SizedBox(height: 10),

                      TeacherCard(
                        name: 'Mr. Mackenzie',
                      ),

                      const SizedBox(height: 10),

                      TeacherCard(name: 'Mrs. Petty'),

                      const SizedBox(height: 10),

                      TeacherCard(name: 'Mr. Smith'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TEACHER CARD
// ============================================================

class TeacherCard extends StatelessWidget {
  final String name;

  const TeacherCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFE0E0E0),
            child: Icon(
              Icons.person,
              color: Color(0xFF737AA8),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Icon(
            Icons.chat_bubble_outline,
            size: 20,
            color: Colors.grey.shade600,
          ),

          const SizedBox(width: 12),

          Icon(
            Icons.more_horiz,
            size: 22,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}