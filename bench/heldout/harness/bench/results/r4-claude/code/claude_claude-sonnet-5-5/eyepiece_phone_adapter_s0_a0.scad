// Microscope eyepiece phone-camera adapter (printed phone side down)

$fn = 64;

// Plate
plate_x = 80;          // plate size X
plate_y = 60;          // plate size Y
plate_t = 3;           // plate thickness

// Camera hole / sleeve axis position
axis_x = -20;          // X of camera-hole axis
axis_y = 10;           // Y of camera-hole axis
cam_d = 12;            // camera hole diameter

// Sleeve
sleeve_od = 36.6;      // sleeve outer diameter
sleeve_top = 31;       // sleeve top z
stop_d = 22;           // lower bore diameter (eyepiece stop)
stop_top = 11;         // z where lower bore ends
bore_d = 30.6;         // upper bore diameter (eyepiece fit)

// Centring screw holes
screw_d = 2.5;         // radial hole diameter
screw_z = 21;          // hole height
screw_n = 3;           // number of holes
screw_start = 0;       // first hole angle (+X)
screw_len = 25;        // cutter length measured from axis

eps = 0.01;

difference() {
    union() {
        // base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);
        // sleeve
        translate([axis_x, axis_y, plate_t])
            cylinder(d = sleeve_od, h = sleeve_top - plate_t);
    }

    // camera hole through plate
    translate([axis_x, axis_y, -1])
        cylinder(d = cam_d, h = plate_t + 2);

    // lower bore (stop)
    translate([axis_x, axis_y, plate_t - eps])
        cylinder(d = stop_d, h = stop_top - plate_t + eps);

    // upper bore
    translate([axis_x, axis_y, stop_top])
        cylinder(d = bore_d, h = sleeve_top - stop_top + 1);

    // radial screw holes
    for (i = [0 : screw_n - 1])
        translate([axis_x, axis_y, screw_z])
            rotate([0, 0, screw_start + i * 360 / screw_n])
                rotate([0, 90, 0])
                    cylinder(d = screw_d, h = screw_len);
}