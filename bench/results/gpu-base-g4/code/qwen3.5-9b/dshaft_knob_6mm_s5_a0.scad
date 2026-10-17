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

// --- Helper Functions ---

// Function to create a D-shape profile
// Returns a polygon representing the cross-section of the D-shaft
function get_d_profile() = [
    // Start at bottom center of flat side
    [0, 0],
    // Go right along the flat side to the edge of the circle
    [SHAFT_D / 2, 0],
    // Draw the semi-circle arc
    for (i = [0 : 1 : 360])
        [
            SHAFT_D / 2 + (SHAFT_D / 2) * cos(i),
            (SHAFT_D / 2) * sin(i)
        ],
    // Close loop back to start
    [0, 0]
];

// Function to create a D-shape with a specific flat side orientation
// angle: rotation of the D-shape around Z axis
function get_d_shape(angle) = 
    rotate(angle, [0,0,0]) 
    union(
        // The flat rectangular part
        cube([SHAFT_D, SHAFT_FLAT, 1]),
        // The semi-circular part attached to the flat
        translate([SHAFT_D/2, SHAFT_FLAT/2, 0])
        cylinder(h=1, d=SHAFT_D, $fn=$fn)
    );

// --- Main Construction ---

// 1. Base Cylinder (Outer Body)
// Since we print with the flat side down, we need to orient the D-shape correctly.
// The user said "side that faces the hotplate down". 
// Let's assume the flat side of the D is facing the -Z direction (the bed).
// So the flat side is at the bottom of the D-shape profile.

difference() {
    
    // --- The Main Body ---
    // We construct the D-shaped cylinder by rotating the D-profile 360 degrees.
    // The profile is defined such that the flat side is at the bottom (y=0 relative to profile center).
    // To make the flat side face the hotplate (down), we rotate the profile so the flat side is at the bottom.
    
    // Let's define the profile relative to the center of the D.
    // Center of D is at (0,0). Flat side is from -SHAFT_FLAT/2 to +SHAFT_FLAT/2 on the Y axis?
    // No, let's stick to the previous logic: Flat side is a rectangle of width SHAFT_D and height SHAFT_FLAT.
    // The circle is attached to the top of this rectangle.
    // If we rotate this shape 180 degrees around X, the flat side goes to the bottom.
    
    d_profile = [
        // Bottom edge (Flat side)
        [-SHAFT_D/2, -SHAFT_FLAT/2],
        [SHAFT_D/2, -SHAFT_FLAT/2],
        // Right arc
        for (i = [0 : 1 : 360])
            [
                SHAFT_D/2 + (SHAFT_D/2)*cos(i),
                (SHAFT_D/2)*sin(i) - SHAFT_FLAT/2
            ],
        // Top edge (Arc peak)
        [SHAFT_D/2, SHAFT_FLAT/2],
        // Left arc
        for (i = [359 : -1 : 0])
            [
                SHAFT_D/2 + (SHAFT_D/2)*cos(i),
                (SHAFT_D/2)*sin(i) - SHAFT_FLAT/2
            ],
        // Close to start
        [-SHAFT_D/2, -SHAFT_FLAT/2]
    ];
    
    // Extrude the D-profile to full height
    // We need to ensure the flat side is at Z=0.
    // The profile above has the flat side at Y = -SHAFT_FLAT/2.
    // We will translate the extruded shape so the flat side hits Z=0.
    
    // Create the solid D-cylinder
    translate([0, 0, -SHAFT_FLAT/2])
    linear_extrude(height=H_KNOB, center=false, convexity=4)
    polygon(points=d_profile);
    
    // --- Cutouts ---
    
    // 1. D-Shaped Blind Bore
    // This is a D-shape rotated 180 degrees around X so the flat side faces UP (towards the top of the knob)
    // Wait, the user said "D-shaped blind bore... distance from flat to opposite side is 4.7mm".
    // Usually, a D-shaft has the flat side on one side. If the knob sits on the flat side, 
    // the bore must match the shaft. The shaft has the flat side.
    // If the knob sits on the flat side of the shaft, the bore's flat side must be at the BOTTOM of the bore.
    // So the bore is a D-shape with the flat side facing -Z (down).
    
    // Let's create the bore shape.
    // Bore is centered at (0,0, SHAFT_H).
    // Flat side faces down (-Z).
    
    bore_shape = [
        // Bottom edge (Flat side)
        [-SHAFT_D/2, -SHAFT_FLAT/2],
        [SHAFT_D/2, -SHAFT_FLAT/2],
        // Right arc
        for (i = [0 : 1 : 360])
            [
                SHAFT_D/2 + (SHAFT_D/2)*cos(i),
                (SHAFT_D/2)*sin(i) - SHAFT_FLAT/2
            ],
        // Close
        [-SHAFT_D/2, -SHAFT_FLAT/2]
    ];
    
    // Extrude bore upwards from Z=0 to Z=SHAFT_H
    // Translate so the flat side (y=-SHAFT_FLAT/2) is at Z=0.
    translate([0, 0, -SHAFT_FLAT/2])
    linear_extrude(height=SHAFT_H, center=false, convexity=4)
    polygon(points=bore_shape);
    
    // 2. Vertical Grip Grooves (Outside)
    // 18 evenly spaced grooves.
    // Each is a 2mm diameter half-cylinder centered on the outer surface.
    // "Half-cylinder" implies a groove cut into the surface.
    // We can model this as a full cylinder of diameter D_GROOVE, but we only want the part that cuts into the knob.
    // Actually, a "half-cylinder groove" usually means a semi-cylindrical channel.
    // To cut this, we can use a cylinder of diameter D_GROOVE, but we need to position it so it cuts the knob.
    // The simplest way in OpenSCAD for a groove is to subtract a cylinder that is slightly larger than the groove depth?
    // No, the user said "2 mm diameter half-cylinder". This implies the groove cross-section is a semi-circle of diameter 2mm.
    // So the radius of the cut is 1mm.
    // We can create a cylinder of diameter 2mm, but we only want the part that intersects the knob.
    // However, since we are doing a difference, if we subtract a full cylinder of diameter 2mm centered on the surface,
    // it will cut a hole through the knob if it's too deep.
    // The user wants a groove along the "full height".
    // So we subtract a cylinder of diameter 2mm, height = H_KNOB, positioned on the surface.
    // But a full cylinder would cut a round hole. A "half-cylinder" groove means the cut is semi-circular.
    // This is achieved by subtracting a cylinder of diameter 2mm, but we must ensure we don't cut the other side?
    //