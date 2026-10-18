// DIY Magnetic Stirrer Housing for 80mm PC Fan
// Print Orientation: Upside down. Top plate on bed (Z=0). Walls rise to Z=40.

// --- Dimensions ---
// Outer size of the box
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
HOLE_PAT_SIZE = 71.5;
HOLE_DIAM = 4.5; // M4 screw hole

// Cable notch dimensions
NOTCH_W = 12;
NOTCH_H = 8; // Reaches 8mm down from open edge (Z=32 to Z=40)

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate holes

// --- Helper: Create the solid box body ---
// We build the box as a solid block first, then subtract features.
// The box is 90x90x40.
// Top plate is 90x90x2.
// Walls are 2.5mm thick.

// Calculate inner dimensions for the walls
// Outer: 90x90x40
// Top plate sits at Z=0 to Z=2.
// Walls sit on top of the plate? 
// Re-reading prompt: "2 mm thick top plate lies on the bed (z = 0 to 2) and four walls, 2.5 mm thick, rise from it to z = 40".
// This implies the walls are attached to the top of the plate.
// So the structure is:
// 1. Base plate: 90x90x2 (Z=0 to 2)
// 2. Walls: Rise from Z=2 to Z=40.
//    Wall thickness is 2.5mm.
//    Since it's an "open box", the walls form a frame.
//    Outer footprint of walls matches outer footprint of plate? 
//    Usually, a housing covers the fan. The fan is 80mm.
//    Outer size is 90mm.
//    If walls are 2.5mm thick and outer size is 90mm, the inner cavity is 90 - 2*2.5 = 85mm.
//    This fits an 80mm fan with clearance.

// Let's construct the main body using a difference approach for clarity.
// Start with a large block representing the outer envelope.
// Envelope: 90 (X) x 90 (Y) x 40 (Z).
// But the top plate is distinct.
// Actually, simpler to model the union of the plate and the walls, then cut holes/notch.

// 1. The Top Plate
// 90x90x2 at Z=0.
top_plate = translate([0, 0, 0])
    cube([W_OUT, H_OUT, TOP_THICK]);

// 2. The Walls
// They rise from Z=2 to Z=40. Height = 38mm.
// They are 2.5mm thick.
// Outer dimensions of the wall assembly match the plate (90x90).
// So the walls occupy the perimeter.
// Inner void starts at X = 2.5, Y = 2.5.
// Wall height = 38.
walls = translate([0, 0, TOP_THICK])
    union(
        // Front wall (Y max)
        translate([0, H_OUT - W_THICK/2, 0])
            cube([W_OUT, W_THICK, BOX_HEIGHT - TOP_THICK]),
        // Back wall (Y min)
        translate([0, -H_OUT + W_THICK/2, 0])
            cube([W_OUT, W_THICK, BOX_HEIGHT - TOP_THICK]),
        // Right wall (X max)
        translate([W_OUT - W_THICK/2, 0, 0])
            cube([W_THICK, H_OUT, BOX_HEIGHT - TOP_THICK]),
        // Left wall (X min)
        translate([-W_OUT + W_THICK/2, 0, 0])
            cube([W_THICK, H_OUT, BOX_HEIGHT - TOP_THICK])
    );

// Combine Plate and Walls
box_body = union(top_plate, walls);

// --- Cut Features ---

// 1. Screw Holes
// 4 holes of 4.5mm diameter.
// Pattern: 71.5mm square centred on the plate.
// Center of plate is (0,0).
// Pattern corners are at +/- 35.75mm.
// Hole centers:
// X = -35.75, Y = -35.75
// X = 35.75, Y = -35.75
// X = -35.75, Y = 35.75
// X = 35.75, Y = 35.75
// Cut through the top plate only (Z=0 to Z=2).
// To ensure clean cut, extend slightly past the plate thickness.

hole_pattern = [
    [-HOLE_PAT_SIZE/2, -HOLE_PAT_SIZE/2],
    [HOLE_PAT_SIZE/2, -HOLE_PAT_SIZE/2],
    [-HOLE_PAT_SIZE/2, HOLE_PAT_SIZE/2],
    [HOLE_PAT_SIZE/2, HOLE_PAT_SIZE/2]
];

holes = for (p = hole_pattern) {
    translate(p)
        cylinder(h = TOP_THICK + 0.1, d = HOLE_DIAM, $fn = 64)
};

// 2. Cable Notch
// One wall. Let's pick the Front wall (Y max) or Back? 
// Prompt: "In one wall, cut a notch... centred along the wall".
// Let's choose the Front wall (positive Y side) for visibility.
// Notch: 12mm wide, centred along the wall.
// Wall Y range: [H_OUT - W_THICK/2, H_OUT + W_THICK/2] -> [43.75, 46.25].
// Center Y = 45.
// Notch reaches 8mm down from open edge.
// Open edge is at Z = 40.
// So notch goes from Z = 32 to Z = 40.
// Width 12mm.
// X range: Centered on the wall's X-center (0).
// X from -6 to +6.
// Y range: Centered on the wall's Y-center (45).
// Y from 45 - 6 to 45 + 6 -> [39, 51].
// Wait, the wall is only 2.5mm thick. The notch must go through the wall thickness.
// The wall is at Y ~ 45. The notch cuts through the wall material.
// So the notch is a rectangular prism cut.
// X: -6 to 6.
// Y: 39 to 51 (This covers the wall thickness at Y=45).
// Z: 32 to 40.

notch = translate([-NOTCH_W/2, H_OUT - NOTCH_W/2, 32]) // Centered on the front wall face?
    // Let's refine the position.
    // Wall is at Y = H_OUT - W_THICK/2 to H_OUT + W_THICK/2.
    // Center Y of wall = H_OUT.
    // Notch width 12. Centered at X=0, Y=H_OUT.
    // So Y range: H_OUT - 6 to H_OUT + 6.
    // Z range: 32 to 40.
    // X range: -6 to 6.
    cube([NOTCH_W, NOTCH_W, NOTCH_H]);

// --- Final Assembly ---
// Union body, then Difference with holes and notch.
// Ensure notch extends slightly past the wall thickness to ensure full cut.
notch_cut = translate([-NOTCH_W/2, H_OUT - NOTCH_W/2, 32])
    cube([NOTCH_W, NOTCH_W + 0.1, NOTCH_H]);

final_part = difference() {
    box_body;
    holes;
    notch_cut;
}

// Display the final part
final_part;