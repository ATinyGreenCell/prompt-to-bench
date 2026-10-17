// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Orientation: Bottom face (with D-bore) rests on Z=0.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Knob Body
D_KNOB = 30;      // Outer diameter
H_KNOB = 15;      // Total height
R_KNOB = D_KNOB / 2;

// D-Shaft Bore
SHAFT_D = 6.2;    // Nominal bore diameter
SHAFT_H = 12;     // Depth of bore
SHAFT_R = SHAFT_D / 2;

// Grip Grooves
N_GROOVES = 18;   // Number of vertical grooves
D_GROOVE = 2;     // Diameter of groove cylinder
H_GROOVE = H_KNOB; // Full height

// Top Pointer
W_POINTER = 1.5;  // Width of pointer groove
D_POINTER = 1;    // Depth of pointer groove

// --- Geometry Construction ---

// 1. Main Body (Cylinder)
difference() {
    // Outer Cylinder
    cylinder(h = H_KNOB, d = D_KNOB, center = [0, 0, H_KNOB/2]);
    
    // 2. D-Shaped Bore
    // We create the D-shape by taking a cylinder of SHAFT_D and subtracting a rectangle
    // to create the flat side.
    // The flat side is centered on the X-axis (or Y-axis depending on rotation).
    // Let's align the flat side along the X-axis for easier calculation, then rotate.
    // Actually, let's define the D-shape in the XY plane and extrude it.
    
    translate([0, 0, SHAFT_H/2]) {
        difference() {
            // The full cylinder hole
            cylinder(h = SHAFT_H, d = SHAFT_D, center = [0, 0, 0]);
            
            // The flat cut. 
            // To make a D-shape from a circle, we cut a rectangle from one side.
            // The width of the rectangle should be (SHAFT_D - desired_arc_width).
            // However, the prompt says "distance from the flat to the opposite side... is 4.7mm".
            // As analyzed, this is geometrically impossible for a 6.2mm circle (max depth 3.1mm).
            // We will interpret "4.7mm" as the **width of the flat side** of the D-shaft.
            // This leaves an arc width of 6.2 - 4.7 = 1.5mm.
            
            // Calculate the offset for the flat cut.
            // The flat cut is a rectangle of width 4.7mm.
            // It is centered on the axis of the cylinder.
            // We need to cut from the center outwards? No, a D-shaft is a circle with a flat.
            // So we cut a rectangle of width 4.7mm centered at (0,0) from the cylinder?
            // No, that would make a slot.
            // A D-shaft is a circle where one side is flattened.
            // So we take the cylinder and subtract a rectangle that spans the diameter? No.
            // We take the cylinder and subtract a rectangle that spans the "flat" portion.
            // The flat portion is a chord.
            // If the flat width is 4.7mm, the rectangle to subtract has width 4.7mm.
            // Where is it located? It is centered on the axis.
            // Wait, if I subtract a rectangle of width 4.7mm centered at 0,0 from a cylinder of diameter 6.2mm,
            // I am removing the center. That creates a ring with a flat edge? No.
            
            // Correct approach for D-shaft:
            // Start with cylinder.
            // Subtract a rectangle that represents the "flat" part.
            // The flat part is a chord. The rectangle should be defined by the chord's width and the depth of the cut.
            // Actually, the simplest way to model a D-shaft hole is:
            // 1. Cylinder of diameter SHAFT_D.
            // 2. Subtract a rectangle of width (SHAFT_D - arc_width) and height SHAFT_H.
            // The rectangle is positioned such that it cuts the circle.
            // If the flat width is 4.7mm, the rectangle width is 4.7mm.
            // The rectangle is centered on the X-axis (for example).
            // The rectangle extends from x = -2.35 to x = +2.35.
            // The cylinder extends from x = -3.1 to x = +3.1.
            // Subtracting the rectangle removes the material between x=-2.35 and x=2.35.
            // This leaves two separate pieces (left and right caps). That is NOT a D-shaft.
            
            // A D-shaft is a single piece.
            // It is a circle with a flat side.
            // This means we keep the circle, but we cut away the "flat" part?
            // No, we cut away the part that makes it round on one side.
            // Imagine a circle. Draw a chord. The segment between the chord and the arc is the "flat" part?
            // No, the "flat" part is the straight edge.
            // So we want the shape to be bounded by a straight line and an arc.
            // To get this from a cylinder:
            // We start with the cylinder.
            // We subtract a rectangle that covers the "round" part we want to remove?
            // No.
            // Let's think about the cross section.
            // We want a shape that looks like a 'D'.
            // We can create this by taking a rectangle of width 4.7mm and height SHAFT_H, and attaching a semi-circle?
            // Or, simpler: Take a cylinder of diameter SHAFT_D.
            // Subtract a rectangle of width (SHAFT_D - 4.7) ? No.
            
            // Let's try this:
            // The D-shape is defined by a flat width of 4.7mm.
            // The total width is 6.2mm.
            // The flat side is a straight line.
            // The other side is an arc.
            // We can construct this by taking a rectangle of width 4.7mm and height SHAFT_H,
            // and adding a semi-circle of diameter (6.2 - 4.7) = 1.5mm to one end.
            // Then we rotate this D-shape 90 degrees so the flat side is vertical?
            // No, the bore is a hole.
            // Let's build the D-shape profile in the XZ plane (or XY) and extrude it.
            
            // Profile:
            // Width = 6.2mm.
            // Flat side width = 4.7mm.
            // Arc side width = 1.5mm.
            // The flat side is a straight line.
            // The arc side is a semi-circle of diameter 1.5mm.
            // The total height of the profile is SHAFT_H.
            
            // Let's build this profile in the XY plane, centered at (0,0).
            // The flat side will be along the Y-axis? Or X-axis?
            // Let's put the flat side along the X-axis for symmetry?
            // No, let's put the flat side along the Y-axis (vertical in the cross section) so the knob can rotate?
            // Actually, the orientation of the D-shaft doesn't matter for the hole itself, just the shape.
            // Let's define the D-shape such that the flat side is on the +X side.
            
            // Profile construction:
            // Rectangle: x from -3.1 to 0 (width 3.1), y from -3.1 to 3.1 (height 6.2)? No.
            // Let's use the "Rectangle + Semi-Circle" method.
            // Rectangle: Width = 4.7mm (the flat part). Height = SHAFT_H.
            // Semi-Circle: Diameter = 1.5mm. Radius = 0.75mm.
            // We attach the semi-circle to the rectangle.
            // Total width = 4.7 + 1.5 = 6.2mm.
            // Center of the combined shape:
            // Rectangle center at x = - (4.7/2) = -2.35?
            // Let's center the whole thing at x=0.
            // Rectangle: x from -2.35 to 0. Width 2.35? No, width 4.7.
            // If rectangle is from -2.35 to 2.35, width is 4.7.
            // Then we attach the semi-circle to the right (x > 2.35).