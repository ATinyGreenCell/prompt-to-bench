// Stand rod tube clip - an open ring that snaps onto a round stand rod (e.g. 12.7 mm / 1/2 inch)
// with a separate ring for a small tube, joined by a bridge. NOVEL part.
//

rod_d  = 12.7;
wall_r = 3;
tube_d = 6;
t     = 2;
bridge_w = 6;
height = 10;

$fn = 96;

inner_r = rod_d / 2;
outer_r = inner_r + wall_r;
tube_r  = tube_d / 2;

difference() {
    union() {
        cylinder(h = height, r = outer_r);                 // rod ring
        translate([15, 0, 0]) cylinder(h = height, r = tube_r + wall_r);   // tubing ring
        translate([7, -3, 0]) cube([bridge_w, 6, height]);                      // bridge
    }
    translate([0, -6, -1]) cylinder(h = height + 2, r = inner_r);                     // rod hole
    translate([15, 0, 0]) translate([15, -2.25, -1]) cube([1, 4.5, height + 2]);     // tube opening
}