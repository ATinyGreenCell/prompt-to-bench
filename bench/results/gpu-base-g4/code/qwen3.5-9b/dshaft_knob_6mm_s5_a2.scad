// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Units: mm
// Orientation: Printed with D-flat side facing the hotplate (Z=0), building upward.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and precise D-shape

// Knob Body
D_KNOB = 30;      // Outer diameter
H_KNOB = 15;      // Total height
R_KNOB = D_KNOB / 2;

// Shaft Bore (D-shape)
SHAFT_D = 6.2;    // Full diameter of the circle part
SHAFT_H = 12;     // Depth of the bore from bottom
SHAFT_FLAT = 4.7; // Distance from flat side to opposite arc (defines the D)

// Grooves (Outside)
N_GROOVES = 18;   // Number of vertical grooves
D_GROOVE = 2;     // Diameter of the half-cylinder groove
H_GROOVE = H_KNOB; // Full height

// Pointer (Top)
W_POINTER = 1.5;  // Width of the pointer groove
D_POINTER = 1;    // Depth of the pointer groove

// --- Helper: Generate D-Shape Polygon ---
// Creates a polygon for a D-shape with diameter D and flat height H_flat.
// The flat side is at the bottom (negative Y relative to the shape's local center).
function get_d_polygon(D, H_flat) = [
    // Bottom edge (Flat side)
    [-D/2, -H_flat/2],
    [D/2, -H_flat/2],
    // Right arc (Semi-circle)
    for (i = [0 : 1 : 360])
        [
            D/2 + (D/2)*cos(i),
            (D/2)*sin(i) - H_flat/2
        ],
    // Close loop back to start
    [-D/2, -H_flat/2]
];

// --- Main Construction ---
difference() {
    
    // 1. Outer Body (30mm D-Cylinder)
    // We construct the solid D-cylinder.
    // The profile is defined with the flat side at the bottom.
    // We translate the extruded shape so the flat side hits Z=0.
    
    outer_profile = get_d_polygon(D_KNOB, SHAFT_FLAT);
    
    // The profile's lowest Y is -SHAFT_FLAT/2.
    // We translate up by SHAFT_FLAT/2 so the flat side is at Z=0.
    translate([0, 0, -SHAFT_FLAT/2])
    linear_extrude(height=H_KNOB, center=false, convexity=4)
    polygon(points=outer_profile);
    
    // 2. D-Shaped Blind Bore
    // The bore must match the shaft. Since the knob sits on the flat side of the shaft,
    // the bore's flat side must face DOWN (-Z direction).
    // We create the same D-profile (scaled to shaft size) and extrude it upwards from Z=0.
    
    bore_profile = get_d_polygon(SHAFT_D, SHAFT_FLAT);
    
    // Extrude bore upwards from Z=0 to Z=SHAFT_H.
    // Translate so the flat side (y=-SHAFT_FLAT/2) is at Z=0.
    translate([0, 0, -SHAFT_FLAT/2])
    linear_extrude(height=SHAFT_H, center=false, convexity=4)
    polygon(points=bore_profile);
    
    // 3. Vertical Grip Grooves (Outside)
    // 18 evenly spaced grooves.
    // Each is a 2mm diameter half-cylinder centered on the outer surface.
    // We subtract a cylinder of diameter D_GROOVE positioned on the surface.
    
    angle_step = 360 / N_GROOVES;
    
    for (i = [0 : N_GROOVES - 1]) {
        angle = i * angle_step;
        
        // Position the groove cylinder center on the outer surface
        pos_x = R_KNOB * cos(angle);
        pos_y = R_KNOB * sin(angle);
        
        // Subtract the groove cylinder.
        // Extend slightly past the top/bottom to ensure clean cut.
        translate([pos_x, pos_y, -0.1])
        cylinder(h=H_KNOB + 0.2, d=D_GROOVE, $fn=$fn);
    }
    
    // 4. Pointer Groove (Top)
    // Cut a groove 1.5 mm wide and 1 mm deep from the center to the outer edge.
    // It runs on the same side as the flat of the D.
    // In our coordinate system, the flat side is at the bottom (negative Y direction relative to the knob's center).
    // The top face is at Z = H_KNOB - SHAFT_FLAT/2.
    
    top_z = H_KNOB - SHAFT_FLAT/2;
    
    // Create a rectangular prism to cut the groove.
    // Width = W_POINTER, Length = R_KNOB (from center to edge), Depth = D_POINTER.
    // Position: Centered on the negative Y axis.
    translate([0, -W_POINTER/2, top_z])
    cube([W_POINTER, R_KNOB, D_POINTER]);
    
}