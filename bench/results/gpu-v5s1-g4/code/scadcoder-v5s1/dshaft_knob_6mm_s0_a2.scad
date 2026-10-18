// Hotplate stirrer knob - D-shaft knob with grip grooves and a pointer groove, printed
// with the D-flat side facing the hotplate (down). NOVEL general part.
//

od     = 30;
h      = 15;
bore_d = 6.2;
flatt  = 4.7;
grooves = 18;
g_d    = 2;
pg_w   = 1.5;
pg_d   = 1;

$fn = 96;

difference() {
    // Main knob body. Centre the cylinder on the origin in X and Y; put the bottom face
    // on the bed at z = 0.
    cylinder(d = od, h = h);

    // D-shaped blind bore from the bottom face.  A circle of diameter bore_d, with one
    // side cut flat so the distance from the flat to the opposite side of the circle is
    // flatt.  The bore stops 12 mm short of the top face.
    bore_depth = h - 12;
    translate([0, 0, -1])
        cylinder(d = bore_d, h = h - bore_depth + 2, $fn = 64);

    // Grip grooves around the outside.  Each is a half-cylinder of diameter g_d, centred
    // on the outer surface, running the full height.
    for (i = [0 : grooves - 1])
        rotate([0, 0, i * 360 / grooves])
            translate([od / 2, 0, -1])
                cylinder(d = g_d, h = h + 2);

    // Pointer groove on the top face, on the same side as the flat of the D.  It is a
    // rectangular groove of width pg_w and depth pg_d, running from the centre to the
    // outer edge.
    translate([od / 2, 0, h - pg_d])
        cube([od / 2 + 1, pg_w, pg_d + 2]);
}