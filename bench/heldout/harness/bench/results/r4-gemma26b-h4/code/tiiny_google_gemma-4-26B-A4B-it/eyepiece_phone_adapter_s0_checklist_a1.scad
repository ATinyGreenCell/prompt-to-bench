// Microscope Eyepiece to Phone Camera Adapter
// Corrected version: Screw holes now correctly positioned on the sleeve wall.

// --- Dimensions ---
plate_x      = 80.0;    // Plate width (X)
plate_y      = 60.0;    // Plate depth (Y)
plate_t      = 3.0;     // Plate thickness
cam_hole_d   = 12.0;    // Diameter of camera hole
cam_hole_x   = -20.0;   // X position of camera hole
cam_hole_y   = 10.0;    // Y position of camera hole

sleeve_od    = 36.6;    // Outer diameter of the sleeve
sleeve_h     = 28.0;    // Height of the sleeve (31 - 3)
stop_bore_d  = 22.0;    // Diameter of the stop bore (z=3 to z=11)
stop_h       = 8.0;     // Height of the stop bore (11 - 3)
eye_bore_d   = 30.6;    // Diameter of the eyepiece bore (z=11 to top)

screw_hole_d  = 2.5;    // Diameter of the M3 centering screw holes
screw_z       = 21.0;   // Z height of the screw holes
num_screws    = 3;      // Number of radial screw holes
screw_angle    = 120;    // Angular spacing between screws

$fn = 64;

// --- Main Assembly ---

difference() {
    union() {
        // The Base Plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // The Sleeve
        translate([0, 0, plate_t])
            cylinder(h = sleeve_h, d = sleeve_od);
    }

    // 1. Camera Hole (through the plate)
    translate([cam_hole_x, cam_hole_y, -0.5])
        cylinder(h = plate_t + 1, d = cam_hole_d);

    // 2. Stop Bore (inner diameter from z=3 to z=11)
    translate([0, 0, plate_t])
        cylinder(h = stop_h + 0.1, d = stop_bore_d);

    // 3. Eyepiece Bore (inner diameter from z=11 to top)
    translate([0, 0, plate_t + stop_h])
        cylinder(h = sleeve_h - stop_h + 1, d = eye_bore_d);

    // 4. Radial Screw Holes
    // We translate the hole to the radius of the sleeve so it cuts the wall.
    for (i = [0 : num_screws - 1]) {
        angle = i * screw_angle;
        rotate([0, 0, angle])
            translate([sleeve_od / 2, 0, screw_z])
                rotate([0, 90, 0])
                    cylinder(h = sleeve_od, d = screw_hole_d);
    }
}