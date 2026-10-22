// --- Dimensions ---
plate_width = 80;          // X dimension of the plate
plate_depth = 60;          // Y dimension of the plate
plate_thickness = 3;       // Z thickness of the plate

camera_hole_dia = 12;       // Diameter of the camera hole
camera_hole_x = -20;        // X position of camera hole
camera_hole_y = 10;         // Y position of camera hole

sleeve_outer_dia = 36.6;    // Outer diameter of the sleeve
sleeve_start_z = 3;         // Z start position of sleeve
sleeve_end_z = 31;          // Z end position of sleeve
sleeve_height = sleeve_end_z - sleeve_start_z; // Total height of sleeve

stop_bore_dia = 22;         // Diameter of the internal stop
stop_bore_end_z = 11;       // Z where the bore widens

eyepiece_bore_dia = 30.6;    // Diameter of the eyepiece sleeve

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
    
    // The internal bore (to be subtracted)
    // We use a union of two cylinders to define the stepped bore geometry
    // and translate it to the correct Z position.
    translate([0, 0, sleeve_start_z - 1]) {
        // Bottom part (the stop: 22mm diameter from z=3 to z=11)
        // The specification says z=3 to z=11, which is a height of 8.
        cylinder(h = (stop_bore_end_z - sleeve_start_z) + 2, d = stop_bore_dia);
        
        // Top part (the eyepiece fit: 30.6mm diameter from z=11 to z=31)
        translate([0, 0, stop_bore_end_z - sleeve_start_z])
            cylinder(h = (sleeve_end_z - stop_bore_end_z) + 2, d = eyepiece_bore_dia);
    }
    
    // Radial screw holes
    for (i = [0 : screw_count - 1]) {
        rotate([0, 0, i * screw_angle_step])
            translate([0, 0, screw_hole_z])
                // Cylinder is oriented along X axis
                rotate([0, 90, 0])
                    cylinder(h = sleeve_outer_dia + 2, d = screw_hole_dia);
    }
}