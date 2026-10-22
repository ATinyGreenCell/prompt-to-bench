// DIY Magnetic Stirrer Housing
// Based on 80mm PC Case Fan dimensions
// Print Orientation: Upside down (Top plate on bed)

$fn = 128; // High resolution for clean holes and edges

// --- Dimensions ---
// Outer dimensions of the box
W_OUT = 90;
H_OUT = 90;
D_OUT = 40; // Depth (Z height from top plate to open edge)

// Wall thickness
WALL_THICK = 2.5;

// Top plate thickness
TOP_THICK = 2;

// Fan mounting hole pattern (M4 screws)
// Pattern is 71.5mm square, centred on the plate
HOLE_PAT_SIZE = 71.5;
HOLE_DIAM = 4.5;

// Cable notch dimensions
CABLE_NOTCH_W = 12;
CABLE_NOTCH_H = 8; // Depth from open edge

// --- Calculated Internal Dimensions ---
// Inner width/height (Outer - 2*Wall)
W_IN = W_OUT - (2 * WALL_THICK);
H_IN = H_OUT - (2 * WALL_THICK);

// --- Helper: Create the Base Box ---
// We build the box as a solid block, then subtract features.
// The box sits on Z=0 with height TOP_THICK.
box_base = cube([W_OUT, H_OUT, TOP_THICK]);

// --- Helper: Create the Walls ---
// Walls rise from Z=TOP_THICK to Z=D_OUT.
// We create a block representing the walls and union it with the base.
// Wall block dimensions:
// X: From -W_OUT/2 to W_OUT/2 (full width)
// Y: From -H_OUT/2 to H_OUT/2 (full height)
// Z: From 0 to D_OUT
// Then we subtract the inner void.

// 1. Create the full outer prism (Base + Walls)
outer_prism = cube([W_OUT, H_OUT, D_OUT]);

// 2. Create the inner void (The hole in the middle where the fan goes)
// The void starts at Z=0 and goes all the way to D_OUT.
// Inner dimensions are W_IN x H_IN.
inner_void = cube([W_IN, H_IN, D_OUT]);

// 3. Create the Cable Notch
// Location: In one wall. Let's place it on the positive X wall (Right side).
// Centered along the wall (Y direction).
// Depth: 8mm from the open edge (Z = D_OUT - 8).
// Width: 12mm.
// Height: 12mm (Z direction).
// Position:
// X: Centered on the right wall face. 
//    Wall face is at X = W_OUT/2. Notch is 12mm wide.
//    Center X = (W_OUT/2) - (12/2) = 45 - 6 = 39.
// Y: Centered on the wall. Wall height is 90.
//    Center Y = 0.
// Z: From (D_OUT - CABLE_NOTCH_H) to D_OUT.
//    From (40 - 8) = 32 to 40.
cable_notch = translate([
    (W_OUT/2) - (CABLE_NOTCH_W/2),
    0,
    D_OUT - CABLE_NOTCH_H
], cube([CABLE_NOTCH_W, CABLE_NOTCH_W, CABLE_NOTCH_H]));

// 4. Create the Screw Holes
// Pattern: 71.5mm square, centred on the plate.
// Plate is at Z=0 to Z=2.
// Holes go through the top plate (Z=0 to Z=2).
// Pattern center is (0,0).
// Corners of the 71.5mm square are at +/- 35.75.
// Hole centers are at the corners of this square.
// X positions: 35.75, -35.75
// Y positions: 35.75, -35.75
// Z positions: 0 to 2.
// We extend the cut slightly (0.1mm) to ensure clean removal.
hole_radius = HOLE_DIAM / 2 + 0.1;
pattern_half = HOLE_PAT_SIZE / 2;

// --- Assembly ---

// Start with the solid outer prism
part = outer_prism;

// Subtract the inner void (creates the box walls)
part = difference() {
    part;
    inner_void;
};

// Subtract the cable notch
part = difference() {
    part;
    cable_notch;
};

// Subtract the screw holes using a loop
for (i = [-1, 1]) {
    for (j = [-1, 1]) {
        translate([
            i * pattern_half,
            j * pattern_half,
            0 // Start at bottom of top plate
        ]) {
            cylinder(
                h = TOP_THICK + 0.1, // Extend slightly past top surface
                r = hole_radius,
                center = true
            );
        }
    }
}

// Final output
part;