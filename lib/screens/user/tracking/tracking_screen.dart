import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transport_app/theme/app_theme.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const progress = 0.58;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi du trajet'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rechercher un trajet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Entrez le numéro du trajet pour suivre la position du bus.',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
            SizedBox(height: 20),
            _TripSearchCard(),
            SizedBox(height: 24),
            _TrackingMapCard(progress: progress),
            SizedBox(height: 20),
            _TripProgressCard(progress: progress),
            SizedBox(height: 20),
            _TrackingDetailsCard(),
          ],
        ),
      ),
    );
  }
}

class _TripSearchCard extends StatelessWidget {
  const _TripSearchCard();

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
              onPressed: () {},
              child: const Icon(FontAwesomeIcons.magnifyingGlass, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingMapCard extends StatelessWidget {
  final double progress;

  const _TrackingMapCard({required this.progress});

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
                painter: _TrackingMapPainter(progress: progress),
              ),
            ),
            const Positioned(
              left: 18,
              top: 18,
              child: _MapBadge(
                icon: FontAwesomeIcons.route,
                text: 'TRIP-1001',
              ),
            ),
            const Positioned(
              right: 18,
              top: 18,
              child: _MapBadge(
                icon: FontAwesomeIcons.satelliteDish,
                text: 'En direct',
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
  final double progress;

  const _TripProgressCard({required this.progress});

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
              const Expanded(
                child: Text(
                  'Rosso vers Nouakchott',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
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
              value: progress,
              minHeight: 9,
              backgroundColor: AppTheme.backgroundColor,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.secondaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StopLabel(title: 'Départ', city: 'Rosso'),
              _StopLabel(title: 'Arrivée estimée', city: 'Nouakchott'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackingDetailsCard extends StatelessWidget {
  const _TrackingDetailsCard();

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
      child: const Column(
        children: [
          _DetailRow(
            icon: FontAwesomeIcons.clock,
            label: 'Dernière mise à jour',
            value: 'Il y a 2 min',
          ),
          Divider(height: 24),
          _DetailRow(
            icon: FontAwesomeIcons.locationDot,
            label: 'Position actuelle',
            value: 'En route vers Nouakchott',
          ),
          Divider(height: 24),
          _DetailRow(
            icon: FontAwesomeIcons.userTie,
            label: 'Chauffeur',
            value: 'Ahmed Salem',
          ),
        ],
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
                value,
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
