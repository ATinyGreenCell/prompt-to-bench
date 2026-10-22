$fn = 128;

// --- Dimensions ---
// Knob outer diameter
D_OUTER = 30;
// Knob height
H_KNOB = 15;
// Shaft diameter (for reference)
D_SHAFT = 6;

// D-shaft bore dimensions
// Total depth of bore
D_BORE_DEPTH = 12;
// Diameter of the circular part of the bore
D_BORE_CIRCLE = 6.2;
// Distance from the flat cut to the opposite side of the circle
D_BORE_FLAT_TO_CURVE = 4.7;

// Grip grooves dimensions
N_GROOVES = 18;
D_GROOVE = 2; // Diameter of the half-cylinder groove

// Pointer groove dimensions
W_POINTER = 1.5; // Width
D_POINTER = 1;   // Depth

// --- Calculations ---
// Radius of the outer cylinder
R_OUTER = D_OUTER / 2;
// Radius of the circular part of the D-bore
R_BORE_CIRCLE = D_BORE_CIRCLE / 2;
// Radius of the grip grooves
R_GROOVE = D_GROOVE / 2;
// Radius of the pointer groove (half width)
R_POINTER = W_POINTER / 2;

// D-bore geometry calculations
// The distance from the flat to the far edge of the circle is 4.7mm.
// The radius is 3.1mm.
// Therefore, the flat is located at x = 3.1 - 4.7 = -1.6mm relative to the circle center.
// The flat extends from x = -1.6 to x = 0 (if we consider the circle center as origin and the flat is on the left).
// Wait, if the distance from flat to far edge is 4.7, and radius is 3.1.
// Far edge is at +3.1. Flat is at 3.1 - 4.7 = -1.6.
// So the D-shape is the circle MINUS the rectangle from x=-3.1 to x=-1.6.
// Width of the cut rectangle = 1.6mm.
D_BORE_CUT_WIDTH = R_BORE_CIRCLE - D_BORE_FLAT_TO_CURVE;

// --- Construction ---

module knob() {
    // 1. Create the main cylinder body
    // Centered at origin, resting on XY plane (z=0)
    cylinder(h = H_KNOB, r = R_OUTER, $fn = 128);

    // 2. Create the D-shaped blind bore
    // We use a difference to cut the hole.
    // The hole starts at z=0 and goes up to D_BORE_DEPTH.
    // We construct the D-shape as a union of a circle and a rectangle to ensure clean geometry.
    // Then we subtract this union from the main body.
    
    translate([0, 0, 0]) {
        difference() {
            // The solid to be cut (the hole shape)
            // We create the D-shape profile using a union of a circle and a rectangle.
            // Circle: Radius 3.1, centered at 0,0.
            // Rectangle: To create the flat side.
            // The flat is at x = -1.6. The circle goes to x = -3.1.
            // So we need a rectangle from x = -1.6 to x = 0? No.
            // The D-shape is the circle MINUS the rectangle [-3.1, -1.6] x [-3.1, 3.1].
            // But to make it easier to subtract from the main knob, let's build the positive D-shape.
            // Positive D-shape = Circle (radius 3.1) UNION Rectangle (from x=-1.6 to x=3.1, y=-3.1 to 3.1)?
            // No, that would make a weird shape.
            // Let's stick to: D-shape = Circle - Rectangle(Cut).
            // But we are inside a difference() that cuts the main knob.
            // So we need to define the D-shape volume.
            // Volume = (Circle Volume) - (Rectangle Volume).
            // But we can't do subtraction inside a difference if we want to subtract the result from the main body.
            // We need: MainBody - (Circle - Rectangle) = MainBody - Circle + Rectangle.
            // This is getting complicated.
            // Simpler approach: Define the D-shape as a union of two parts:
            // Part A: Rectangle from x=-1.6 to x=3.1, y=-3.1 to 3.1.
            // Part B: Circle of radius 3.1 centered at 0,0.
            // Union of A and B creates the D-shape.
            // Let's verify:
            // Circle covers x in [-3.1, 3.1].
            // Rectangle covers x in [-1.6, 3.1].
            // Union covers x in [-3.1, 3.1] (from circle) and y in [-3.1, 3.1] for x in [-1.6, 3.1].
            // Wait, the circle has curved edges. The rectangle has straight edges.
            // The union of a circle and a rectangle that overlaps will create the D-shape.
            // The rectangle should cover the "flat" part.
            // The flat part is the region where the circle is cut.
            // The cut is from x=-3.1 to x=-1.6.
            // So the remaining shape has a flat edge at x=-1.6.
            // The shape exists for x > -1.6 as a rectangle? No, the circle exists there too.
            // The shape exists for x < -1.6 only if it's part of the circle.
            // But the D-shape has NO material for x < -1.6.
            // So the D-shape is the circle MINUS the region x < -1.6.
            // So the D-shape is the union of:
            // 1. The circle.
            // 2. A rectangle that fills the hole? No.
            // Let's just use the difference logic directly.
            // We want to cut a D-hole.
            // D-hole = Circle - Rectangle(Cut).
            // So we subtract (Circle - Rectangle) from the main body.
            // Main - (Circle - Rect) = Main - Circle + Rect.
            // So we subtract the Circle, and ADD the Rectangle?
            // No, we are in a difference() block.
            // difference() { Main; Hole; }
            // Hole = Circle - Rectangle.
            // So we need to construct the Hole volume.
            // Hole = (Circle) difference (Rectangle).
            // So:
            // translate([0,0,0]) {
            //   difference() {
            //     cylinder(..., r=R_BORE_CIRCLE, ...); // Circle
            //     translate([-3.1, -3.1, 0]) cube([1.6, 6.2, D_BORE_DEPTH]); // Cut rectangle
            //   }
            // }
            // This creates the D-hole.
            // Then we subtract this D-hole from the main knob.
            // But wait, the main knob is already defined.
            // So:
            // difference() {
            //   main_cylinder;
            //   // Cut the D-hole
            //   translate([0,0,0]) {
            //     difference() {
            //       cylinder(h=D_BORE_DEPTH, r=R_BORE_CIRCLE, $fn=128);
            //       // Cut the flat part of the D-hole
            //       // The flat part is the rectangle to be removed from the circle to make the D-shape.
            //       // The rectangle is from x=-3.1 to x=-1.6.
            //       translate([-3.1, -3.1, 0]) cube([1.6, 6.2, D_BORE_DEPTH]);
            //     }
            //   }
            // }
            // This logic is correct.
            
            // Main cylinder
            cylinder(h = H_KNOB, r = R_OUTER, $fn = 128);
            
            // D-hole
            translate([0, 0, 0]) {
                difference() {
                    // The circular part of the hole
                    cylinder(h = D_BORE_DEPTH, r = R_BORE_CIRCLE, $fn = 128);
                    
                    // The rectangular part to be removed from the circle to create the D-shape
                    // This rectangle removes the segment from x=-3.1 to x=-1.6
                    translate([-R_BORE_CIRCLE, -R_BORE_CIRCLE, 0]) 
                        cube([D_BORE_CUT_WIDTH, D_BORE_CIRCLE, D_BORE_DEPTH]);
                }
            }
        }
    }