// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down. Top plate on bed (Z=0), walls rise to Z=40.

// --- Dimensions ---
// Outer size of the box
W = 90;
H = 90;
D = 90; // Depth (Z height of walls)

// Wall thickness
T_WALL = 2.5;

// Top plate thickness
T_TOP = 2;

// Total height of the part (Top plate + Walls)
Z_MAX = T_TOP + D;

// Fan mounting hole pattern
// 71.5 mm square pattern centred on the plate
PATTERN_SIZE = 71.5;
// Hole diameter for M4 screws
D_HOLE = 4.5;

// Cable notch dimensions
NOTCH_W = 12;
NOTCH_Y = (H - NOTCH_W) / 2; // Center Y position
NOTCH_DEPTH = 8; // Depth from open edge (Z = 40 - 8 = 32)

// --- Configuration ---
$fn = 128; // High resolution for clean holes and edges

module housing() {
    // 1. Create the solid base (Top plate + Walls)
    // We build a solid block and then subtract features.
    
    // Base block: Outer dimensions W x H x Z_MAX
    // Centered at origin.
    base = translate([0, 0, 0]) 
        cube([W, H, Z_MAX], center = true);

    // 2. Subtract the four walls to create the open box
    // We need to cut out the interior volume defined by the outer walls.
    // Wall thickness is T_WALL.
    // Inner void dimensions:
    // X range: -W/2 + T_WALL to W/2 - T_WALL
    // Y range: -H/2 + T_WALL to H/2 - T_WALL
    // Z range: T_TOP to Z_MAX (the walls)
    
    wall_void = translate([0, 0, T_TOP])
        cube([W - 2*T_WALL, H - 2*T_WALL, D], center = true);
    
    // Ensure the cut extends slightly past the faces to avoid coplanar issues
    wall_cut = translate([0, 0, T_TOP])
        cube([W - 2*T_WALL + 0.1, H - 2*T_WALL + 0.1, D + 0.1], center = true);

    // 3. Subtract the four screw holes in the top plate
    // Pattern: 71.5mm square centered on the plate.
    // Plate center is (0,0).
    // Hole centers are at +/- 35.75 and +/- 71.5/2 +/- 35.75? 
    // No, "71.5 mm square pattern" usually means the distance between centers is 71.5.
    // So centers are at: (±35.75, ±35.75).
    
    hole_centers = [
        [35.75, 35.75],
        [35.75, -35.75],
        [-35.75, 35.75],
        [-35.75, -35.75]
    ];

    // Create holes extending through the top plate (Z=0 to Z=2)
    // Extend slightly past Z=2 to ensure clean cut
    for (c = hole_centers) {
        hole = translate(c)
            cylinder(h = T_TOP + 0.1, d = D_HOLE, center = true);
        difference() {
            base;
            hole;
        }
    }

    // 4. Subtract the cable notch
    // Location: One wall. Let's pick the front wall (Y = H/2).
    // Notch is 12mm wide, centered along the wall.
    // Wall center Y = H/2 = 45.
    // Notch Y center = 45.
    // Notch reaches 8mm down from open edge (Z=40). So Z range: 32 to 40.
    
    notch_pos = [0, H/2, 40]; // Start at top edge
    notch_size = [NOTCH_W, T_WALL + 0.1, NOTCH_DEPTH + 0.1]; // Width, Thickness+overhang, Depth+overhang
    
    notch = translate(notch_pos)
        cube(notch_size, center = false);
    
    // Apply notch cut
    difference() {
        base;
        wall_cut;
        hole_cutters = [
            translate([35.75, 35.75, 0]) cylinder(h = T_TOP + 0.1, d = D_HOLE, center = true),
            translate([35.75, -35.75, 0]) cylinder(h = T_TOP + 0.1, d = D_HOLE, center = true),
            translate([-35.75, 35.75, 0]) cylinder(h = T_TOP + 0.1, d = D_HOLE, center = true),
            translate([-35.75, -35.75, 0]) cylinder(h = T_TOP + 0.1, d = D_HOLE, center = true)
        ];
        notch;
    }
}

// Main execution
difference() {
    housing();
}