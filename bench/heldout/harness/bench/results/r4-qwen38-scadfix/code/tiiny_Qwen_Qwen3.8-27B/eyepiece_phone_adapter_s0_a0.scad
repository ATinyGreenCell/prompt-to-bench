// Adapter: phone camera over microscope eyepiece (30 mm OD), printed phone-side down
// All dimensions in mm, measured with calipers.

// ---- Plate ----
plate_x = 80;   // plate length in X
plate_y = 60;   // plate width in Y
plate_t = 3;    // plate thickness (z = 0..3)
cam_hole_d = 12;    // camera through-hole diameter
cam_hole_x = -20;   // camera hole centre X
cam_hole_y = 10;    // camera hole centre Y

// ---- Sleeve (on camera-hole axis) ----
sleeve_od = 36.6;   // sleeve outer diameter
sleeve_z0 = 3;      // sleeve base (sits on plate top)
sleeve_z1 = 31;     // sleeve top (open)
bore1_d = 22;       // lower bore (camera stop) diameter
bore1_z0 = 3;       // lower bore start
bore1_z1 = 11;      // lower bore end
bore2_d = 30.6;     // upper bore (slides over 30 mm eyepiece) diameter
bore2_z0 = 11;      // upper bore start
bore2_z1 = 31;      // upper bore end (open top)

// ---- M3 centring screw holes ----
screw_hole_d = 2.5;   // radial hole diameter
screw_z = 21;         // hole axis height
screw_n = 3;          // number of radial holes
screw_start = 0;      // first hole points +X

$fn = 64;

// ===================== BODY =====================
module body() { union() {
    // Flat plate on the bed, centred on origin
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Round sleeve standing on the plate, on the camera-hole axis
    translate([cam_hole_x, cam_hole_y, 0])
        cylinder(h = sleeve_z1, d = sleeve_od, center = false);
} }

// ===================== CUTS =====================
module cuts() { union() {
    // Camera through-hole in the plate (extends 1 mm past each face)
    translate([cam_hole_x, cam_hole_y, -1])
        cylinder(h = plate_t + 2, d = cam_hole_d, center = false);

    // Lower bore (camera stop) - extends 1 mm below plate and 0.5 mm into upper bore
    translate([cam_hole_x, cam_hole_y, bore1_z0 - 1])
        cylinder(h = (bore1_z1 - bore1_z0) + 1.5, d = bore1_d, center = false);

    // Upper bore (slides over eyepiece) - extends 1 mm past open top
    translate([cam_hole_x, cam_hole_y, bore2_z0])
        cylinder(h = (bore2_z1 - bore2_z0) + 1, d = bore2_d, center = false);

    // Three radial 2.5 mm M3 centring-screw holes, 120 deg apart, first in +X
    for (i = [0 : screw_n - 1]) {
        a = screw_start + i * 360 / screw_n;
        // Cylinder axis along local X, rotated about Z by a, centred on sleeve axis
        translate([cam_hole_x, cam_hole_y, screw_z])
        rotate([0, 0, a])
        // Extend 1 mm past the sleeve outer wall on each side
        cylinder(h = sleeve_od + 2, d = screw_hole_d, center = true);
    }
} }

// ===================== FINAL PART =====================
difference() {
    body();
    cuts();
}