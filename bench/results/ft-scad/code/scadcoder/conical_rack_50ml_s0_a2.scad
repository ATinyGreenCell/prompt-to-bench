// Lab tube rack - a flat plate with through-bore holes for lab tubes, flanked by open-ended
// walls that support it. NOVEL general part.
//

tube  = 50;
bore  = 30.5;
rows  = 2;
cols  = 3;
pitch = 40;
L     = 130;
W     = 90;
t     = 4;

$fn = 48;

difference() {
    union() {
        cube([L, W, t]);                                              // flat plate
        for (i = [0 : rows - 1])
            translate([0, i * pitch - pitch * 0.5 + W * 0.3, 0])
                rotate([-90, 0, 0])
                    linear_extrude(t + 2) circle(bore / 2);           // through-bore holes
        for (j = [0 : cols - 1])
            translate([L * 0.3 - bore / 2, 0, 0])
                rotate([0, j * pitch - pitch * 0.5 + L * 0.3, 0])
                    linear_extrude(t + 2) circle(bore / 2);
    }
    for (i = [0 : rows - 1])
        translate([0, i * pitch - pitch * 0.5 + W * 0.3, t])
            rotate([-90, 0, 0]) cylinder(h = t + 66, d = L);       // side walls
}