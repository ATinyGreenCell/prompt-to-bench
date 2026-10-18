// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down (Top plate on bed)
// Units: mm

// --- Dimensions ---
// Outer dimensions of the box
W = 90;
H = 90;
D = 40; // Total height of walls

// Wall thickness
T_WALL = 2.5;

// Top plate thickness
T_TOP = 2;

// Screw hole dimensions
ScrewDiameter = 4.5;
ScrewPatternSize = 71.5; // Distance between centers

// Cable notch dimensions
NotchWidth = 12;
NotchDepth = 8; // From open edge (z=40) down to z=32

// --- Main Body Construction ---

// 1. Create the solid block representing the housing
// We build the walls rising from the top plate (z=0 to z=2) up to z=40.
// The top plate is at z=0 to z=2.
// The walls are at z=2 to z=40.

// Start with the top plate
top_plate = translate([0, 0, 0])
    cube([W, H, T_TOP], center=false);

// Build the walls
// Walls rise from z=T_TOP to z=D
// Outer face of walls is at z=D. Inner face is at z=D - T_WALL.
// We construct the walls as a single block with holes cut out, then union with top plate.

walls_base = translate([0, 0, T_TOP])
    cube([W, H, D - T_TOP], center=false);

// Combine base and walls
housing_base = union(top_plate, walls_base);

// 2. Cut the Screw Holes
// 4 holes on a 71.5mm square pattern centered on the 90x90 plate.
// Pattern center is (0,0).
// Hole positions: +/- (71.5/2) in X and Y.
// Offset = 35.75

hole_offset = ScrewPatternSize / 2;

// Create the top plate with holes first
top_plate_with_holes = difference() {
    // The base top plate
    translate([0, 0, 0]) cube([W, H, T_TOP], center=false);
    
    // The cutters
    for (i = [-1, 1], j = [-1, 1])
        translate([i * hole_offset, j * hole_offset, 0])
            cylinder(h = T_TOP + 0.1, r = ScrewDiameter / 2, $fn = 64);
}

// Reconstruct the full housing
// Union the modified top plate with the walls (which start at z=T_TOP)
final_housing = union(top_plate_with_holes, 
    translate([0, 0, T_TOP]) cube([W, H, D - T_TOP], center=false)
);

// 3. Cut the Cable Notch
// Location: In one wall. Let's choose the wall at Y = -W/2 (front wall).
// The notch is 12mm wide, centered along the wall.
// It reaches 8mm down from the open edge (z=40).
// So it cuts from z = 40 - 8 = 32 to z = 40.
// X position: Centered on the wall. Wall is at Y = -45.
// Notch is 12mm wide, so from X = -6 to X = +6 relative to center.

notch_cutter = translate([-NotchWidth/2, -W/2, 32])
    cube([NotchWidth, T_WALL + 0.1, NotchDepth + 0.1], center=false);

// Apply notch
stirrer_housing = difference() {
    final_housing;
    notch_cutter;
}

// Final Output
$fn = 100; // High resolution for smooth curves if any, and clean holes
color("grey") stirrer_housing;