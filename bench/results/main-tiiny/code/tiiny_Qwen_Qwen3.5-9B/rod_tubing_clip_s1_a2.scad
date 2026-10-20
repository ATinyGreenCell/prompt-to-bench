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
        // Region: x < 0, -5 < y < 5.
        // Cutout Box: x from -5 to 0 (width 10), y from -5 to 5 (width 10).
        // Center of this box: x = -2.5, y = 0.
        // We add 1mm buffer to ensure we cut through the wall.
        translate([-2.5, 0, 0]) {
            cube([($rod_cutout_width + 1), ($rod_cutout_half_y * 2 + 1), $height + 1], 
                  center = [0, 0, $height/2]);
        }
        
        // 3. Cut out the Tubing Opening (+X side)
        // Region: x > 15, -2.25 < y < 2.25.
        // Cutout Box: x from 15 to 19.5 (width 4.5), y from -2.25 to 2.25 (width 4.5).
        // Center of this box: x = 15 + (4.5/2) = 17.25, y = 0.
        // We add 1mm buffer to ensure we cut through the wall.
        translate([17.25, 0, 0]) {
            cube([$tubing_cutout_width + 1, ($tubing_cutout_half_y * 2) + 1, $height + 1], 
                  center = [0, 0, $height/2]);
        }
    }
}

// Generate the part
snap_on_clip();