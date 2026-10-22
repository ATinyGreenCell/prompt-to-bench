// --- Dimensions ---
plate_width = 80;          // X dimension of the plate
plate_depth = 60;          // Y dimension of the plate
plate_thickness = 3;       // Z thickness of the plate

camera_hole_dia = 12;       // Diameter of the camera hole
camera_hole_x = -20;        // X position of camera hole
camera_hole_y = 10;         // Y position of camera hole

sleeve_outer_dia = 36.6;    // Outer diameter of the sleeve
sleeve_height = 28;         // Height of sleeve (31 - 3)
sleeve_start_z = 3;         // Z start position of sleeve

stop_bore_dia = 22;         // Diameter of the internal stop
stop_bore_height = 8;       // Height of the stop (11 - 3)

eyepiece_bore_dia = 30.6;    // Diameter of the eyepiece sleeve
eyepiece_bore_start_z = 11; // Z where the bore widens

screw_hole_dia = 2.5;       // Diameter of the M3 centering screw holes
screw_hole_z = 21;          // Z height of the screw holes
screw_count = 3;            // Number of radial holes
screw_angle_step = 120;     // Degrees between holes

// --- Constants ---
$fn = 64;

// --- Main Assembly ---

// 1. The Base Plate
difference() {
    // Main plate body
    translate([-plate_width/2, -plate_depth/2, 0])
        cube([plate_width, plate_depth, plate_thickness]);
    
    // Camera hole (extended to ensure clean cut)
    translate([camera_hole_x, camera_hole_y, -1])
        cylinder(h = plate_thickness + 2, d = camera_hole_dia);
}

// 2. The Sleeve
difference() {
    // Outer sleeve body
    translate([0, 0, sleeve_start_z])
        cylinder(h = sleeve_height, d = sleeve_outer_dia);
    
    // The internal bore (the part that goes through the whole sleeve)
    // We use a union of two cylinders to define the stepped bore
    translate([0, 0, -1]) {
        // Bottom part (the stop)
        cylinder(h = stop_bore_height + 2, d = stop_bore_dia);
        // Top part (the eyepiece fit)
        translate([0, 0, stop_bore_height])
            cylinder(h = sleeve_height - stop_bore_height + 2, d = eyepiece_bore_dia);
    }
    
    // Radial screw holes
    for (i = [0 : screw_count - 1]) {
        rotate([0, 0, i * screw_angle_step])
            translate([0, 0, screw_hole_z])
                // Cylinder is oriented along X axis, so we rotate it
                rotate([0, 90, 0])
                    cylinder(h = sleeve_outer_dia + 2, d = screw_hole_dia);
    }
}