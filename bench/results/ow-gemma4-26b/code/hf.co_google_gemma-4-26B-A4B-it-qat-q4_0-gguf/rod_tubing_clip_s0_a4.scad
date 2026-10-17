// --- Parameters (Dimensions in mm) ---

// Rod Ring (Inner diameter 12.7mm, Wall 3mm)
rod_inner_dia = 12.7;
rod_wall = 3.0;
rod_outer_dia = rod_inner_dia + (2 * rod_wall); // 18.7mm

// Rod Ring Cutout (10mm wide, 10mm tall, centered on -X side)
// Specification: "10 mm wide opening cut out of its -X side (everything with x < 0 and -5 < y < 5 is removed)"
// This implies the cutout is the region: x in [-5, 0] and y in [-5, 5].
rod_cutout_x_min = -5.0;
rod_cutout_x_max = 0.0;
rod_cutout_y_min = -5.0;
rod_cutout_y_max = 5.0;

// Tubing Ring (Inner diameter 6mm, Wall 2mm)
tube_inner_dia = 6.0;
tube_wall = 2.0;
tube_outer_dia = tube_inner_dia + (2 * tube_wall); // 10.0mm
tube_offset_x = 15.0;

// Tubing Ring Cutout (4.5mm wide, centered on +X side)
// Specification: "4.5 mm wide opening cut out of its +X side (x > 15 and -2.25 < y < 2.25)"
// This implies the cutout is the region: x in [15, 19.5] and y in [-2.25, 2.25].
tube_cutout_x_min = 15.0;
tube_cutout_x_max = 19.5;
tube_cutout_y_min = -2.25;
tube_cutout_y_max = 2.25;

// Bridge (6mm wide in Y, between x=8 and x=12)
bridge_x_start = 8.0;
bridge_x_end = 12.0;
bridge_y_width = 6.0;

// Extrusion Height
extrusion_z = 10.0;

// Resolution
$fn = 64;

// --- Modeling ---

module profile_2d() {
    difference() {
        union() {
            // 1. Rod Ring Profile
            difference() {
                circle(d = rod_outer_dia);
                circle(d = rod_inner_dia);
            }
            
            // 2. Tubing Ring Profile
            translate([tube_offset_x, 0])
            difference() {
                circle(d = tube_outer_dia);
                circle(d = tube_inner_dia);
            }
            
            // 3. Solid Bridge Profile
            // Spans from x=8 to x=12, centered on Y
            translate([(bridge_x_start + bridge_x_end)/2, 0])
                square([bridge_x_end - bridge_x_start, bridge_y_width], center = true);
        }

        // Subtract Rod Cutout: x < 0 and -5 < y < 5
        // We use a rectangle that covers the specified range and extends slightly to ensure clean cut.
        // The prompt specifies the region to be removed.
        translate([rod_cutout_x_min, 0])
            square([rod_cutout_x_max - rod_cutout_x_min + 0.1, rod_cutout_y_max - rod_cutout_y_min + 0.1], center = true);

        // Subtract Tubing Cutout: x > 15 and -2.25 < y < 2.25
        // The prompt specifies the region to be removed.
        translate([tube_cutout_x_min, 0])
            square([tube_cutout_x_max - tube_cutout_x_min + 0.1, tube_cutout_y_max - tube_cutout_y_min + 0.1], center = true);
    }
}

// Final 3D Object: Extrude the 2D profile
linear_extrude(height = extrusion_z) {
    profile_2d();
}