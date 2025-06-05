import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key, required this.child});
  final Widget child;

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  late final StreamSubscription<List<ConnectivityResult>> _sub;
  bool _online = true;

  @override
  void initState() {
    super.initState();
    // Initial status
    Connectivity().checkConnectivity().then(_handleResults);
    // Listen for changes
    _sub = Connectivity()
        .onConnectivityChanged
        .listen(_handleResults);
  }

  void _handleResults(List<ConnectivityResult> results) {
    final online = !results.contains(ConnectivityResult.none);
    if (!mounted) return;
    setState(() => _online = online);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_online)
          Material(
            color: Colors.red,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                width: double.infinity,
                height: 28,
                child: Center(
                  child: Text(
                    'No internet connection',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}
