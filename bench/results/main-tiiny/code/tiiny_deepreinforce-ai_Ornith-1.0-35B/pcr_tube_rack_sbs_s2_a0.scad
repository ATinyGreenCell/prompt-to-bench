// --- Dimensions ---
BLOCK_L = 127.76;       // Length (X)
BLOCK_W = 85.48;        // Width (Y)
BLOCK_H = 20;           // Height (Z)
HOLE_DIA = 6.2;         // PCR tube hole diameter
GRID_ROWS = 8;            // Along Y
GRID_COLS = 12;           // Along X
SPACING = 9.0;          // Centre-to-centre spacing
ORIGIN_X = 14.38;         // A1 hole distance from left edge
ORIGIN_Y = 11.24;         // A1 hole distance from back edge
CHAMFER_LEN = 5;          // Chamfer leg length
CHAMFER_ANGLE = 45;     // Chamfer angle

// --- Hole positions ---
// A1 is at (ORIGIN_X, ORIGIN_Y)
// X increases to the right, Y increases toward the back
holes = [
  for (row = 0; row < GRID_ROWS; row = row + 1)
    for (col = 0; col < GRID_COLS; col = col + 1)
      [ORIGIN_X + col * SPACING, ORIGIN_Y + row * SPACING]
];

// --- Main body ---
difference() {
  // Block
  cube([BLOCK_L, BLOCK_W, BLOCK_H], center = false);

  // Holes
  for (pos = holes) {
    translate([pos[0], pos[1], -0.01])
      cylinder(h = BLOCK_H + 0.02, d = HOLE_DIA, center = false, $fn = 64);
  }

  // Chamfer at A1 corner (front-left)
  // A1 is at (ORIGIN_X, ORIGIN_Y) = front-left
  // Front is Y=0, Left is X=0
  // Chamfer removes material from (0,0) to (CHAMFER_LEN, CHAMFER_LEN)
  translate([-0.01, -0.01, 0])
    rotate([0, 0, 45])
      cube([CHAMFER_LEN * 2, CHAMFER_LEN * 2, BLOCK_H + 0.01], center = false);
}