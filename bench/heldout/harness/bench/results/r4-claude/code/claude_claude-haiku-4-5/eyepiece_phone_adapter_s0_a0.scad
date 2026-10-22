// Dimensions (in mm)
plate_x = 80;           // plate length in X
plate_y = 60;           // plate width in Y
plate_z = 3;            // plate thickness
camera_hole_d = 12;     // camera hole diameter
camera_hole_x = -20;    // camera hole X position
camera_hole_y = 10;     // camera hole Y position

sleeve_center_x = camera_hole_x;  // sleeve on camera-hole axis
sleeve_center_y = camera_hole_y;

sleeve_od = 36.6;       // sleeve outer diameter
sleeve_od_r = sleeve_od / 2;
sleeve_z_start = 3;     // sleeve starts at plate top
sleeve_z_end = 31;      // sleeve top (open)
sleeve_height = sleeve_z_end - sleeve_z_start;

bore_small_d = 22;      // bore diameter z=3 to z=11 (stop)
bore_small_r = bore_small_d / 2;
bore_small_z_end = 11;

bore_large_d = 30.6;    // bore diameter z=11 to z=31 (eyepiece)
bore_large_r = bore_large_d / 2;

screw_hole_d = 2.5;     // M3 centring screw holes diameter
screw_hole_r = screw_hole_d / 2;
screw_hole_z = 21;      // Z position of screw holes

$fn = 64;               // resolution for curved surfaces

// Build the part
union() {
    // Flat base plate
    difference() {
        translate([0, 0, plate_z/2]) {
            cube([plate_x, plate_y, plate_z], center=true);
        }
        
        // Camera hole through the plate
        translate([camera_hole_x, camera_hole_y, -0.5]) {
            cylinder(h=plate_z+1, r=camera_hole_d/2, $fn=64);
        }
    }
    
    // Cylindrical sleeve
    difference() {
        // Outer cylinder of sleeve
        translate([sleeve_center_x, sleeve_center_y, sleeve_z_start]) {
            cylinder(h=sleeve_height, r=sleeve_od_r, $fn=64);
        }
        
        // Small bore (stop for eyepiece, z=3 to z=11)
        translate([sleeve_center_x, sleeve_center_y, sleeve_z_start-0.5]) {
            cylinder(h=bore_small_z_end-sleeve_z_start+1, r=bore_small_r, $fn=64);
        }
        
        // Large bore (eyepiece socket, z=11 to z=31)
        translate([sleeve_center_x, sleeve_center_y, bore_small_z_end]) {
            cylinder(h=sleeve_z_end-bore_small_z_end+0.5, r=bore_large_r, $fn=64);
        }
        
        // Three radial holes for M3 centring screws at z=21
        for(i = [0:2]) {
            angle = i * 120;
            translate([sleeve_center_x, sleeve_center_y, screw_hole_z]) {
                rotate([0, 0, angle]) {
                    translate([sleeve_od_r, 0, 0]) {
                        rotate([0, 90, 0]) {
                            cylinder(h=sleeve_od+2, r=screw_hole_r, center=true, $fn=64);
                        }
                    }
                }
            }
        }
    }
}