// Microscope Eyepiece to Phone Camera Adapter
// Corrected: Single difference block to ensure all holes are subtracted.

// --- Dimensions ---
plate_x      = 80.0;    // Plate width (X)
plate_y      = 60.0;    // Plate depth (Y)
plate_t      = 3.0;     // Plate thickness
cam_hole_d   = 12.0;    // Diameter of camera hole
cam_hole_x   = -20.0;   // X position of camera hole
cam_hole_y   = 10.0;    // Y position of camera hole

sleeve_od    = 36.6;    // Outer diameter of the sleeve
sleeve_h     = 28.0;    // Height of the sleeve (31 - 3)
stop_bore_d  = 22.0;    // Diameter of the bottom bore (the stop)
stop_h       = 8.0;     // Height of the stop (11 - 3)
eye_bore_d   = 30.6;    // Diameter of the top bore (eyepiece fit)

screw_hole_d  = 2.5;    // Diameter of the M3 centering screw holes
screw_z       = 21.0;   // Z height of the screw holes
num_screws    = 3;      // Number of radial screw holes
screw_angle    = 120;   // Angular spacing of screw holes

$fn = 64;

// --- Main Assembly ---

difference() {
    // The "Positive" Geometry (The solid parts)
    union() {
        // 1. The Base Plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // 2. The Sleeve
        translate([0, 0, plate_t])
            cylinder(h = sleeve_h, d = sleeve_od);
    }

    // The "Negative" Geometry (The holes to be cut)
    
    // 3. The Camera Hole (through the plate)
    translate([cam_hole_x, cam_hole_y, -0.01])
        cylinder(h = plate_t + 0.02, d = cam_hole_d);

    // 4. The Sleeve Bores
    // Stop bore (bottom part of sleeve)
    translate([0, 0, plate_t - 0.01])
        cylinder(h = stop_h + 0.01, d = stop_bore_d);
    
    // Eyepiece bore (top part of sleeve)
    translate([0, 0, plate_t + stop_h - 0.01])
        cylinder(h = sleeve_h - stop_h + 0.02, d = eye_bore_d);

    // 5. Radial Screw Holes
    // The first hole points in +X direction (0 degrees)
    for (i = [0 : num_screws - 1]) {
        angle = i * screw_angle;
        rotate([0, 0, angle])
            translate([0, 0, screw_z])
                // Rotate cylinder to point radially outward
                rotate([0, 90, 0])
                    // Make cylinder long enough to clear the sleeve wall
                    cylinder(h = sleeve_od, d = screw_hole_d);
    }
}