$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Dimensions ---
// Rod Stand Dimensions
$rod_diameter = 12.7;
$rod_wall_thickness = 3;
$rod_outer_diameter = $rod_diameter + (2 * $rod_wall_thickness); // 18.7 mm
$rod_inner_radius = $rod_diameter / 2;

// Tubing Dimensions
$tubing_outer_diameter = 6;
$tubing_wall_thickness = 2;
$tubing_inner_diameter = $tubing_outer_diameter - (2 * $tubing_wall_thickness); // 4 mm
$tubing_inner_radius = $tubing_inner_diameter / 2;

// Positioning
$rod_center = [0, 0];
$tubing_center = [15, 0];

// Bridge Dimensions
$bridge_width_x = 4; // From x=8 to x=12
$bridge_width_y = 6;
$bridge_start_x = 8;
$bridge_end_x = 12;

// Cutout Dimensions
// Rod Cutout: 10mm wide (-5 to +5), centered at y=0
$rod_cutout_width = 10;
$rod_cutout_half_y = $rod_cutout_width / 2;

// Tubing Cutout: 4.5mm wide (-2.25 to +2.25), centered at y=0
$tubing_cutout_width = 4.5;
$tubing_cutout_half_y = $tubing_cutout_width / 2;

// Extrusion Height
$height = 10;

// --- Main Module ---
module lab_clip() {
    difference() {
        // 1. Create the solid base profile (Union of all parts)
        union() {
            // Rod Ring
            difference() {
                cylinder(
                    h = $height,
                    r = $rod_outer_diameter / 2,
                    center = $rod_center
                );
                
                // Cutout for Rod Ring
                // Extends slightly past the face to ensure clean cut
                translate([0, 0, $height/2 + 0.01]) 
                    cube([
                        $rod_cutout_width + 0.1, 
                        $rod_cutout_half_y * 2 + 0.1, 
                        $height + 0.02
                    ]);
            }
            
            // Tubing Ring
            translate($tubing_center)
            difference() {
                cylinder(
                    h = $height,
                    r = $tubing_outer_diameter / 2,
                    center = [0, 0]
                );
                
                // Cutout for Tubing Ring
                // Extends slightly past the face to ensure clean cut
                translate([0, 0, $height/2 + 0.01]) 
                    cube([
                        $tubing_cutout_width + 0.1, 
                        $tubing_cutout_half_y * 2 + 0.1, 
                        $height + 0.02
                    ]);
            }
            
            // Solid Bridge
            // Extends slightly past the face to ensure clean cut
            translate([$bridge_start_x, -($bridge_width_y/2), $height/2 + 0.01])
                cube([
                    $bridge_width_x + 0.1, 
                    $bridge_width_y + 0.1, 
                    $height + 0.02
                ]);
        }
        
        // 2. Cut out the internal voids (Difference)
        // We use a slightly larger extrusion for the voids to ensure no coplanar faces
        
        // Void inside Rod Ring
        translate($rod_center)
        translate([0, 0, $height/2 + 0.01])
            cube([
                $rod_diameter + 0.1, 
                $rod_diameter + 0.1, 
                $height + 0.02
            ]);
            
        // Void inside Tubing Ring
        translate($tubing_center)
        translate([0, 0, $height/2 + 0.01])
            cube([
                $tubing_inner_diameter + 0.1, 
                $tubing_inner_diameter + 0.1, 
                $height + 0.02
            ]);
    }
}

// Render the part
lab_clip();