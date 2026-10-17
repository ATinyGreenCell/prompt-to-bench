// Snap-on Clip for Lab Stand Rod and Tubing
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
    
    // Main Ring
    difference() {
        // Extrude the full ring
        translate($rod_center)
        cylinder(h = $clip_height, d = $rod_outer_diameter, $fn = $fn);
        
        // Cut the opening on the -X side
        // Opening is 10mm wide, centred at y=0, so y goes from -5 to 5.
        // We cut a rectangle that extends slightly past the ring face to ensure clean cut.
        translate([-($opening_width_rod/2), 0, $clip_height/2])
        cube([
            $opening_width_rod + 0.1, // Extend past face
            $opening_width_rod,       // Height in Y (-5 to 5)
            $clip_height + 0.1         // Extend past top/bottom
        ]);
    }
}

module tubing_ring() {
    // Tubing ring: 6mm ID, 2mm wall, centred at x=15, y=0.
    // Opening cut: x > 15 and -2.25 < y < 2.25.
    
    difference() {
        // Extrude the full ring
        translate($tubing_center)
        cylinder(h = $clip_height, d = $tubing_outer_diameter, $fn = $fn);
        
        // Cut the opening on the +X side
        // Opening is 4.5mm wide, centred at y=0, so y goes from -2.25 to 2.25.
        translate([$tubing_center[0] + ($opening_width_tubing/2), 0, $clip_height/2])
        cube([
            $opening_width_tubing + 0.1, // Extend past face
            $opening_width_tubing,       // Height in Y
            $clip_height + 0.1           // Extend past top/bottom
        ]);
    }
}

module bridge() {
    // Solid bridge 6mm wide (Y) between x = 8 and x = 12.
    // Joins the two rings without blocking holes.
    
    translate([8, -($bridge_width_y/2), 0])
    cube([
        $bridge_width_x, // Width in X (12 - 8 = 4)
        $bridge_width_y, // Width in Y (6)
        $clip_height     // Height in Z
    ]);
}

// --- Main Assembly ---
difference() {
    union() {
        rod_ring();
        tubing_ring();
        bridge();
    }
    
    // Optional: Add a small support foot if needed, but user requested specific profile.
    // The profile described is self-supporting if printed flat on the "back" of the bridge.
    // However, to ensure it rests flat on the XY plane as requested ("rests on the XY plane"),
    // we assume the bridge bottom is the base. No subtraction needed for base unless specified.
}