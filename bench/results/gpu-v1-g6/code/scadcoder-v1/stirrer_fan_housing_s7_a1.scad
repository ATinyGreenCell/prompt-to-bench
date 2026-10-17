// Fan box - a top plate and four walls, open at the top, to house a PC case fan as a
// magnetic stirrer. NOVEL general part.
//

top     = 90;
length  = 90;
height  = 40;
wall    = 2.5;
screw   = 4.5;
cable   = 12;

$fn = 48;

plate_t = 2;

difference() {
    union() {
        cube([top, length, plate_t]);
        for (x = [-(length / 2 - wall / 2), length / 2 - wall / 2])
            cube([wall, length, height], p = [x, 0, 0]);
        for (y = [-(top / 2 - wall / 2), top / 2 - wall / 2])
            cube([length, wall, height], p = [0, y, 0]);
    }
    translate([0, 0, -1]) cube([top, length, plate_t + 2]);                 // clear the top surface
    for (x = [-71.5 / 2, 71.5 / 2], y = [-71.5 / 2, 71.5 / 2])
        translate([x, y, -1]) cylinder(h = plate_t + 2, d = screw);           // screw holes
    // one cable notch in a wall, reaching 8 mm down from the open edge (z = height - 8)
    translate([-(length / 2 - wall / 2), 0, height - 8])
        cube([wall, cable, 8]);
}