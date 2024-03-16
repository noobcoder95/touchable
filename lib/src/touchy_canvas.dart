import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:touchable/src/shape_handler.dart';
import 'package:touchable/src/shapes/arc.dart';
import 'package:touchable/src/shapes/circle.dart';
import 'package:touchable/src/shapes/clip.dart';
import 'package:touchable/src/shapes/line.dart';
import 'package:touchable/src/shapes/oval.dart';
import 'package:touchable/src/shapes/path.dart';
import 'package:touchable/src/shapes/point.dart';
import 'package:touchable/src/shapes/rectangle.dart';
import 'package:touchable/src/shapes/rounded_rectangle.dart';
import 'package:touchable/src/shapes/util.dart';
import 'package:touchable/touchable.dart';

class TouchyCanvas {
  final Canvas _canvas;
  final Object? panningShapeId;
  late final ShapeHandler _shapeHandler;

  ///[TouchyCanvas] helps you add gesture callbacks to the shapes you draw.
  ///
  /// [context] is the BuildContext that is obtained from the [CanvasTouchDetector] widget's builder function.
  /// The parameter [canvas] is the [Canvas] object that you get in your [paint] method inside [CustomPainter]
  TouchyCanvas(
      BuildContext context,
      this._canvas, {ScrollController? scrollController,
        AxisDirection scrollDirection = AxisDirection.down,
        GestureDragEndCallback? onPanEnd,
        GestureDragCancelCallback? onPanCancel,
        this.panningShapeId}) {
    _shapeHandler = ShapeHandler(panningShapeId);
    var touchController = TouchDetectionController.of(context);
    touchController?.addListener((Gesture gesture) {
      if (gesture.gestureType == GestureType.onPanEnd) {
        onPanEnd?.call(gesture.gestureDetail as DragEndDetails);
      } else if (gesture.gestureType == GestureType.onPanCancel) {
        onPanCancel?.call();
      } else {
        _shapeHandler.handleGestureEvent(
          gesture,
          touchController.previousTouchState,
          scrollController: scrollController,
          direction: scrollDirection,
        );
      }
    });
  }

  void clipPath(Path path, {bool doAntiAlias = true}) {
    _canvas.clipPath(path, doAntiAlias: doAntiAlias);
    _shapeHandler.addShape(ClipPathShape(path));
  }

  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {
    _canvas.clipRRect(rrect, doAntiAlias: doAntiAlias);
    _shapeHandler.addShape(ClipRRectShape(rrect));
  }

  void clipRect(Rect rect, {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {
    _canvas.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);
    _shapeHandler.addShape(ClipRectShape(rect, clipOp: clipOp));
  }

  void drawCircle(
    Offset c,
    double radius,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    StrokeHitBehavior? strokeHitBehavior,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawCircle(c, radius, paint);
    _shapeHandler.addShape(Circle(
        center: c,
        radius: radius,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        strokeHitBehavior: strokeHitBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawLine(
    Offset p1,
    Offset p2,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawLine(p1, p2, paint);
    _shapeHandler.addShape(Line(p1, p2,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawOval(
    Rect rect,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    StrokeHitBehavior? strokeHitBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawOval(rect, paint);
    _shapeHandler.addShape(Oval(rect,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        strokeHitBehavior: strokeHitBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawParagraph(Paragraph paragraph, Offset offset) {
    _canvas.drawParagraph(paragraph, offset);
    // _shapeHandler.addShape(Rectangle(Rect.fromLTWH(offset.dx, offset.dy, paragraph.width, paragraph.height),
    //     paint: Paint(), gestureMap: {}));
  }

  void drawPath(
    Path path,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawPath(path, paint);
    _shapeHandler.addShape(PathShape(path,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawPoints(
    PointMode pointMode,
    List<Offset> points,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
        /// Only applies when [pointMode] is [PointMode.polygon]
    StrokeHitBehavior? strokeHitBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawPoints(pointMode, points, paint);
    _shapeHandler.addShape(Point(pointMode, points,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        strokeHitBehavior: strokeHitBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawRRect(
    RRect rrect,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    StrokeHitBehavior? strokeHitBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawRRect(rrect, paint);
    _shapeHandler.addShape(RoundedRectangle(rrect,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        strokeHitBehavior: strokeHitBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawRawPoints(
    PointMode pointMode,
    Float32List points,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawRawPoints(pointMode, points, paint);
    List<Offset> offsetPoints = [];
    for (int i = 0; i < points.length; i += 2) {
      offsetPoints.add(Offset(points[i], points[i + 1]));
    }
    _shapeHandler.addShape(Point(pointMode, offsetPoints,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawRect(
    Rect rect,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    StrokeHitBehavior? strokeHitBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawRect(rect, paint);
    _shapeHandler.addShape(Rectangle(rect,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        strokeHitBehavior: strokeHitBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawShadow(Path path, Color color, double elevation, bool transparentOccluder) {
    _canvas.drawShadow(path, color, elevation, transparentOccluder);
    // _shapeHandler.addShape(PathShape(path));
  }

  void drawImage(
    Image image,
    Offset p,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawImage(image, p, paint);
    _shapeHandler.addShape(Rectangle(Rect.fromLTWH(p.dx, p.dy, image.width.toDouble(), image.height.toDouble()),
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        )));
  }

  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint, {
    HitTestBehavior? hitTestBehavior,
    GestureTapDownCallback? onTapDown,
    PaintingStyle? paintStyleForTouch,
    GestureTapUpCallback? onTapUp,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureForcePressStartCallback? onForcePressStart,
    GestureForcePressEndCallback? onForcePressEnd,
    GestureForcePressPeakCallback? onForcePressPeak,
    GestureForcePressUpdateCallback? onForcePressUpdate,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragDownCallback? onPanDown,
    GestureTapDownCallback? onSecondaryTapDown,
    GestureTapUpCallback? onSecondaryTapUp,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    PointerHoverEventListener? onHover,
    GestureTapCancelCallback? onTapCancel
  }) {
    _canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
    var arc = Arc(rect, startAngle, sweepAngle, useCenter,
        paint: paint,
        hitTestBehavior: hitTestBehavior,
        gestureMap: TouchCanvasUtil.getGestureCallbackMap(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onLongPressStart: onLongPressStart,
          onLongPressEnd: onLongPressEnd,
          onLongPressMoveUpdate: onLongPressMoveUpdate,
          onForcePressStart: onForcePressStart,
          onForcePressEnd: onForcePressEnd,
          onForcePressPeak: onForcePressPeak,
          onForcePressUpdate: onForcePressUpdate,
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanDown: onPanDown,
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTapUp: onSecondaryTapUp,
          onEnter: onEnter,
          onExit: onExit,
          onHover: onHover,
          onTapCancel: onTapCancel,
        ));
    _shapeHandler.addShape(arc);
  }
}
