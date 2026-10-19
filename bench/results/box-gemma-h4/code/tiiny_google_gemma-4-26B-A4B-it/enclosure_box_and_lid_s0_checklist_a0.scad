// Two-part electronics enclosure: Box and Lid
// Designed for FDM printing.

// --- Dimensions: Box ---
box_x = 70.0;      // Outer width (X)
box_y = 50.0;      // Outer depth (Y)
box_z = 30.0;      // Outer height (Z)
wall_t = 2.0;      // Wall thickness
floor_t = 2.0;     // Floor thickness

// --- Dimensions: Lid ---
lid_plate_x = 70.0; // Plate width (X)
lid_plate_y = 50.0; // Plate depth (Y)
lid_plate_z = 2.0;  // Plate thickness (Z)
lip_h = 4.0;        // Lip height
lip_t = 1.5;        // Lip wall thickness
lip_outer_x = 65.6; // Lip outer width (X)
lip_outer_y = 45.6; // Lip outer depth (Y)

// --- Spacing ---
gap = 10.0;         // Gap between parts on the print bed

$fn = 64;

// --- Part 1: The Box ---
// Positioned at the origin, sitting on Z=0
module box() {
    difference() {
        // Main outer body
        cube([box_x, box_y, box_z]);
        
        // Hollow interior
        translate([wall_t, wall_t, floor_t])
            cube([box_x - 2 * wall_t, box_y - 2 * wall_t, box_z]);
    }
}

// --- Part 2: The Lid ---
// Printed upside down (lid plate on bed, lip pointing up in -Z or flipped)
// User requested: "a plate 70x50x2 lying on the bed, with a rectangular lip on top of it"
// To print "upside down" so the lip is on the top surface of the plate, 
// we model the plate on the bed and the lip extending upwards.
module lid() {
    union() {
        // The base plate
        cube([lid_plate_x, lid_plate_y, lid_plate_z]);
        
        // The lip (centered on the plate)
        translate([
            (lid_plate_x - lip_outer_x) / 2, 
            (lid_plate_y - lip_outer_y) / 2, 
            lid_plate_z
        ])
        difference() {
            // Outer volume of lip
            cube([lip_outer_x, lip_outer_y, lip_h]);
            
            // Inner volume of lip (to create the wall)
            translate([lip_t, lip_t, -0.01])
                cube([lip_outer_x - 2 * lip_t, lip_outer_y - 2 * lip_t, lip_h + 0.02]);
        }
    }
}

// --- Assembly Layout ---

// Print the Box
translate([0, 0, 0]) 
    box();

// Print the Lid
// Placed on the +X side of the box with a 10mm gap
translate([box_x + gap, 0, 0]) 
    lid();