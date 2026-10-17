// DIY Magnetic Stirrer Housing
// Based on an 80mm PC case fan
// Print Orientation: Upside down (Top plate on bed)

// --- Dimensions ---
// Outer dimensions of the box
W = 90;      // Width (X)
D = 90;      // Depth (Y)
H = 40;      // Height of walls (Z)

// Thicknesses
T_TOP = 2;   // Top plate thickness
T_WALL = 2.5;// Wall thickness

// Fan mounting hole pattern (M4 screws)
// 71.5 mm square pattern centred on the plate
PATTERN_SIZE = 71.5;
HOLE_SIZE = 4.5; // M4 hole diameter

// Cable notch dimensions
NOTCH_W = 12;  // Notch width
NOTCH_H = 8;   // Notch depth (from open edge down)

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and precise holes

// --- Main Construction ---

// 1. Base Top Plate
// Lies on Z=0, thickness T_TOP
top_plate = translate([0, 0, 0]) 
    cube([W, D, T_TOP]);

// 2. Walls
// Rise from Z=T_TOP to Z=H
// Outer dimensions are W x D x H
// Inner void dimensions:
// X_inner = W - 2*T_WALL
// Y_inner = D - 2*T_WALL
// Z_start = T_TOP
// Z_end = H

void_x = W - (2 * T_WALL);
void_y = D - (2 * T_WALL);

// We build the walls as a single block with a hole, then subtract the cable notch
// Wall block: Outer box minus inner void
walls_base = translate([0, 0, T_TOP]) 
    difference() {
        // Outer envelope of walls
        cube([W, D, H - T_TOP]);
        
        // Inner void (to make the box open at the top)
        // Extend slightly past the face to ensure clean cut
        translate([T_WALL + 0.01, T_WALL + 0.01, T_TOP]) 
            cube([void_x - 0.02, void_y - 0.02, H - T_TOP]);
    };

// 3. Screw Holes
// Pattern: 71.5mm square centred on the plate (which is 90x90)
// Center of pattern relative to plate center (0,0):
// Offset = (90 - 71.5) / 2 = 9.25 mm
offset_x = (W - PATTERN_SIZE) / 2;
offset_y = (D - PATTERN_SIZE) / 2;

// 4. Cable Notch
// Located in one wall. Let's put it on the front wall (Y = D/2 - T_WALL/2)
// Notch reaches 8mm down from the open edge (Z = H).
// So notch Z range: H - NOTCH_H to H.
// Notch X range: Centred in the wall width.
// Wall X center is W/2. Notch width NOTCH_W.
// Notch Y position: Centred along the wall (Y = D/2).

// --- Assembly ---

// Combine top plate and walls
// Since walls_base already includes the top surface of the walls (up to Z=H),
// we need to be careful with the union.
// Actually, walls_base was defined from Z=T_TOP to Z=H.
// The top plate is Z=0 to Z=T_TOP.
// They touch perfectly at Z=T_TOP.

stirrer_housing = union() {
    top_plate;
    walls_base;
    
    // Subtract Screw Holes
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([
                offset_x + (i * PATTERN_SIZE / 2),
                offset_y + (j * PATTERN_SIZE / 2),
                0
            ]) 
                cylinder(h = T_TOP, r = HOLE_SIZE / 2);
        }
    }
    
    // Subtract Cable Notch
    // Position: Front wall (Y = D/2), Centred in X
    // The notch goes from Z = H - NOTCH_H to Z = H
    translate([
        (W / 2) - (NOTCH_W / 2),
        (D / 2),
        H - NOTCH_H // Start of notch from bottom of notch
    ]) 
        cube([NOTCH_W, NOTCH_W, NOTCH_H]); // Width, Depth (into the wall), Height
};

// Final Output
translate([0, 0, 0]) stirrer_housing;