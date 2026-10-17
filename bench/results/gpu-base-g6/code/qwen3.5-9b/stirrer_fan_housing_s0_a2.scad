// DIY Magnetic Stirrer Housing
// Based on an 80mm PC case fan
// Print orientation: Upside down (Top plate on bed, walls rising up)
// Centred on Origin (X=0, Y=0)

// --- Dimensions ---
// Outer dimensions
W_OUT = 90;
H_OUT = 90;
// Thicknesses
T_TOP = 2;
T_WALL = 2.5;
// Height of walls (total height from bed to open top)
H_WALL = 40;
// Hole pattern for M4 screws
PATTERN_SIZE = 71.5;
D_HOLE = 4.5;
// Cable notch
NOTCH_W = 12;
NOTCH_H = 8; // Depth from open edge (z = 40 - 8 = 32)

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and precise holes

// --- Construction ---
// We define the geometry in a local coordinate system where the bottom-left corner is (0,0).
// Then we translate the entire assembly to center it on the origin.

difference() {
    // 1. Main Solid Block
    // Dimensions: W_OUT x H_OUT x H_WALL
    cube([W_OUT, H_OUT, H_WALL], center = false);
    
    // 2. Internal Void
    // The empty space inside the box.
    // Width = 90 - 2*2.5 = 85
    // Height = 90 - 2*2.5 = 85
    // Depth = 40 (from z=0 to z=40)
    cube([W_OUT - 2*T_WALL, H_OUT - 2*T_WALL, H_WALL], center = false);
    
    // 3. Screw Holes
    // 4 holes on a 71.5mm square pattern centered on the plate.
    // In local coordinates, the plate is 90x90, centered at (45, 45).
    // Pattern center is (45, 45).
    // Offsets: +/- 71.5/2 = +/- 35.75
    // Z position: Through the top plate (z=0 to z=2).
    // Extend slightly past z=2 to ensure clean cut.
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([
                45 + i * (PATTERN_SIZE / 2),
                45 + j * (PATTERN_SIZE / 2),
                0
            ]) 
                cylinder(
                    h = T_TOP + 0.1, // Extend slightly past top plate
                    d = D_HOLE,
                    center = false
                );
        }
    }
    
    // 4. Cable Notch
    // Located in one wall. Let's pick the wall at the negative Y side (front).
    // In local coordinates (0..90):
    // Bottom Y = 0. Top Y = 90.
    // Wall is at the bottom edge (Y=0 to Y=2.5).
    // Center of wall Y = 1.25.
    // Notch is centered along this wall (X=45).
    // Notch cuts INTO the wall from the open top (z=40) downwards.
    
    // Wall Y center in local coords:
    y_wall_center_local = T_WALL / 2;
    
    // Notch geometry relative to local coordinates:
    // X: Centered at 45, width NOTCH_W
    // Y: Centered at y_wall_center_local, width NOTCH_W (cuts through the wall thickness)
    // Z: From (40 - NOTCH_H) to 40
    
    translate([
        45, 
        y_wall_center_local, 
        40 - NOTCH_H
    ])
        cube([NOTCH_W, T_WALL, NOTCH_H], center = false);
}

// Translate the entire assembly to center it on the origin
translate([-W_OUT/2, -H_OUT/2, 0]) {
    // The difference block above is re-executed here? 
    // No, in OpenSCAD, you cannot translate a block that is already inside a difference/union/etc easily without restructuring.
    // The correct approach is to wrap the ENTIRE difference block in a translate.
}

// Corrected Structure: Wrap the whole difference in a translate.
// Since I cannot edit the previous block directly, I will rewrite the file with the correct structure.