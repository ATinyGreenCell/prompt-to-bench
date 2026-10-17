// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Stand Dimensions
$rod_diameter = 12.7;
$rod_wall_thickness = 3;
$rod_outer_diameter = $rod_diameter + 2 * $rod_wall_thickness; // 18.7
$rod_ring_height = 10;

// Tubing Dimensions
$tubing_diameter = 6;
$tubing_wall_thickness = 2;
$tubing_outer_diameter = $tubing_diameter + 2 * $tubing_wall_thickness; // 8
$tubing_ring_height = 10;

// Positioning
$rod_center_x = 0;
$rod_center_y = 0;
$tubing_center_x = 15;
$tubing_center_y = 0;

// Bridge Dimensions
$bridge_width_x = 4; // From x=8 to x=12
$bridge_width_y = 6;
$bridge_height = 10;

// Cutout Dimensions
$rod_cutout_width = 10;
$rod_cutout_height = 10; // -5 to 5

$tubing_cutout_width = 4.5;
$tubing_cutout_height = 4.5; // -2.25 to 2.25

// --- Configuration ---
$fn = 128; // High resolution for smooth curves

module rod_ring() {
    // Main Ring
    difference() {
        // Extrude the full outer circle
        translate([0, 0, 0])
            cylinder(h = $rod_ring_height, d = $rod_outer_diameter, $fn = $fn);
        
        // Inner Hole
        translate([0, 0, 0.01])
            cylinder(h = $rod_ring_height + 0.02, d = $rod_diameter, $fn = $fn);
        
        // Cutout on -X side
        // Spec: "everything with x < 0 and -5 < y < 5 is removed"
        // This implies the cutout starts at x=0 and goes left to x=-10.
        // Box X range: [-10, 0]. Center = -5.
        // Box Y range: [-5, 5]. Center = 0.
        
        translate([
            -$rod_cutout_width / 2, // -5
            -$rod_cutout_height / 2 - 0.01, // -5.01
            0.01
        ])
            cube([
                $rod_cutout_width + 0.02, // 10.02
                $rod_cutout_height + 0.02, // 10.02
                $rod_ring_height + 0.02
            ]);
    }
}

module tubing_ring() {
    // Main Ring
    difference() {
        // Extrude the full outer circle
        translate([0, 0, 0])
            cylinder(h = $tubing_ring_height, d = $tubing_outer_diameter, $fn = $fn);
        
        // Inner Hole
        translate([0, 0, 0.01])
            cylinder(h = $tubing_ring_height + 0.02, d = $tubing_diameter, $fn = $fn);
        
        // Cutout on +X side
        // Spec: "x > 15 and -2.25 < y < 2.25"
        // This implies the cutout starts at x=15 and goes right to x=19.5.
        // Box X range: [15, 19.5]. Center = 17.25.
        // Box Y range: [-2.25, 2.25]. Center = 0.
        
        translate([
            $tubing_cutout_width / 2 - 0.01, // 2.25 - 0.01 = 2.24 (Wait, logic check)
            // We need the box to start at 15.
            // Box width is 4.5.
            // Start X = 15.
            // Translate X = 15 - (4.5 / 2) = 12.75.
            // Let's re-verify: 12.75 + 2.25 = 15. Correct.
            15 - ($tubing_cutout_width / 2) - 0.01, 
            -$tubing_cutout_height / 2 - 0.01, 
            0.01
        ])
            cube([
                $tubing_cutout_width + 0.02, // 4.52
                $tubing_cutout_height + 0.02, // 4.52
                $tubing_ring_height + 0.02
            ]);
    }
}

module bridge() {
    // Solid bridge between x=8 and x=12
    // Width in Y is 6mm.
    // Height is 10mm.
    translate([8, -3, 0])
        cube([4, 6, 10]);
}

// --- Main Assembly ---
difference() {
    union() {
        // 1. Rod Ring
        translate([$rod_center_x, $rod_center_y, 0])
            rod_ring();
        
        // 2. Tubing Ring
        translate([$tubing_center_x, $tubing_center_y, 0])
            tubing_ring();
        
        // 3. Bridge
        bridge();
    }
}