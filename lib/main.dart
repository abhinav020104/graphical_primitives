import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Graphics Primitives',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey; // Disabled color
                }
                return Colors.blue; // Enabled color
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.black87; // Disabled text color
                }
                return Colors.white; // Enabled text color
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      home: DrawingCanvas(),
    );
  }
}

class DrawingCanvas extends StatefulWidget {
  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Shape> shapes = [];

  void addShape(Shape shape) {
    setState(() {
      shapes.add(shape);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Graphics Primitives'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 300, // Limit height of canvas to avoid overflow
                child: CustomPaint(
                  painter: ShapesPainter(shapes),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0), // Add margin to the top
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addShape(Shape.rectangle(50, 50, 150, 150));
                  },
                  child: Text('Rectangle'),
                ),
                ElevatedButton(
                  onPressed: () {
                    addShape(Shape.circle(200, 150, 50));
                  },
                  child: Text('Circle'),
                ),
                ElevatedButton(
                  onPressed: () {
                    addShape(Shape.line(300, 50, 400, 150));
                  },
                  child: Text('Line'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Shape {
  final ShapeType type;
  final double x1, y1, x2, y2, radius;

  Shape.rectangle(this.x1, this.y1, this.x2, this.y2)
      : type = ShapeType.rectangle,
        radius = 0;

  Shape.circle(this.x1, this.y1, this.radius)
      : type = ShapeType.circle,
        x2 = 0,
        y2 = 0;

  Shape.line(this.x1, this.y1, this.x2, this.y2)
      : type = ShapeType.line,
        radius = 0;

  bool get isRectangle => type == ShapeType.rectangle;
  bool get isCircle => type == ShapeType.circle;
  bool get isLine => type == ShapeType.line;
}

enum ShapeType { rectangle, circle, line }

class ShapesPainter extends CustomPainter {
  final List<Shape> shapes;

  ShapesPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Clear the canvas
    canvas.drawColor(Colors.white, BlendMode.src);

    // Draw shapes
    for (var shape in shapes) {
      if (shape.isRectangle) {
        paint.color = Colors.blue; // Example color
        canvas.drawRect(Rect.fromLTRB(shape.x1, shape.y1, shape.x2, shape.y2), paint);
      } else if (shape.isCircle) {
        paint.color = Colors.yellow; // Example color
        canvas.drawCircle(Offset(shape.x1, shape.y1), shape.radius, paint);
      } else if (shape.isLine) {
        paint.color = Colors.green; // Example color
        canvas.drawLine(Offset(shape.x1, shape.y1), Offset(shape.x2, shape.y2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
