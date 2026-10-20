// =============================================================================
// 96-Well PCR Tube Rack
// Standard microplate (ANSI/SLAS) footprint, print orientation: XY plane at z=0
// =============================================================================

// --- Block dimensions (mm) ---
block_L = 127.76; // X length
block_W = 85.48;  // Y width
block_H = 20;     // Z height

// --- Hole parameters ---
hole_dia = 6.2;   // Diameter of each well
rows = 8;          // Number of rows (along Y)
cols = 12;         // Number of columns (along X)
pitch = 9.0;       // Centre-to-centre spacing

// --- A1 hole position (from left and back edges) ---
a1_x = 14.38;
a1_y = 11.24;      // 11.24 mm from the back edge (Y=0)

// --- Chamfer parameters (A1 corner orientation mark) ---
chamfer_leg = 5;   // Length of each leg of the 45° chamfer

// =============================================================================
// Main model
// =============================================================================
difference() {
    // Solid block
    cube([block_L, block_W, block_H], center = [false, false, false]);

    // 96 through-holes
    for (i = [0 : rows * cols - 1]) {
        c = i % cols;
        r = i / cols;
        translate([a1_x + c * pitch, a1_y + r * pitch, -0.01]) {
            cylinder(h = block_H + 0.02, d = hole_dia, $fn = 64);
        }
    }

    // 45° chamfer at the A1 corner (back-left corner)
    translate([0, 0, -0.01]) {
        linear_extrude(height = block_H + 0.02) {
            polygon([[0, 0], [chamfer_leg, 0], [0, chamfer_leg]]);
        }
    }
}