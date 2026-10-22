// Float for seven 15 mL conical tubes (printed upside down)

$fn = 64;

plate_flats   = 90;    // plate width across flats (mm)
plate_t       = 3;     // plate thickness (mm)
total_h       = 20;    // overall height of sleeves and skirt (mm)
hole_d        = 17.5;  // tube hole diameter (mm)
sleeve_wall   = 2;     // sleeve wall thickness (mm)
sleeve_od     = hole_d + 2*sleeve_wall; // 21.5 mm
ring_pcd      = 54;    // pitch circle diameter of outer holes (mm)
n_outer       = 6;     // number of outer holes
skirt_flats   = 84;    // skirt outside width across flats (mm)
skirt_wall    = 2;     // skirt wall thickness (mm)
eps           = 0.5;   // cutter overshoot (mm)

// circumradius from across-flats distance (cylinder $fn=6 has a vertex on +X, flats parallel to X)
function circR(af) = af / 2 / cos(30);

module hex(af, h) {
    cylinder(r = circR(af), h = h, $fn = 6);
}

module hole_positions() {
    translate([0, 0, 0]) children();
    for (i = [0 : n_outer - 1])
        rotate([0, 0, i * 360 / n_outer])
            translate([ring_pcd / 2, 0, 0]) children();
}

difference() {
    union() {
        // base plate
        hex(plate_flats, plate_t);

        // sleeves
        hole_positions()
            cylinder(d = sleeve_od, h = total_h, $fn = 64);

        // skirt (hex ring)
        difference() {
            hex(skirt_flats, total_h);
            translate([0, 0, -eps])
                hex(skirt_flats - 2*skirt_wall, total_h + 2*eps);
        }
    }

    // tube through-holes
    hole_positions()
        translate([0, 0, -eps])
            cylinder(d = hole_d, h = total_h + 2*eps, $fn = 64);
}