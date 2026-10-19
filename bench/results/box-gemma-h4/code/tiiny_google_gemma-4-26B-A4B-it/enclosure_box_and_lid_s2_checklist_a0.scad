// Two-part electronics enclosure: Box and Lid
// Designed for FDM printing.

// --- Dimensions ---
box_l      = 70.0;    // Box length (X)
box_w      = 50.0;    // Box width (Y)
box_h      = 30.0;    // Box height (Z)
wall_t     = 2.0;     // Wall thickness
floor_t    = 2.0;     // Floor thickness

lid_plate_t = 2.0;    // Lid plate thickness
lid_lip_h   = 4.0;    // Lip height
lid_lip_t   = 1.5;    // Lip wall thickness
lid_lip_l   = 65.6;   // Lip outer length (X)
lid_lip_w   = 45.6;   // Lip outer width (Y)

// Spacing between parts on the print bed
gap = 10.0;

$fn = 64;

// --- Part 1: The Box ---
// Rests on XY plane at Z=0
module box() {
    difference() {
        // Main outer body
        cube([box_l, box_w, box_h]);
        
        // Hollow interior
        // We subtract the floor and walls to create the cavity
        translate([wall_t, wall_t, floor_t])
            cube([box_l - 2 * wall_t, box_w - 2 * wall_t, box_h]);
    }
}

// --- Part 2: The Lid ---
// Printed upside down (plate on bed, lip pointing up in -Z, 
// but user requested "lid on the +X side" and "printed upside down" 
// meaning the flat plate is at Z=0 and the lip is at Z > 0, 
// but the lid is flipped so the lip is the part that meets the box).
// To print "upside down" for a lid with a lip, the plate sits on the bed 
// and the lip grows upwards.
module lid() {
    union() {
        // The flat plate
        cube([box_l, box_w, lid_plate_t]);
        
        // The rectangular lip
        // Centered on the plate
        translate([(box_l - lid_lip_l) / 2, (box_w - lid_lip_w) / 2, lid_plate_t])
            difference() {
                // Outer profile of the lip
                cube([lid_lip_l, lid_lip_w, lid_lip_h]);
                
                // Inner profile of the lip (to make it a hollow wall)
                translate([lid_lip_t, lid_lip_t, -0.01])
                    cube([lid_lip_l - 2 * lid_lip_t, lid_lip_w - 2 * lid_lip_t, lid_lip_h + 0.02]);
            }
    }
}

// --- Assembly / Layout ---

// Part 1: The Box
translate([0, 0, 0])
    box();

// Part 2: The Lid
// Placed on the +X side of the box with a 10mm gap.
// The box occupies X from 0 to 70. 
// The gap is 10.
// The lid starts at X = 70 + 10 = 80.
translate([box_l + gap, 0, 0])
    lid();