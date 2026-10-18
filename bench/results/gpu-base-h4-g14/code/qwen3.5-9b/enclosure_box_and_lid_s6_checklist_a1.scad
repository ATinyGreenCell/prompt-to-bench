// Two-part enclosure for electronics board.
// Part 1: Box (left). Part 2: Lid (right, printed upside down).
// Both parts are centred on the XY plane at Z=0.

// --- Dimensions ---
// Box outer dimensions (X, Y, Z)
box_X = 70;
box_Y = 50;
box_Z = 30;

// Wall and floor thickness
wall_thick = 2;
floor_thick = 2;

// Gap between parts
gap = 10;

// Lid dimensions
lid_plate_thick = 2;
lip_wall_thick = 1.5;
lip_height = 4;

// Lid outer size (for the lip) - Prompt specified this, but it conflicts with clearance.
// We will calculate the actual outer size based on the clearance requirement to ensure it fits.
// Box Inner = 66 x 46.
// Lid Lip Inner must be 65.6 x 45.6 for 0.2mm clearance.
// Lid Lip Outer = Inner + 2*wall_thick = 68.6 x 48.6.
lip_inner_X = 65.6;
lip_inner_Y = 45.6;
lip_outer_X = lip_inner_X + 2 * lip_wall_thick;
lip_outer_Y = lip_inner_Y + 2 * lip_wall_thick;

// --- Part 1: Box ---
// Position: Centred at X = -gap/2, Y = 0, Z = 0.
// The box sits on Z=0.

module box() {
    translate([-box_X / 2, -box_Y / 2, 0]) {
        // Floor
        cube([box_X, box_Y, floor_thick]);
        
        // Walls (difference to cut out the inside)
        // We build the solid block and subtract the inner void.
        // Solid block:
        translate([0, 0, floor_thick]) cube([box_X, box_Y, box_Z - floor_thick]);
        
        // Inner void (cut out)
        // Void starts at floor_thick, goes up to box_Z.
        // Width: box_inner_X, Height: box_inner_Y.
        translate([0, 0, floor_thick]) cube([box_X - 2 * wall_thick, box_Y - 2 * wall_thick, box_Z - floor_thick]);
    }
}

// --- Part 2: Lid ---
// Position: Centred at X = gap/2, Y = 0, Z = 0.
// Printed upside down: Plate on bed, lip on top.
// Lid geometry:
// Plate: 70 x 50 x 2mm.
// Lip: Rectangular wall on top.
// Lip thickness: 1.5mm.
// Lip height: 4mm.
// Lip inner: 65.6 x 45.6 (to fit box).
// Lip outer: 68.6 x 48.6 (calculated).

module lid() {
    translate([-box_X / 2 + gap, -box_Y / 2, 0]) {
        // Plate
        cube([box_X, box_Y, lid_plate_thick]);
        
        // Lip
        // Lip is a hollow box on top of the plate.
        // Base of lip is at z = lid_plate_thick.
        // Top of lip is at z = lid_plate_thick + lip_height.
        // Outer dims: lip_outer_X, lip_outer_Y.
        // Inner dims: lip_inner_X, lip_inner_Y.
        
        // Solid block for the lip
        translate([0, 0, lid_plate_thick]) cube([lip_outer_X, lip_outer_Y, lip_height]);
        
        // Inner void for the lip
        translate([0, 0, lid_plate_thick]) cube([lip_inner_X, lip_inner_Y, lip_height]);
    }
}

// --- Assembly ---
difference() {
    // We use difference just to ensure the parts are distinct solids if we were to merge them,
    // but since they are separate modules, we just union them.
    // However, to strictly follow "difference" rule for cutting if needed, we can just union.
    // The prompt asks for a file that builds the part.
    union() {
        box();
        lid();
    }
}