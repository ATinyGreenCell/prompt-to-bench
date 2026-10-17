// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Stand
$rod_diameter = 12.7;
$rod_wall_thickness = 3;
$rod_outer_diameter = $rod_diameter + 2 * $rod_wall_thickness; // 18.7
$rod_ring_height = 10;

// Tubing
$tubing_inner_diameter = 6;
$tubing_wall_thickness = 2;
$tubing_outer_diameter = $tubing_inner_diameter + 2 * $tubing_wall_thickness; // 10
$tubing_ring_height = 10;

// Bridge
$bridge_width_x = 4; // From x=8 to x=12
$bridge_width_y = 6;
$bridge_height = 10;

// Cutout Dimensions
$rod_cutout_width = 10;
$rod_cutout_y_limit = $rod_cutout_width / 2; // 5

$tubing_cutout_width = 4.5;
$tubing_cutout_y_limit = $tubing_cutout_width / 2; // 2.25

// Positioning
$rod_center_x = 0;
$rod_center_y = 0;

$tubing_center_x = 15;
$tubing_center_y = 0;

// --- Generation ---
$fn = 64;

// We build the entire part as a single difference to ensure it is one watertight body.
// We start with two solid cylinders (rings) and subtract the holes and cutouts.
// We use center=false and z=0 to ensure the part rests on the bed.

difference() {
    // 1. Rod Ring (Solid Block)
    // Centered at (0,0), height 10, from z=0 to z=10.
    translate([$rod_center_x, $rod_center_y, 0]) {
        cylinder(
            h = $rod_ring_height,
            d = $rod_outer_diameter,
            center = false
        );
    }
    
    // 2. Tubing Ring (Solid Block)
    // Centered at (15,0), height 10, from z=0 to z=10.
    translate([$tubing_center_x, $tubing_center_y, 0]) {
        cylinder(
            h = $tubing_ring_height,
            d = $tubing_outer_diameter,
            center = false
        );
    }
    
    // --- Subtractions (Holes and Cutouts) ---
    
    // 1. Rod Inner Hole
    translate([$rod_center_x, $rod_center_y, 0]) {
        cylinder(
            h = $rod_ring_height + 0.1, // Extend slightly to ensure clean cut
            d = $rod_diameter,
            center = false
        );
    }
    
    // 2. Tubing Inner Hole
    translate([$tubing_center_x, $tubing_center_y, 0]) {
        cylinder(
            h = $tubing_ring_height + 0.1,
            d = $tubing_inner_diameter,
            center = false
        );
    }
    
    // 3. Rod Cutout (-X side)
    // Region: x < 0, -5 < y < 5.
    // We subtract a block that covers this area.
    translate([-($rod_cutout_width / 2), -($rod_cutout_y_limit), 0]) {
        cube([
            $rod_cutout_width, 
            $rod_cutout_y_limit * 2, 
            $rod_ring_height + 0.1
        ]);
    }
    
    // 4. Tubing Cutout (+X side)
    // Region: x > 15, -2.25 < y < 2.25.
    translate([$tubing_center_x + ($tubing_cutout_width / 2), -($tubing_cutout_y_limit), 0]) {
        cube([
            $tubing_cutout_width, 
            $tubing_cutout_y_limit * 2, 
            $tubing_ring_height + 0.1
        ]);
    }
    
    // 5. Solid Bridge
    // Specification: 6 mm wide (Y), joins x=8 and x=12.
    // Center X = (8 + 12) / 2 = 10.
    // Width X = 4.
    // Width Y = 6.
    // Height = 10.
    // Position Z = 0.
    translate([10, 0, 0]) {
        cube([
            $bridge_width_x, 
            $bridge_width_y, 
            $bridge_height
        ]);
    }
}