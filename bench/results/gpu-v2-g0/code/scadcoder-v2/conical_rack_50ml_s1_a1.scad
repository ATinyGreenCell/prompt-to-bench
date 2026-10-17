// Tube rack for six 50 mL conical (Falcon-type) tubes - printed upside down and flipped over.
// A flat plate with a 2x3 hole grid and two solid walls runs along the long edges. The two
// short ends stay open. After flipping, the rack stands on the walls and the tubes pass
// through the holes.
//

plate_x = 130;
plate_y = 90;
plate_z = 4;
wall_h  = 70;
hole_d  = 30.5;
row_p   = 40;
col_p   = 40;

$fn = 48;

wall_t = 4;

difference() {
    union() {
        translate([-plate_x / 2, -plate_y / 2, 0]) cube([plate_x, plate_y, plate_z]);
        translate([-plate_x / 2, -plate_y / 2, 0]) cube([plate_x, wall_t, wall_h]);      // left wall
        translate([-plate_x / 2, plate_y - wall_t, 0]) cube([plate_x, wall_t, wall_h]);  // right wall
    }
    for (i = [0 : 1], j = [0 : 2])
        translate([col_p * j - row_p / 2, row_p * i - col_p / 2, -1])
            cylinder(h = plate_z + 2, d = hole_d);
}