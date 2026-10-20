// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: rests on XY plane at z = 0, builds upward (+Z)

// Block dimensions (measured with calipers)
block_L = 106;   // length along X
block_W = 72;    // width along Y
block_H = 30;    // height along Z

// Hole grid
rows = 4;        // number of rows along Y
cols = 6;        // number of holes per row along X
pitch = 16;      // centre-to-centre spacing in both X and Y

// Hole geometry
hole_d = 11.2;   // hole diameter
hole_depth = 25; // depth from top (open at top, closed at bottom)
floor_t = 5;     // solid floor thickness (block_H - hole_depth)

$fn = 64;

// Centre the block on the origin in X and Y; base at z = 0
block = translate([-block_L/2, -block_W/2, 0])
    cube([block_L, block_W, block_H]);

// Grid of 24 vertical holes, centred on the block
// Each hole is a cylinder from z = floor_t to z = block_H + 1 (extends past top face)
holes = for (i = [0:cols-1], j = [0:rows-1])
    translate([
        (i - (cols - 1) / 2) * pitch,   // X position, grid centred on origin
        (j - (rows - 1) / 2) * pitch,   // Y position, grid centred on origin
        floor_t                          // bottom of hole at z = floor_t
    ])
    cylinder(h = hole_depth + 1, d = hole_d, $fn = $fn);

// Final part: block minus the hole grid
difference() {
    block;
    holes;
}