import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/app_constants.dart';
import 'widgets/portal_error_view.dart';
import 'widgets/portal_progress_bar.dart';

class ClientPortalScreen extends StatefulWidget {
  const ClientPortalScreen({super.key});

  @override
  State<ClientPortalScreen> createState() => _ClientPortalScreenState();
}

class _ClientPortalScreenState extends State<ClientPortalScreen> {
  late final WebViewController _controller;
  var _progress = 0;
  var _hasMainFrameError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: _updateProgress,
          onPageStarted: (_) => _markPageStarted(),
          onPageFinished: _handlePageFinished,
          onWebResourceError: _handleWebResourceError,
          onNavigationRequest: _handleNavigation,
        ),
      );
    unawaited(_configureAndLoadPortal());
  }

  Future<void> _configureAndLoadPortal() async {
    if (await _controller.supportsSetScrollBarsEnabled()) {
      await Future.wait([
        _controller.setVerticalScrollBarEnabled(false),
        _controller.setHorizontalScrollBarEnabled(false),
      ]);
    }
    await _controller.loadRequest(Uri.parse(AppConstants.portalUrl));
  }

  void _updateProgress(int progress) {
    if (mounted) setState(() => _progress = progress);
  }

  void _markPageStarted() {
    if (!mounted) return;
    setState(() {
      _hasMainFrameError = false;
      _progress = 0;
    });
  }

  Future<void> _handlePageFinished(String _) async {
    _updateProgress(100);
    await _controller.runJavaScript('''
      (() => {
        const id = 'tilottomaa-hide-scrollbars';
        if (document.getElementById(id)) return;
        const style = document.createElement('style');
        style.id = id;
        style.textContent = `
          html, body { scrollbar-width: none !important; }
          *::-webkit-scrollbar { display: none !important; width: 0 !important; height: 0 !important; }
        `;
        document.head.appendChild(style);
      })();
    ''');
  }

  void _handleWebResourceError(WebResourceError error) {
    if ((error.isForMainFrame ?? true) && mounted) {
      setState(() => _hasMainFrameError = true);
    }
  }

  FutureOr<NavigationDecision> _handleNavigation(
    NavigationRequest request,
  ) async {
    final uri = Uri.tryParse(request.url);
    if (uri == null) return NavigationDecision.prevent;
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return NavigationDecision.navigate;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) _showUnsupportedLinkMessage();
    } on PlatformException {
      _showUnsupportedLinkMessage();
    }
    return NavigationDecision.prevent;
  }

  void _showUnsupportedLinkMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No application is available to open this link.'),
      ),
    );
  }

  Future<void> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    } else {
      await SystemNavigator.pop();
    }
  }

  void _retry() {
    setState(() => _hasMainFrameError = false);
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_handleBack());
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_hasMainFrameError) PortalErrorView(onRetry: _retry),
              PortalProgressBar(
                progress: _progress,
                hidden: _hasMainFrameError || _progress >= 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
