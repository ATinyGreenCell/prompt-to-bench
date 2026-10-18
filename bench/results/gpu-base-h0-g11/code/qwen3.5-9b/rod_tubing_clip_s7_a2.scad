// Snap-on Clip for Lab Stand Rod and Tubing (Corrected)
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Stand Dimensions
$rod_diameter = 12.7;
$rod_wall_thickness = 3;
$rod_outer_diameter = $rod_diameter + 2 * $rod_wall_thickness; // 18.7
$rod_center = [0, 0];

// Tubing Dimensions
$tubing_diameter = 6;
$tubing_wall_thickness = 2;
$tubing_outer_diameter = $tubing_diameter + 2 * $tubing_wall_thickness; // 10
$tubing_center = [15, 0];

// Clip Geometry
$clip_height = 10;
$bridge_width_x = 4; // Distance between x=8 and x=12
$bridge_width_y = 6;
$opening_width_rod = 10;
$opening_width_tubing = 4.5;

// Extrusion settings
$fn = 64;

module rod_ring() {
    // Rod ring: 12.7mm ID, 3mm wall, centred at origin.
    // Opening cut: x < 0 and -5 < y < 5.
    
    difference() {
        // 1. Create the full outer ring (OD = 18.7)
        translate($rod_center)
        cylinder(h = $clip_height, d = $rod_outer_diameter, $fn = $fn);
        
        // 2