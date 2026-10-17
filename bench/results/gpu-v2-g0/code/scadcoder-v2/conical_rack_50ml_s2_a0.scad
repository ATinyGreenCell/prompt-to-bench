// Tube rack for six 50 mL conical (Falcon-type) tubes - printed upside down and flipped over.
// A flat plate with a 2x3 hole grid and two solid walls runs along the long edges. The two
// short ends are open. The walls and plate form a U-shaped channel that holds the rack upright
// when flipped. NOVEL general part.
//

plate_L = 130;
plate_W = 90;
plate_t = 4;
hole_d  = 30.5;
row_p   = 40;
col_p   = 40;
wall_h  = 70;

$fn = 48;

plate_z = 4;
wall_t  = 4;

difference() {
    union() {
        translate([-plate_L / 2, -plate_W / 2, 0]) cube([plate_L, plate_W, plate_z]);
        for (y = [-plate_W / 2, plate_W / 2])
            translate([-plate_L / 2, y, 0]) cube([plate_L, wall_t, wall_h]);
    }
    for (i = [0, 1], j = [0, 1, 2])
        translate([col_p * j - 15.25, row_p * i - 15.25, -1]) cylinder(h = plate_z + 2, d = hole_d);
}