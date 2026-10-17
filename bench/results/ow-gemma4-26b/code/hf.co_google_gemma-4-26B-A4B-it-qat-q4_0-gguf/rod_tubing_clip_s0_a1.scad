// --- Parameters (Dimensions in mm) ---

// Rod Ring (Inner diameter 12.7mm, Wall 3mm)
rod_inner_dia = 12.7;
rod_wall = 3.0;
rod_outer_dia = rod_inner_dia + (2 * rod_wall);

// Rod Ring Cutout (10mm wide, 10mm tall, centered on -X side)
// Prompt: "everything with x < 0 and -5 < y < 5 is removed"
rod_cutout_width = 5.0; // From x = -5 to x = 0
rod_cutout_height = 10.0;

// Tubing Ring (Inner diameter 6mm, Wall 2mm)
tube_inner_dia = 6.0;
tube_wall = 2.0;
tube_outer_dia = tube_inner_dia + (2 * tube_wall);
tube_offset_x = 15.0;

// Tubing Ring Cutout (4.5mm wide, centered on +X side)
// Prompt: "x > 15 and -2.25 < y < 2.25"
tube_cutout_width = 4.5;
tube_cutout_height = 4.5;

// Bridge (6mm wide in Y, between x=8 and x=12)
bridge_x_start = 8.0;
bridge_x_end = 12.0;
bridge_y_width = 6.0;

// Extrusion Height
extrusion_z = 10.0;

// Resolution
$fn = 64;

// --- Modeling ---

// We define the 2D profile first to avoid mixing 2D and 3D objects.
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
            // A rectangle from x=8 to x=12, centered on Y
            translate([(bridge_x_start + bridge_x_end)/2, 0])
                square([bridge_x_end - bridge_x_start, bridge_y_width], center = true);
        }

        // Subtract Rod Cutout: x < 0 and -5 < y < 5
        // We use a rectangle from x = -5 to x = 0.5 (to ensure clean cut)
        // and y = -5.5 to 5.5 (to ensure clean cut)
        translate([-2.5, 0])
            square([5.5, 11.0], center = true);

        // Subtract Tubing Cutout: x > 15 and -2.25 < y < 2.25
        // We use a rectangle from x = 14.5 to x = 20 (to ensure clean cut)
        // and y = -2.5 to 2.5 (to ensure clean cut)
        translate([17.25, 0])
            square([5.5, 5.0], center = true);
    }
}

// Final 3D Object: Extrude the 2D profile
linear_extrude(height = extrusion_z) {
    profile_2d();
}