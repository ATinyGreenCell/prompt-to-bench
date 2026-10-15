// Buffer tank for a mini horizontal gel-electrophoresis box. Open top, rectangular shape with a
// central raised platform and two buffer chambers. NOVEL general part.
//

inner_X = 120;
inner_Y = 70;
inner_Z = 40;
wall    = 3;
floor   = 3;
platform  = 60;
height    = 10;

$fn = 32;

difference() {
    cube([inner_X + 2 * wall, inner_Y + 2 * wall, height + wall]);
    translate([wall, wall, wall]) cube([inner_X, inner_Y, height]);
    z = height - height / 2 + wall;                 // platform centre z (top of the lower wall)
    translate([(inner_X - platform) / 2, 0, z]) cube([platform, inner_Y, height / 2]);   // left chamber
    translate([inner_X / 2, 0, z]) cube([platform, inner_Y, height / 2]);                 // right chamber
    for (x = [wall, inner_X - wall])
        translate([x, -1, height + wall * 0.5]) cylinder(h = wall, d = 2, center = true);   // electrode holes
}