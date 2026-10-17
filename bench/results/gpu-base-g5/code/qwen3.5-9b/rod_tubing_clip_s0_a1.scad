// Snap-on Clip for Lab Stand Rod and Tubing (Corrected)
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
$bridge_start_x = 8;
$bridge_end_x = 12;

// Cutout Dimensions
// Rod cutout: 10mm wide, centered at y=0, on -X side
$rod_cutout_width = 10;
$rod_cutout_half_y = $rod_cutout_width / 2; // 5

// Tubing cutout: 4.5mm wide, centered at y=0, on +X side
$tubing_cutout_width = 4.5;
$tubing_cutout_half_y = $tubing_cutout_width / 2; // 2.25

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Main Body Construction ---
difference() {
    // 1. Create the solid base profile (Outer Rings + Bridge)
    union() {
        // Rod Outer Ring
        translate([0, 0, 0]) {
            cylinder(h = $rod_ring_height, d = $rod_outer_diameter, center = true);
        }
        
        // Tubing Outer Ring
        translate([$tubing_center_x, $tubing_center_y, 0]) {
            cylinder(h = $tubing_ring_height, d = $tubing_outer_diameter, center = true);
        }
        
        // Solid Bridge
        translate([$bridge_start_x, 0, 0]) {
            cube([$bridge_width_x, $bridge_width_y, $bridge_height]);
        }
    }
    
    // 2. Cut out the Rod Hole (Inner Cylinder)
    // Extend slightly past the top and bottom faces to ensure clean cut
    translate([0, 0, -0.01]) 
        cylinder(h = $rod_ring_height + 0.02, d = $rod_diameter, center = true);
    
    // 3. Cut out the Tubing Hole (Inner Cylinder)
    // Extend slightly past the top and bottom faces to ensure clean cut
    translate([$tubing_center_x, $tubing_center_y, -0.01]) 
        cylinder(h = $tubing_ring_height + 0.02, d = $tubing_diameter, center = true);
    
    // 4. Cut out Rod Rectangular Opening (-X side)
    // Position: Centered at y=0, extending from x = -($rod_outer_diameter/2) to x = -($rod_outer_diameter/2) + $rod_cutout_width
    // We subtract a prism that extends slightly past the ring face to ensure the cut goes all the way through
    translate([-($rod_outer_diameter/2) - 0.5, -($rod_cutout_half_y) - 0.01, 0]) 
        cube([$rod_cutout_width + 0.02, $rod_cutout_width + 0.02, $rod_ring_height + 0.01]);
    
    // 5. Cut out Tubing Rectangular Opening (+X side)
    // Position: Centered at y=0, extending from x = $tubing_outer_diameter/2 to x = $tubing_outer_diameter/2 + $tubing_cutout_width
    translate([$tubing_outer_diameter/2 + 0.5, -($tubing_cutout_half_y) - 0.01, 0]) 
        cube([$tubing_cutout_width + 0.02, $tubing_cutout_width + 0.02, $tubing_ring_height + 0.01]);
}