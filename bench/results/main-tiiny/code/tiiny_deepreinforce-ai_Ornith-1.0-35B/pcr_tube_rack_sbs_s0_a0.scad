// --- Dimensions ---
BLOCK_L = 127.76;       // Length (X)
BLOCK_W = 85.48;        // Width (Y)
BLOCK_H = 20.0;         // Height (Z)
HOLE_DIA = 6.2;         // Hole diameter
ROWS = 8;               // Along Y
COLS = 12;              // Along X
PITCH_X = 9.0;          // Column spacing (X)
PITCH_Y = 9.0;          // Row spacing (Y)
ORIGIN_X = 14.38;       // A1 hole X from left edge
ORIGIN_Y = 11.24;       // A1 hole Y from back edge
CHAMFER_LEN = 5.0;      // Chamfer leg length
CHAMFER_ANGLE = 45;   // Chamfer angle

$fn = 64;

// --- Main block ---
difference() {
    // Base block
    cube([BLOCK_L, BLOCK_W, BLOCK_H], center = false);

    // 96 holes
    for (r = [0 : ROWS - 1]) {
        for (c = [0 : COLS - 1]) {
            hx = ORIGIN_X + c * PITCH_X;
            hy = ORIGIN_Y + r * PITCH_Y;
            translate([hx, hy, -0.01])
                cylinder(d = HOLE_DIA, h = BLOCK_H + 0.02, center = false);
        }
    }

    // 45-degree chamfer at A1 corner (front-left)
    translate([-0.01, -0.01, 0])
        rotate([0, 0, 45])
            cube([CHAMFER_LEN * 1.5, CHAMFER_LEN * 1.5, BLOCK_H + 0.01], center = false);
}