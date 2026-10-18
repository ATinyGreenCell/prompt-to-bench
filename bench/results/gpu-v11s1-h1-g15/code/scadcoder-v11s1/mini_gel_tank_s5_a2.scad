// Mini horizontal gel-electrophoresis box: open-top rectangular tank with a central raised
// gel-tray platform that divides the bottom into two buffer chambers. Each end wall has a
// horizontal 2 mm hole along X at y = 0, z = 30 for the electrode wires.
//
// Print orientation: tank standing on its floor, open top facing up (+Z)

$fn = 64;

// ---------------- Dimensions (mm) ----------------
outer_x      = 120;   // tank outer length (X)
outer_y      = 70;    // tank outer width (Y)
outer_h      = 40;    // tank outer height (Z)

wall         = 3;     // tank wall thickness
floor        = 3;     // tank floor thickness

platform_x   = 60;    // platform length (X), centred
platform_top = 10;    // platform height above inner floor (Z) -> z = 13

hole_d       = 2;     // electrode hole diameter
hole_y       = 0;     // electrode hole Y position
hole_z       = 30;    // electrode hole Z position

eps          = 0.5;   // overshoot for clean boolean cuts

inner_h = outer_h - wall - floor;   // inner cavity height (34)

// ---------------- Model ----------------
union() {
    // Tank body: outer block with hollowed cavity (open top)
    difference() {
        cube([outer_x, outer_y, outer_h]);
        translate([wall, wall, floor])
            cube([inner_x = outer_x - 2 * wall,
                  inner_y = outer_y - 2 * wall,
                  inner_h + eps]);    // cavity extends past the top opening
    }

    // Central raised platform for the gel tray
    translate([-platform_x / 2, -outer_y / 2, platform_top])
        cube([platform_x, outer_y, wall]);    // top at z = 13

    // Horizontal electrode holes through each end wall, along X
    for (sx = [-1, 1])
        translate([sx * (outer_x / 2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = wall + 2 * eps);
}