import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Force portrait mode for a better consistent experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Make status bar transparent for premium immersive look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0F172A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منظّم الإنفاق الذكي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AE'), // Force RTL layout
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6366F1), // Indigo
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark slate
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
        ),
      ),
      home: const MainWebViewScreen(),
    );
  }
}

class MainWebViewScreen extends StatefulWidget {
  const MainWebViewScreen({super.key});

  @override
  State<MainWebViewScreen> createState() => _MainWebViewScreenState();
}

class _MainWebViewScreenState extends State<MainWebViewScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  double _loadingProgress = 0.0;
  bool _isConnected = true;
  bool _hasError = false;
  bool _canPop = false;

  late final StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _initConnectivityListener();
    _initWebViewController();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = !result.contains(ConnectivityResult.none);
    });
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final connected = !results.contains(ConnectivityResult.none);
      setState(() {
        _isConnected = connected;
        if (connected && _hasError) {
          _hasError = false;
          _webViewController.reload();
        }
      });
    });
  }

  void _initWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0F172A))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100.0;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _loadingProgress = 0.0;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Check for connection/network failures
            if (error.errorType == WebResourceErrorType.hostLookup ||
                error.errorType == WebResourceErrorType.connect ||
                error.errorType == WebResourceErrorType.timeout ||
                error.errorType == WebResourceErrorType.unknown) {
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://salary-organizer-499942098323.europe-west1.run.app'));
  }

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'خروج من التطبيق',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        content: const Text(
          'هل تريد بالتأكيد إغلاق تطبيق منظم الإنفاق؟',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontFamily: 'Roboto',
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'خروج',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _handleRefresh() async {
    if (_isConnected) {
      setState(() {
        _hasError = false;
      });
      await _webViewController.reload();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لا يتوفر اتصال بالإنترنت حالياً.',
            textAlign: TextAlign.right,
          ),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        final canGoBack = await _webViewController.canGoBack();
        if (canGoBack) {
          await _webViewController.goBack();
        } else {
          final shouldExit = await _showExitConfirmationDialog();
          if (shouldExit) {
            setState(() {
              _canPop = true;
            });
            // Delay slightly to let state register, then pop
            Future.delayed(const Duration(milliseconds: 50), () {
              SystemNavigator.pop();
            });
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Main WebView
              if (_isConnected && !_hasError)
                WebViewWidget(controller: _webViewController)
              else
                _buildOfflineOrErrorScreen(),

              // Top Linear Progress Bar
              if (_isLoading && _isConnected && !_hasError)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 3,
                  child: LinearProgressIndicator(
                    value: _loadingProgress > 0 ? _loadingProgress : null,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF6366F1),
                    ),
                  ),
                ),

              // Splash Loading Screen Overlay (Only shown on initial startup load)
              if (_isLoading && _loadingProgress == 0 && _isConnected && !_hasError)
                _buildSplashOverlay(),
            ],
          ),
        ),
        // Floating action buttons for refresh and navigation helper
        floatingActionButton: (!_isConnected || _hasError)
            ? null
            : Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: FloatingActionButton(
                  onPressed: _handleRefresh,
                  mini: true,
                  backgroundColor: const Color(0xFF1E293B).withOpacity(0.8),
                  foregroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF334155), width: 1),
                  ),
                  child: const Icon(Icons.refresh, size: 20),
                ),
              ),
      ),
    );
  }

  Widget _buildSplashOverlay() {
    return Container(
      color: const Color(0xFF0F172A),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(
              color: Color(0xFF6366F1),
              size: 80.0,
            ),
            SizedBox(height: 24),
            Text(
              'جاري تحميل منظّم الإنفاق...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineOrErrorScreen() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: Color(0xFFEF4444),
                size: 72,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'لا يوجد اتصال بالإنترنت',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'يرجى التحقق من اتصالك بالشبكة والضغط على زر إعادة المحاولة لتحميل الميزانية وتتبع الإنفاق.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                _checkInitialConnection();
                if (_isConnected) {
                  setState(() {
                    _hasError = false;
                    _isLoading = true;
                  });
                  await _webViewController.reload();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'ما زلت غير متصل بالإنترنت. يرجى المحاولة مرة أخرى.',
                        textAlign: TextAlign.right,
                      ),
                      backgroundColor: Color(0xFFEF4444),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.replay_rounded, color: Colors.white),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
