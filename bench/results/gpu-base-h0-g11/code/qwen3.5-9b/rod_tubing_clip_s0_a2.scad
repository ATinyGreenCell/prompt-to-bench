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

// We build the entire part as a single 3D object using difference() at the top level.
// This avoids mixing 2D and 3D operations.

difference() {
    // 1. The Main Solid Body (Union of all positive geometry)
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
    
    // Extrude the main body upwards
    linear_extrude(height = $rod_ring_height, center = true) {
        // The profile for extrusion is the union of the rings and bridge defined above.
        // We do not put cutouts here; we handle them as separate 3D subtraction shapes below.
        // To ensure the extrusion covers the full area, we re-define the union here
        // or simply rely on the fact that the shapes below will cut through.
        // However, to be safe and clean, we define the positive volume here.
        
        // Rod Ring Profile
        circle(r = $rod_outer_diameter / 2, $fn = 64);
        
        // Tubing Ring Profile
        translate([15, 0, 0]) {
            circle(r = $tubing_outer_diameter / 2, $fn = 64);
        }
        
        // Bridge Profile
        translate([10, 0, 0]) {
            square([4, 6], center = true);
        }
    }
    
    // --- Subtraction Shapes (Cutouts) ---
    // These are 3D shapes that extend slightly past the top and bottom faces
    // to ensure clean cuts without coplanar faces.
    
    // 1. Rod Cutout Hole
    // Location: x < 0, -5 < y < 5
    // We subtract a block that covers this area and extends 0.1mm past Z=0 and Z=10.
    translate([-5, -5, -0.05]) {
        square([10, 10], center = true);
        linear_extrude(height = $rod_ring_height + 0.1, center = true) {
            square([10, 10], center = true);
        }
    }
    
    // 2. Tubing Cutout Hole
    // Location: x > 15, -2.25 < y < 2.25
    // Center of cutout is at x=15. Width is 4.5.
    // We subtract a block that covers this area and extends 0.1mm past Z=0 and Z=10.
    translate([15 - $tubing_cutout_half_y, -2.25, -0.05]) {
        square([$tubing_cutout_width, 4.5], center = true);
        linear_extrude(height = $rod_ring_height + 0.1, center = true) {
            square([$tubing_cutout_width, 4.5], center = true);
        }
    }
}