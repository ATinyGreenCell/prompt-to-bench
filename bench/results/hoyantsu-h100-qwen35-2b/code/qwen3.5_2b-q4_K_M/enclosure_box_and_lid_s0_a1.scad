// Design a two-part enclosure for an electronics board.
// Parts are printed side-by-side with a 10mm gap between them on the XY bed.

// --- Part 1: The Box (Lower Body) ---
// Outer dimensions: X=70, Y=50, Z=30 mm
// Wall thickness: 2 mm
// Floor thickness: 2 mm
// Top is open.
box(
    x = 70,
    y = 50,
    z = 30,
    walls = 2,
    floor = 2,
    top_open = true
) as box1;

// --- Part 2: The Lid (Upper Cover) ---
// Printed upside down.
// Base plate dimensions: X=70, Y=50, Z=2 mm
// Lip wall thickness: 1.5 mm
// Lip height: 4 mm
// Outer lip dimensions: X=65.6, Y=45.6 mm (slightly smaller than base to allow sliding clearance)
// Centred on the plate.

plate(
    x = 70,
    y = 50,
    z = 2,
    walls = 1.5,
    height = 4,
    outer_x = 65.6,
    outer_y = 45.6,
    top_open = true
) as plate;

// --- Assembly and Gap Logic ---
// The gap is created by translating the box to the right of the plate.
translate([0, 0, 10]) as assembly(
    union(box1, plate)
);