// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down. Top plate on bed (Z=0). Walls rise to Z=40.

// --- Dimensions ---
// Outer dimensions of the housing
W_OUT = 90;
H_OUT = 90;
D_OUT = 90; // Depth (Z height of walls)

// Wall thickness
W_THICK = 2.5;

// Top plate thickness
TOP_THICK = 2;

// Total height of the box (top of walls)
BOX_HEIGHT = 40;

// Fan mounting hole pattern
// 71.5 mm square pattern centred on the plate
HOLE_PITCH = 71.5;
// Hole diameter for M4 screws
HOLE_DIAM = 4.5;

// Cable notch dimensions
NOTCH_WIDTH = 12;
NOTCH_DEPTH = 8; // Reaches 8mm down from open edge (Z=32 to Z=40)

// --- Configuration ---
$fn = 100; // High resolution for smooth curves and precise holes

// --- Main Body Construction ---
difference() {
    union() {
        // --- 1. The Top Plate ---
        // Lies on the bed, Z=0 to Z=TOP_THICK
        translate([0, 0, 0])
            cube([W_OUT, H_OUT, TOP_THICK]);

        // --- 2. The Walls ---
        // Rise from Z=TOP_THICK to Z=BOX_HEIGHT
        // We construct the outer shell and subtract the inner void to create walls
        translate([0, 0, TOP_THICK])
            cube([W_OUT, H_OUT, BOX_HEIGHT - TOP_THICK]);
        
        // Create the inner void for the walls
        // Inner dimensions: Outer - 2*Thickness
        W_IN = W_OUT - (2 * W_THICK);
        H_IN = H_OUT - (2 * W_THICK);
        
        translate([W_THICK, W_THICK, TOP_THICK])
            cube([W_IN, H_IN, BOX_HEIGHT - TOP_THICK]);
    }
    
    // --- 3. Cutouts ---
    
    // A. Fan Mounting Holes
    // 4 holes on a 71.5mm square pattern, centred on the plate.
    // Pattern corners at +/- 35.75mm.
    // Hole centers: (35.75, 35.75), (-35.75, 35.75), (-35.75, -35.75), (35.75, -35.75)
    
    // Define hole positions explicitly to avoid scope issues
    hole_positions = [
        [HOLE_PITCH/2, HOLE_PITCH/2],
        [-HOLE_PITCH/2, HOLE_PITCH/2],
        [-HOLE_PITCH/2, -HOLE_PITCH/2],
        [HOLE_PITCH/2, -HOLE_PITCH/2]
    ];
    
    for (p = hole_positions) {
        translate(p)
            cylinder(h = TOP_THICK + 0.1, r = HOLE_DIAM/2); // +0.1 to ensure clean cut through the plate
    }

    // B. Cable Notch
    // In one wall, cut a notch.
    // 12 mm wide, centred along the wall.
    // Reaching 8 mm down from the open edge (Z=32 to Z=40).
    // Let's place this notch in the wall at Y = -H_OUT/2 + W_THICK (the front wall).
    // Notch width: 12mm. Centered along the wall (X-axis).
    // Wall X range: -45 to 45. Center is 0.
    // Notch X range: -6 to +6.
    
    // Position: Front wall (Y = -H_OUT/2 + W_THICK)
    // Depth into wall: Notch width / 2 = 6mm.
    // Height: From Z=32 to Z=40.
    
    translate([0, -H_OUT/2 + W_THICK, 32])
        cube([NOTCH_WIDTH, W_THICK, NOTCH_DEPTH]);
}