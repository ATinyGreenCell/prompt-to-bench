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

// --- Helper Functions ---

// Create a rectangular prism
function rect_prism(x, y, z) = [x, y, z];

// Create a hole through a plate (difference logic handled in main block)
// We will use a loop to subtract holes from the top plate

// --- Main Construction ---

// 1. Base Top Plate
// Lies on Z=0, thickness T_TOP
top_plate = translate([0, 0, 0]) 
    cube([W, D, T_TOP]);

// 2. Walls
// Rise from Z=T_TOP to Z=H
// Outer dimensions are W x D x H
// Inner void starts at Z=T_TOP
// We build the walls as a single block and then cut the notch

walls_base = translate([0, 0, T_TOP]) 
    cube([W, D, H - T_TOP]);

// 3. Cable Notch
// Located in one wall (let's say the front wall, Y = D/2 - NOTCH_W/2)
// Reaches from Z = H - NOTCH_H down to Z = H
notch_cut = translate([0, D - NOTCH_W/2, H - NOTCH_H]) 
    cube([NOTCH_W, NOTCH_W, NOTCH_H]);

// 4. Screw Holes
// 4 holes on a 71.5mm square pattern centred on the plate
// Pattern centre is at (0,0) relative to the plate
// Hole positions:
// x = +/- (PATTERN_SIZE/2 - HOLE_SIZE/2)
// y = +/- (PATTERN_SIZE/2 - HOLE_SIZE/2)
hole_offset = (PATTERN_SIZE - HOLE_SIZE) / 2;
hole_positions = [
    [ hole_offset,  hole_offset],
    [-hole_offset,  hole_offset],
    [ hole_offset, -hole_offset],
    [-hole_offset, -hole_offset]
];

// --- Assembly ---

// Start with the solid block (Plate + Walls)
// Then subtract the notch and the holes
// Note: The notch cut is positioned relative to the outer box dimensions.
// The hole positions are relative to the top plate centre (0,0).

final_part = union(
    // Combine plate and walls first to ensure a solid volume
    union(
        top_plate,
        walls_base
    )
);

// Subtract Notch
final_part = difference(
    final_part,
    notch_cut
);

// Subtract Screw Holes
// We iterate through the positions and subtract cylinders
// Extending slightly past the top surface (Z=0) to ensure clean cut
for (p = hole_positions) {
    final_part = difference(
        final_part,
        translate(p)
            cylinder(h = T_TOP + 0.1, r = HOLE_SIZE / 2)
    );
}

// Final Output
final_part;