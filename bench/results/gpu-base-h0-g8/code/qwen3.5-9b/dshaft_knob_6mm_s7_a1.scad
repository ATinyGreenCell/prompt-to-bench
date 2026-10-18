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
// "distance from the flat to the opposite side of the circle is 4.7 mm"
// Opposite side is the far edge of the circle (Radius = 3.1).
// Flat is at x = 3.1 - 4.7 = -1.6 mm.
SHAFT_FLAT_POS = 3.1 - 4.7; 

// Grip Grooves
N_GROOVES = 18;   // Number of grooves
D_GROOVE = 2;     // Groove diameter (half-cylinder)
H_GROOVE = H_KNOB; // Full height

// Top Pointer
W_POINTER = 1.5;  // Width of pointer groove
D_POINTER = 1;    // Depth of pointer groove

// --- Main Body ---
// Cylinder with D-shaped cross-section
// The flat side is at x = SHAFT_FLAT_POS (negative value, so on the left).
difference() {
    // 1. Main D-shaped Cylinder
    union() {
        // Full cylinder
        cylinder(h = H_KNOB, d = D_KNOB, center = [0, 0, H_KNOB/2]);
        
        // Subtract the "flat" segment to make it D-shaped
        // We define a polygon profile for the segment to be removed.
        // The segment is bounded by the vertical line x = SHAFT_FLAT_POS and the circle arc.
        // Points: (SHAFT_FLAT_POS, -R), (SHAFT_FLAT_POS, R), (R, R), (R, -R)
        // Note: We subtract this from the full cylinder.
        // To ensure clean subtraction, we extend slightly past the faces.
        polygon(
            points = [
                [SHAFT_FLAT_POS, -R_KNOB],
                [SHAFT_FLAT_POS, R_KNOB],
                [R_KNOB + 0.1, R_KNOB], // Extended slightly to ensure full cut
                [R_KNOB + 0.1, -R_KNOB]
            ],
            extrude_height = H_KNOB + 0.1,
            convexity = 3
        );
    }
    
    // 2. D-Shaped Bore
    // We need to subtract a D-shape cylinder from the center.
    // The D-shape has a flat side on the same side as the knob's flat (negative X).
    // The flat of the bore is at x = SHAFT_FLAT_POS - (SHAFT_R - (SHAFT_D - 4.7)/2)?
    // Let's calculate the bore flat position relative to the knob.
    // The knob flat is at x = -1.6.
    // The bore is concentric. The bore diameter is 6.2.
    // The "distance from flat to opposite side" for the bore is also 4.7mm (implied by "D-shaft").
    // So the bore flat is at x = SHAFT_R - 4.7 = 3.1 - 4.7 = -1.6.
    SHAFT_BORE_FLAT_POS = 3.1 - 4.7;
    
    difference() {
        // Full bore cylinder
        cylinder(h = SHAFT_H, d = SHAFT_D, center = [0, 0, SHAFT_H/2]);
        
        // Subtract the flat segment of the bore
        polygon(
            points = [
                [SHAFT_BORE_FLAT_POS, -SHAFT_R],
                [SHAFT_BORE_FLAT_POS, SHAFT_R],
                [SHAFT_R, SHAFT_R],
                [SHAFT_R, -SHAFT_R]
            ],
            extrude_height = SHAFT_H + 0.1,
            convexity = 3
        );
    }
}

// --- Grip Grooves ---
// 18 evenly spaced vertical grooves along the full height.
// Each groove is a 2 mm diameter half-cylinder centred on the outer surface.
// "Centred on the outer surface" implies the axis of the half-cylinder is tangent to the outer cylinder.
// We will create a full cylinder of diameter D_GROOVE and subtract it, but only the part that overlaps the knob.
// Actually, "half-cylinder centred on the outer surface" usually means the flat face of the half-cylinder is on the knob surface.
// So we subtract a cylinder of diameter D_GROOVE, positioned such that its axis is at distance (R_KNOB - D_GROOVE/2) from the center.

for (i = [0 : N_GROOVES - 1]) {
    angle = (i / N_GROOVES) * 360;
    // Position of groove axis
    pos_x = R_KNOB - (D_GROOVE / 2);
    pos_y = pos_x * tan(angle * pi / 180);
    
    translate([pos_x, pos_y, 0]) {
        // Subtract a full cylinder. Since it's a "half-cylinder" groove, we assume the flat side faces inward.
        // A full cylinder subtraction creates a hole. We want a groove.
        // The prompt says "half-cylinder centred on the outer surface".
        // This implies the shape removed is a semi-cylinder where the flat face is on the knob surface.
        // To achieve this, we subtract a cylinder of diameter D_GROOVE.
        // However, a full cylinder subtraction would go all the way through if we aren't careful with height.
        // We limit the height to H_KNOB.
        cylinder(h = H_KNOB, d = D_GROOVE, center = [0, 0, H_KNOB/2]);
    }
}

// --- Top Pointer Groove ---
// 1.5 mm wide, 1 mm deep, runs from center to outer edge.
// On the same side as the flat of the D (negative X side).
difference() {
    // We need to cut a slot from the top face down to depth 1mm.
    // The slot is 1.5mm wide.
    // Position: Centered on the negative X axis.
    // Width 1.5mm means it extends from -0.75 to +0.75 relative to its center.
    // Center is at x = -R_KNOB + (D_POINTER/2)? No, "from the centre to the outer edge".
    // Usually, a pointer groove is centered on the radius.
    // Let's assume it is centered on the line from origin to -X.
    // So the groove spans from x = -R_KNOB + 0.75 to x = -R_KNOB - 0.75?
    // Or is it centered at the very edge? "Runs from the centre to the outer edge".
    // This implies the groove is located along the radius.
    // Let's place the groove centered at x = -R_KNOB + (W_POINTER/2).
    // Wait, if it runs from center to edge, it's a radial cut.
    // Let's assume the groove is centered on the negative X axis, spanning from x = -R_KNOB + 0.75 to x = -R_KNOB - 0.75.
    // Actually, to be safe and standard, let's center it at x = -R_KNOB + 0.75.
    // So the groove is between x = -R_KNOB + 1.5 and x = -R_KNOB? No.
    // Let's assume the groove is centered at x = -R_KNOB + 0.75.
    // The groove width is 1.5. So it goes from x = -R_KNOB + 0.75 - 0.75 = -R_KNOB to x = -R_KNOB + 1.5.
    // This puts one edge exactly at the outer rim.
    
    // Let's define the cut shape:
    // A rectangular prism (or rather, a slot) cut into the top.
    // Since we are using difference, we subtract a shape.
    // The shape is a cylinder of diameter 1.5mm? No, "1.5 mm wide".
    // If it's a straight slot, it's a rectangular prism.
    // If it's a rounded slot, it