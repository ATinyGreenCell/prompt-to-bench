// Adapter: phone camera over microscope eyepiece (30 mm OD), printed phone-side down.
// All dimensions in mm, measured with calipers.

$fn = 64;

// ---- Plate (rests on bed, z = 0..3, centred on origin) ----
plate_x = 80;   // plate length in X
plate_y = 60;   // plate width  in Y
plate_t = 3;    // plate thickness
cam_hole_d = 12;   // camera through-hole diameter
cam_hole_x = -20;  // camera hole centre X
cam_hole_y =  10;  // camera hole centre Y

// ---- Sleeve (round, on camera-hole axis, z = 3..31) ----
sleeve_od  = 36.6;  // sleeve outer diameter
sleeve_z0  = 3;     // sleeve base (top of plate)
sleeve_z1  = 31;    // sleeve top (open)
bore_stop_d  = 22;   // bore diameter in stop section (sets eyepiece distance)
bore_stop_z1 = 11;   // stop section ends here
bore_slide_d = 30.6; // bore diameter in sliding section (over 30 mm eyepiece)

// ---- M3 centring screw holes (radial, through sleeve wall) ----
screw_hole_d = 2.5;  // hole diameter for M3 screws
screw_z      = 21;   // hole axis height
screw_n      = 3;    // number of radial holes
screw_ang0   = 0;    // first hole points +X

// ============================ BODY ============================
module body() { union() {
    // Flat plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Sleeve: outer cylinder minus two bore sections
    difference() {
        translate([cam_hole_x, cam_hole_y, 0])
            cylinder(h = sleeve_z1, d = sleeve_od);

        // Stop bore (z = 3..11)
        translate([cam_hole_x, cam_hole_y, sleeve_z0])
            cylinder(h = bore_stop_z1 - sleeve_z0, d = bore_stop_d);

        // Slide bore (z = 11..31, open top)
        translate([cam_hole_x, cam_hole_y, bore_stop_z1])
            cylinder(h = sleeve_z1 - bore_stop_z1, d = bore_slide_d);
    }
} }

// ============================ CUTS ============================
// Camera through-hole in plate (extends 1 mm past each face)
module cam_cut() { translate([cam_hole_x, cam_hole_y, -1])
    cylinder(h = plate_t + 2, d = cam_hole_d); }

// Radial M3 centring-screw holes through sleeve wall
screw_cuts = [for (i = [0 : screw_n - 1])
    let (ang = screw_ang0 + i * 360 / screw_n)
        rotate([0, 0, ang])
            translate([cam_hole_x, cam_hole_y, screw_z])
                rotate([0, 90, 0])
                    cylinder(h = sleeve_od + 2, d = screw_hole_d)];

// ============================ FINAL PART ============================
difference() {
    body();
    cam_cut();
    screw_cuts;
}