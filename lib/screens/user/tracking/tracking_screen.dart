import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:transport_app/models/trip_tracking.dart';
import 'package:transport_app/services/api_service.dart';
import 'package:transport_app/theme/app_theme.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TextEditingController _tripNumberController =
      TextEditingController(text: 'TRIP-1001');

  TripTracking? _tracking;
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _tripNumberController.dispose();
    super.dispose();
  }

  Future<void> _searchTrip() async {
    final tripNumber = _tripNumberController.text.trim();

    if (tripNumber.isEmpty) {
      setState(() {
        _message = 'Entrez le numéro du trajet';
        _tracking = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final tracking = await ApiService.trackTrip(tripNumber);

    if (!mounted) return;

    setState(() {
      _tracking = tracking;
      _isLoading = false;
      _message = tracking == null ? 'Aucun trajet trouvé avec ce numéro' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tracking = _tracking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi du trajet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rechercher un trajet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Entrez le numéro du trajet pour suivre la position du bus.',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
            const SizedBox(height: 20),
            _TripSearchCard(
              controller: _tripNumberController,
              isLoading: _isLoading,
              onSearch: _searchTrip,
            ),
            if (_message != null) ...[
              const SizedBox(height: 14),
              _MessageBox(message: _message!),
            ],
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (tracking == null)
              const _EmptyTrackingCard()
            else ...[
              _TrackingMapCard(tracking: tracking),
              const SizedBox(height: 20),
              _TripProgressCard(tracking: tracking),
              const SizedBox(height: 20),
              _TrackingDetailsCard(tracking: tracking),
            ],
          ],
        ),
      ),
    );
  }
}

class _TripSearchCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSearch;

  const _TripSearchCard({
    required this.controller,
    required this.isLoading,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                hintText: 'Ex: TRIP-1001',
                prefixIcon: const Icon(FontAwesomeIcons.hashtag, size: 16),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSearch,
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(FontAwesomeIcons.magnifyingGlass, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingMapCard extends StatelessWidget {
  final TripTracking tracking;

  const _TrackingMapCard({required this.tracking});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _TrackingMapPainter(progress: tracking.progressValue),
              ),
            ),
            Positioned(
              left: 18,
              top: 18,
              child: _MapBadge(
                icon: FontAwesomeIcons.route,
                text: tracking.tripNumber,
              ),
            ),
            Positioned(
              right: 18,
              top: 18,
              child: _MapBadge(
                icon: FontAwesomeIcons.satelliteDish,
                text: _statusLabel(tracking.status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingMapPainter extends CustomPainter {
  final double progress;

  _TrackingMapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = AppTheme.secondaryColor
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1;

    for (var x = 28.0; x < size.width; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x + 36, size.height), gridPaint);
    }
    for (var y = 34.0; y < size.height; y += 62) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 28), gridPaint);
    }

    final route = Path()
      ..moveTo(36, size.height - 54)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.72,
        size.width * 0.34,
        size.height * 0.36,
        size.width * 0.52,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.62,
        size.width * 0.72,
        size.height * 0.18,
        size.width - 38,
        54,
      );

    canvas.drawPath(route, roadPaint);

    final metric = route.computeMetrics().first;
    final progressPath = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(progressPath, progressPaint);

    final start = Offset(36, size.height - 54);
    final end = Offset(size.width - 38, 54);
    final busPosition =
        metric.getTangentForOffset(metric.length * progress)!.position;

    _drawStop(canvas, start, AppTheme.primaryColor);
    _drawStop(canvas, end, AppTheme.accentColor);
    _drawBus(canvas, busPosition);
  }

  void _drawStop(Canvas canvas, Offset offset, Color color) {
    final outer = Paint()..color = Colors.white;
    final inner = Paint()..color = color;
    canvas.drawCircle(offset, 14, outer);
    canvas.drawCircle(offset, 8, inner);
  }

  void _drawBus(Canvas canvas, Offset offset) {
    final shadow = Paint()..color = Colors.black.withValues(alpha: 0.14);
    final body = Paint()..color = AppTheme.primaryColor;
    final window = Paint()..color = Colors.white;

    final busRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: offset, width: 46, height: 30),
      const Radius.circular(8),
    );

    canvas.drawRRect(busRect.shift(const Offset(0, 3)), shadow);
    canvas.drawRRect(busRect, body);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: offset.translate(0, -3),
          width: 30,
          height: 9,
        ),
        const Radius.circular(4),
      ),
      window,
    );
    canvas.drawCircle(offset.translate(-13, 13), 4, window);
    canvas.drawCircle(offset.translate(13, 13), 4, window);
  }

  @override
  bool shouldRepaint(covariant _TrackingMapPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _TripProgressCard extends StatelessWidget {
  final TripTracking tracking;

  const _TripProgressCard({required this.tracking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.bus,
                color: AppTheme.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${tracking.departureCity} vers ${tracking.destinationCity}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Text(
                '${tracking.progressPercentage.round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: tracking.progressValue,
              minHeight: 9,
              backgroundColor: AppTheme.backgroundColor,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StopLabel(title: 'Départ', city: tracking.departureCity),
              _StopLabel(
                title: 'Arrivée estimée',
                city: tracking.destinationCity,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackingDetailsCard extends StatelessWidget {
  final TripTracking tracking;

  const _TrackingDetailsCard({required this.tracking});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: FontAwesomeIcons.clock,
            label: 'Dernière mise à jour',
            value: tracking.lastLocationUpdate == null
                ? 'Non disponible'
                : formatter.format(tracking.lastLocationUpdate!),
          ),
          const Divider(height: 24),
          _DetailRow(
            icon: FontAwesomeIcons.locationDot,
            label: 'Position actuelle',
            value: tracking.currentLatitude == null
                ? 'En attente de signal'
                : '${tracking.currentLatitude!.toStringAsFixed(4)}, '
                    '${tracking.currentLongitude!.toStringAsFixed(4)}',
          ),
          const Divider(height: 24),
          _DetailRow(
            icon: FontAwesomeIcons.userTie,
            label: 'Chauffeur',
            value: tracking.driverName ?? 'Non assigné',
          ),
          const Divider(height: 24),
          _DetailRow(
            icon: FontAwesomeIcons.bus,
            label: 'Véhicule',
            value: [
              tracking.vehicleName,
              tracking.vehiclePlate,
            ].whereType<String>().join(' - '),
          ),
        ],
      ),
    );
  }
}

class _EmptyTrackingCard extends StatelessWidget {
  const _EmptyTrackingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            FontAwesomeIcons.locationCrosshairs,
            size: 34,
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: 14),
          Text(
            'Suivi prêt',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Recherchez un numéro de trajet pour voir la progression du bus.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondaryColor),
          ),
        ],
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  final String message;

  const _MessageBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MapBadge({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StopLabel extends StatelessWidget {
  final String title;
  final String city;

  const _StopLabel({
    required this.title,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 16, color: AppTheme.primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty ? 'Non disponible' : value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _statusLabel(String status) {
  switch (status) {
    case 'IN_PROGRESS':
      return 'En direct';
    case 'ARRIVED':
      return 'Arrivé';
    case 'CANCELLED':
      return 'Annulé';
    default:
      return 'Programmé';
  }
}
