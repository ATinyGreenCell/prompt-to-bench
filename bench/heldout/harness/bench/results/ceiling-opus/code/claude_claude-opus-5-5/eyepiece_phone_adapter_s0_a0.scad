// Phone-to-microscope eyepiece adapter (printed phone side down)
// Units: mm

$fn = 96;

// ---- Base plate ----
plate_x      = 80;    // plate length (X)
plate_y      = 60;    // plate width (Y)
plate_t      = 3;     // plate thickness (z = 0..3)

// ---- Camera hole / sleeve axis ----
cam_x        = -20;   // camera hole axis X
cam_y        = 10;    // camera hole axis Y
cam_d        = 12;    // camera hole diameter

// ---- Sleeve ----
sleeve_od    = 36.6;  // sleeve outer diameter
sleeve_z0    = 3;     // sleeve bottom (top of plate)
sleeve_z1    = 31;    // sleeve top
stop_d       = 22;    // stop bore diameter (z = 3..11)
stop_z1      = 11;    // top of stop section
bore_d       = 30.6;  // eyepiece bore diameter (z = 11..31)

// ---- Centring screw holes ----
screw_d      = 2.5;   // M3 tap/self-tap hole diameter
screw_z      = 21;    // height of screw holes
screw_n      = 3;     // number of screws
screw_a0     = 0;     // first hole angle (+X direction)

eps          = 0.5;   // cutter overshoot

difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Sleeve outer body
        translate([cam_x, cam_y, sleeve_z0])
            cylinder(d = sleeve_od, h = sleeve_z1 - sleeve_z0);
    }

    // Camera hole through the plate
    translate([cam_x, cam_y, -eps])
        cylinder(d = cam_d, h = plate_t + 2*eps);

    // Stop bore (z = 3..11)
    translate([cam_x, cam_y, sleeve_z0])
        cylinder(d = stop_d, h = stop_z1 - sleeve_z0 + eps);

    // Eyepiece bore (z = 11..top, open)
    translate([cam_x, cam_y, stop_z1])
        cylinder(d = bore_d, h = sleeve_z1 - stop_z1 + eps);

    // Radial centring-screw holes through the sleeve wall
    for (i = [0 : screw_n - 1])
        translate([cam_x, cam_y, screw_z])
            rotate([0, 0, screw_a0 + i * 360 / screw_n])
                translate([bore_d/2 - 1, 0, 0])
                    rotate([0, 90, 0])
                        cylinder(d = screw_d, h = (sleeve_od - bore_d)/2 + 2, $fn = 48);
}