// Buffer tank for a mini horizontal gel-electrophoresis box. Open-top rectangular tank with a
// solid raised platform for the gel tray that divides the bottom into two buffer chambers. Each
// end wall gets a horizontal 2 mm hole along X at y = 0, z = 30 for the electrode wires.
//

X  = 120;
Y  = 70;
Z  = 40;
w  = 3;
fl = 3;
pl = 60;
ph = 10;

$fn = 64;

inner_X = X - 2 * w;
inner_Z = Z - fl;

difference() {
    cube([X, Y, Z]);
    translate([w, 0, fl]) cube([inner_X, Y, inner_Z]);     // hollow, open top
    translate([w, w, 0]) cube([inner_X, Y, fl]);           // floor only (no walls up)
    translate([w, w, fl]) cube([pl, Y, ph]);               // gel platform (spans width Y)
    for (x = [-X / 2, X / 2])
        translate([x, w, 0]) rotate([-90, 0, 0])
            cylinder(h = Y + 1, d = 2);                     // electrode holes through end walls
}