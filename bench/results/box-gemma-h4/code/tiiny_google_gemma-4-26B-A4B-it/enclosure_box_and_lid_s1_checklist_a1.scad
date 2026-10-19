// Two-part electronics enclosure: Box and Lid
// Corrected orientation: Lid plate sits on the bed at Z=0.

// --- Dimensions ---
box_x = 70.0;         // Outer width of box
box_y = 50.0;         // Outer depth of box
box_z = 30.0;         // Outer height of box
wall_t = 2.0;         // Wall thickness
floor_t = 2.0;        // Floor thickness

lid_plate_t = 2.0;    // Thickness of the lid base plate
lid_lip_h = 4.0;      // Height of the lid lip
lid_lip_t = 1.5;      // Thickness of the lid lip wall

// Clearance calculation:
// Box inner dimensions: (70 - 2*2) x (50 - 2*2) = 66 x 46
// Lid lip outer dimensions: 65.6 x 45.6
// Clearance per side: (66 - 65.6)/2 = 0.2mm
lid_lip_x = 65.6;     // Outer width of the lid lip
lid_lip_y = 45.6;     // Outer depth of the lid lip

gap = 10.0;           // Gap between parts on the print bed

$fn = 64;

// --- Part 1: The Box ---
// Sits on XY plane at Z=0
module box() {
    difference() {
        // Main outer body
        cube([box_x, box_y, box_z]);
        
        // Hollow interior
        translate([wall_t, wall_t, floor_t])
            cube([box_x - 2 * wall_t, box_y - 2 * wall_t, box_z + 1]);
    }
}

// --- Part 2: The Lid ---
// Printed with the flat plate on the bed (Z=0)
module lid() {
    union() {
        // The base plate (sits on the bed)
        cube([box_x, box_y, lid_plate_t]);
        
        // The lip (sits on top of the plate)
        translate([(box_x - lid_lip_x) / 2, (box_y - lid_lip_y) / 2, lid_plate_t])
            difference() {
                // Outer lip shape
                cube([lid_lip_x, lid_lip_y, lid_lip_h]);
                // Inner lip cutout (subtracted from the lip)
                translate([lid_lip_t, lid_lip_t, -0.01])
                    cube([lid_lip_x - 2 * lid_lip_t, lid_lip_y - 2 * lid_lip_t, lid_lip_h + 0.02]);
            }
    }
}

// --- Assembly / Layout ---

// Part 1: The Box
// Centered on X/Y for standard layout, but we will use absolute 
// positioning to ensure the gap is calculated correctly.
translate([0, 0, 0]) 
    box();

// Part 2: The Lid
// Positioned on the +X side of the box with a 10mm gap.
// The plate is at Z=0.
translate([box_x + gap, 0, 0])
    lid();