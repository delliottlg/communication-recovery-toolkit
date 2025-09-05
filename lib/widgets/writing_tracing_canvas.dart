import 'package:flutter/material.dart';

/// Captures freehand strokes and renders a background letter/number to trace.
/// Note: Uses stroked glyph (solid outline). Dotted effect approximated by light stroke and guide lines.
class WritingTracingCanvas extends StatefulWidget {
  final String target;
  final double fontSize;
  final bool showGuides;
  final ValueChanged<double>? onAccuracy;
  final Color? guideColor;

  const WritingTracingCanvas({
    super.key,
    required this.target,
    required this.fontSize,
    required this.showGuides,
    this.onAccuracy,
    this.guideColor,
  });

  @override
  State<WritingTracingCanvas> createState() => _WritingTracingCanvasState();
}

class _WritingTracingCanvasState extends State<WritingTracingCanvas> {
  final List<Offset?> _points = []; // null indicates stroke break
  Rect? _glyphRect; // approximate bounding box for glyph

  void _updateAccuracy() {
    if (widget.onAccuracy == null || _glyphRect == null) return;
    final rect = _glyphRect!;
    int inside = 0, total = 0;
    for (final p in _points) {
      if (p == null) continue;
      total++;
      if (rect.inflate(widget.fontSize * 0.1).contains(p)) inside++;
    }
    if (total == 0) return;
    final acc = inside / total;
    widget.onAccuracy!(acc);
  }

  void _clear() {
    setState(() {
      _points.clear();
    });
    _updateAccuracy();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanStart: (d) {
            setState(() {
              _points.add(d.localPosition);
            });
          },
          onPanUpdate: (d) {
            setState(() {
              _points.add(d.localPosition);
            });
            _updateAccuracy();
          },
          onPanEnd: (_) {
            setState(() { _points.add(null); });
            _updateAccuracy();
          },
          child: CustomPaint(
            painter: _TracingPainter(
              target: widget.target,
              fontSize: widget.fontSize,
              points: _points,
              showGuides: widget.showGuides,
              onGlyphRect: (r) => _glyphRect = r,
              guideColor: widget.guideColor ?? Colors.grey.shade600,
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: IconButton(
                    onPressed: _clear,
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TracingPainter extends CustomPainter {
  final String target;
  final double fontSize;
  final List<Offset?> points;
  final bool showGuides;
  final ValueChanged<Rect> onGlyphRect;
  final Color guideColor;

  _TracingPainter({
    required this.target,
    required this.fontSize,
    required this.points,
    required this.showGuides,
    required this.onGlyphRect,
    required this.guideColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Notebook line guides
    if (showGuides) {
      final guidePaint = Paint()
        ..color = guideColor.withOpacity(0.18)
        ..strokeWidth = 1;
      final spacing = fontSize * 0.6;
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), guidePaint);
      }
    }

    // Draw target glyph centered
    // First pass: soft fill for visibility
    final tpFill = TextPainter(
      text: TextSpan(
        text: target,
        style: TextStyle(
          color: guideColor.withOpacity(0.20),
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    )..layout(maxWidth: size.width);

    // Second pass: stroke outline
    final tp = TextPainter(
      text: TextSpan(
        text: target,
        style: TextStyle(
          color: guideColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = fontSize * 0.06
            ..color = guideColor,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    )..layout(maxWidth: size.width);
    final offset = Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2);
    tpFill.paint(canvas, offset);
    tp.paint(canvas, offset);

    // Report approximate glyph rect
    final glyphRect = offset & Size(tp.width, tp.height);
    onGlyphRect(glyphRect);

    // Render user's strokes
    final strokePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = fontSize * 0.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw polyline segments
    Offset? prev;
    for (final p in points) {
      if (p == null) {
        prev = null; continue;
      }
      if (prev != null) {
        canvas.drawLine(prev, p, strokePaint);
      }
      prev = p;
    }

    // Light dotted overlay along baseline for a dotted hint
    final dotPaint = Paint()..color = guideColor.withOpacity(0.6);
    final baselineY = glyphRect.bottom - fontSize * 0.15;
    for (double x = glyphRect.left; x < glyphRect.right; x += fontSize * 0.08) {
      canvas.drawCircle(Offset(x, baselineY), fontSize * 0.01, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.target != target ||
        oldDelegate.showGuides != showGuides;
  }
}
