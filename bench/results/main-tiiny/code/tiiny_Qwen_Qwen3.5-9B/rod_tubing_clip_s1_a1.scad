$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Dimensions ---
// Rod dimensions
$rod_diameter = 12.7;
$rod_radius = $rod_diameter / 2;
$rod_wall_thickness = 3;
$rod_outer_diameter = $rod_diameter + (2 * $rod_wall_thickness);
$rod_outer_radius = $rod_outer_diameter / 2;

// Tubing dimensions
$tubing_diameter = 6;
$tubing_radius = $tubing_diameter / 2;
$tubing_wall_thickness = 2;
$tubing_outer_diameter = $tubing_diameter + (2 * $tubing_wall_thickness);
$tubing_outer_radius = $tubing_outer_diameter / 2;

// Positioning
$bridge_start_x = 8;
$bridge_end_x = 12;
$bridge_width_y = 6;

// Cutout dimensions
$rod_cutout_width = 10;
$rod_cutout_half_y = 5;

$tubing_cutout_width = 4.5;
$tubing_cutout_half_y = 2.25;

// Extrusion height
$height = 10;

// --- Main Module ---
module snap_on_clip() {
    difference() {
        // 1. Create the solid base profile (Union of all parts)
        union() {
            // Rod Ring
            // Outer cylinder
            cylinder(h = $height, r = $rod_outer_radius, center = [0, 0, $height/2]);
            
            // Tubing Ring (Positioned at x=15, y=0)
            translate([15, 0, 0]) {
                cylinder(h = $height, r = $tubing_outer_radius, center = [0, 0, $height/2]);
            }
            
            // Solid Bridge (Positioned between x=8 and x=12)
            // Width is 6mm in Y, centered at y=0 -> y from -3 to 3
            translate([$bridge_start_x, 0, 0]) {
                cube([($bridge_end_x - $bridge_start_x), $bridge_width_y, $height], center = [0, 0, $height/2]);
            }
        }
        
        // 2. Cut out the Rod Opening (-X side)
        // Condition: x < 0 and -5 < y < 5
        // We extend slightly past the faces to ensure clean cut
        // The cutout is 10mm wide (from x=-5 to x=0). 
        // We need to cut from x = -5 - buffer to x = 0 + buffer.
        // Center of this cutout box is at x = -2.5.
        translate([-($rod_radius + 0.5), 0, 0]) {
            // Cut a box that covers the opening area
            // Width: 10mm (from x=-5 to x=0) + buffer
            // Height: 10mm (from y=-5 to y=5) + buffer
            // Depth: Full height + buffer
            // Center calculation: 
            // x_center = -5 + (10/2) = 0? No.
            // Range is [-5, 0]. Center is -2.5.
            // Let's use explicit translation for clarity.
            translate([-2.5, 0, 0]) {
                cube([($rod_cutout_width + 1), ($rod_cutout_half_y * 2 + 1), $height + 1], 
                      center = [0, 0, $height/2]);
            }
        }
        
        // 3. Cut out the Tubing Opening (+X side)
        // Condition: x > 15 and -2.25 < y < 2.25
        // The cutout is 4.5mm wide (from x=15 to x=19.5).
        // Center of this cutout box is at x = 15 + (4.5/2) = 17.25.
        translate([17.25, 0, 0]) {
            // Cut a box that covers the opening area
            // Width: 4.5mm (from x=15 to x=19.5) + buffer
            // Height: 4.5mm (from y=-2.25 to y=2.25) + buffer
            // Depth: Full height + buffer
            cube([$tubing_cutout_width + 1, ($tubing_cutout_half_y * 2) + 1, $height + 1], 
                  center = [0, 0, $height/2]);
        }
    }
}

// Generate the part
snap_on_clip();