// Adapter: phone camera over microscope eyepiece, printed phone-side down
// All dimensions in mm, measured with calipers.

// ---- Base plate ----
plate_x = 80;   // plate length in X
plate_y = 60;   // plate width in Y
plate_t = 3;    // plate thickness (z = 0 to 3)

// ---- Camera hole in plate ----
cam_hole_d = 12;        // camera lens hole diameter
cam_hole_x = -20;       // hole centre X
cam_hole_y = 10;        // hole centre Y

// ---- Round sleeve (on camera-hole axis) ----
sleeve_od  = 36.6;      // sleeve outer diameter
sleeve_z0  = 3;         // sleeve bottom (sits on plate top)
sleeve_z1  = 31;        // sleeve top (open)

// sleeve bore: two diameters
bore1_d = 22;           // lower bore (eyepiece stop), z = 3 to 11
bore1_z0 = 3;
bore1_z1 = 11;
bore2_d = 30.6;         // upper bore (slides over eyepiece), z = 11 to 31
bore2_z0 = 11;
bore2_z1 = 31;

// ---- Radial M3 centring-screw holes in sleeve wall ----
screw_hole_d = 2.5;     // hole diameter for M3 screws
screw_hole_z = 21;      // hole axis height
screw_hole_len = 20;    // radial length (extends past both walls)
screw_angles = [0, 120, 240];  // 120° apart, first pointing +X

$fn = 64;

// ============================
//  BUILD
// ============================

// 1. Base plate (centred on origin in X,Y; z = 0..3)
plate = translate([0, 0, 0])
    cube([plate_x, plate_y, plate_t], center = [true, true, false]);

// 2. Camera hole through plate (extends 1 mm past each face)
cam_hole = translate([cam_hole_x, cam_hole_y, -1])
    cylinder(h = plate_t + 2, d = cam_hole_d, $fn = 64);

// 3. Sleeve outer cylinder (z = 3..31), centred on camera-hole axis
sleeve_outer = translate([cam_hole_x, cam_hole_y, sleeve_z0])
    cylinder(h = sleeve_z1 - sleeve_z0, d = sleeve_od, $fn = 64);

// 4. Sleeve bore: lower (22 mm) and upper (30.6 mm)
//    Each extends 1 mm past the faces it cuts.
bore_lower = translate([cam_hole_x, cam_hole_y, bore1_z0 - 1])
    cylinder(h = (bore1_z1 - bore1_z0) + 2, d = bore1_d, $fn = 64);

bore_upper = translate([cam_hole_x, cam_hole_y, bore2_z0 - 1])
    cylinder(h = (bore2_z1 - bore2_z0) + 2, d = bore2_d, $fn = 64);

// 5. Three radial 2.5 mm holes for M3 centring screws at z = 21
screw_holes = for (a = screw_angles)
    rotate([0, 0, a])
        translate([cam_hole_x, cam_hole_y, screw_hole_z])
            rotate([0, 90, 0])   // point cylinder along +X
                cylinder(h = screw_hole_len, d = screw_hole_d, $fn = 32,
                         center = true);

// ============================
//  ASSEMBLE
// ============================

difference() {
    union() {
        plate;
        sleeve_outer;
    }
    cam_hole;
    bore_lower;
    bore_upper;
    screw_holes;
}