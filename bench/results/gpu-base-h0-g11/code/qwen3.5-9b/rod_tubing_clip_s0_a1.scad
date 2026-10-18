// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building upward (+Z)
// Units: Millimetres

// --- Dimensions ---
// Rod Stand Dimensions
$rod_diameter = 12.7;
$rod_wall_thickness = 3;
$rod_outer_diameter = $rod_diameter + 2 * $rod_wall_thickness; // 18.7
$rod_ring_height = 10;

// Tubing Dimensions
$tubing_diameter = 6;
$tubing_wall_thickness = 2;
$tubing_outer_diameter = $tubing_diameter + 2 * $tubing_wall_thickness; // 10
$tubing_ring_height = 10;

// Bridge Dimensions
$bridge_width_x = 4; // Distance between x=8 and x=12
$bridge_width_y = 6;
$bridge_height = 10;

// Cutout Dimensions (Opening widths)
$rod_cutout_width = 10;
$rod_cutout_half_y = $rod_cutout_width / 2; // 5

$tubing_cutout_width = 4.5;
$tubing_cutout_half_y = $tubing_cutout_width / 2; // 2.25

// --- Geometry Construction ---

// Main Body Profile (Extruded along Z)
difference() {
    // 1. Create the solid base profile in XY plane
    union() {
        // Rod Ring
        // Outer circle
        circle(r = $rod_outer_diameter / 2, $fn = 64);
        
        // Tubing Ring
        translate([15, 0, 0]) {
            circle(r = $tubing_outer_diameter / 2, $fn = 64);
        }
        
        // Solid Bridge
        translate([10, 0, 0]) {
            square([4, 6], center = true);
        }
    }
    
    // Extrude upwards to create the 3D part
    linear_extrude(height = $rod_ring_height, center = true) {
        // We need to subtract the cutouts from the profile before extruding
        // to ensure clean faces.
        
        // Rod Cutout: x < 0 and -5 < y < 5
        // We subtract a rectangle defined by the cutout dimensions
        translate([-5, -5, 0]) {
            square([10, 10], center = true);
        }
        
        // Tubing Cutout: x > 15 and -2.25 < y < 2.25
        // Center of cutout is at x=15. Width is 4.5, so x ranges from 15-2.25 to 15+2.25.
        // We subtract a rectangle defined by the cutout dimensions
        translate([15 - $tubing_cutout_half_y, -2.25, 0]) {
            square([$tubing_cutout_width, 4.5], center = true);
        }
    }
}

// --- Cutouts (Difference shapes) ---
// These shapes extend slightly past the faces to ensure no coplanar issues during printing
// We must define these as 3D objects (extruded squares) to subtract from the main body

// Rod Cutout Hole
translate([-5, -5, 0]) {
    // Extend 0.1mm past the top and bottom faces
    square([10, 10], center = true);
    linear_extrude(height = $rod_ring_height + 0.1, center = true) {
        square([10, 10], center = true);
    }
}

// Tubing Cutout Hole
translate([15 - $tubing_cutout_half_y, -2.25, 0]) {
    // Extend 0.1mm past the top and bottom faces
    square([$tubing_cutout_width, 4.5], center = true);
    linear_extrude(height = $rod_ring_height + 0.1, center = true) {
        square([$tubing_cutout_width, 4.5], center = true);
    }
}