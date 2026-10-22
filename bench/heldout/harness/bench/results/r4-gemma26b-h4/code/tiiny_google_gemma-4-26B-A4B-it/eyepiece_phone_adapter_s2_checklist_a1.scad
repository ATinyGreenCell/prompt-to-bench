// Microscope Eyepiece to Phone Camera Adapter
// Corrected: Sleeve is now correctly centered on the camera hole axis.

// --- Dimensions ---
plate_x      = 80.0;    // Plate width (X)
plate_y      = 60.0;    // Plate depth (Y)
plate_t      = 3.0;     // Plate thickness
cam_hole_d   = 12.0;    // Diameter of camera hole
cam_hole_x   = -20.0;   // X position of camera hole
cam_hole_y   = 10.0;    // Y position of camera hole

sleeve_od    = 36.6;    // Outer diameter of the sleeve
sleeve_h     = 28.0;    // Height of the sleeve (31 - 3)
stop_bore_d  = 22.0;    // Diameter of the internal stop (z=3 to z=11)
stop_h       = 8.0;     // Height of the stop (11 - 3)
eyepiece_bore_d = 30.6; // Diameter for the eyepiece (z=11 to top)

screw_hole_d = 2.5;     // Diameter of the M3 centering screw holes
screw_z      = 21.0;    // Z height of the screw holes
num_screws   = 3;       // Number of radial holes
screw_angle  = 120;     // Degrees between holes

$fn = 64;

// --- Construction ---

// 1. The Base Plate
difference() {
    // The plate itself (centered on origin)
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);
    
    // The camera hole (cut through the plate)
    translate([cam_hole_x, cam_hole_y, -0.5])
        cylinder(h = plate_t + 1, d = cam_hole_d);
}

// 2. The Sleeve (positioned at the camera hole axis)
translate([cam_hole_x, cam_hole_y, plate_t])
difference() {
    // The outer cylinder of the sleeve
    cylinder(h = sleeve_h, d = sleeve_od);
    
    // The large eyepiece bore (from z=11 relative to bed, which is 8mm above plate)
    // We subtract the large bore from the top down.
    translate([0, 0, stop_h])
        cylinder(h = sleeve_h - stop_h + 0.1, d = eyepiece_bore_d);
        
    // The small bore (the stop)
    cylinder(h = stop_h + 0.1, d = stop_bore_d);
    
    // 3. Radial Screw Holes
    // The first hole points in +X direction (0 degrees)
    for (i = [0 : num_screws - 1]) {
        rotate([0, 0, i * screw_angle])
        // Translate to the edge of the sleeve to ensure it cuts through the wall
        // and use a large enough cylinder to clear the geometry.
        translate([0, 0, screw_z - 1])
        rotate([0, 90, 0])
        cylinder(h = sleeve_od, d = screw_hole_d);
    }
}