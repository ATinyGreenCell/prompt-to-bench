// Tube rack for six 50 mL conical (Falcon-type) tubes - printed upside down and flipped over.
// A flat plate with a 2x3 hole grid and two solid side walls. The walls become the feet when
// flipped; the short ends stay open. NOVEL general part.
//

cols   = 3;
rows   = 2;
tube_d = 30.5;
pitch_x = 40;
pitch_y = 40;
plate_w = 130;
plate_l = 90;
plate_t = 4;
wall_h = 70;

$fn = 48;

plate_tol = 0.5;
wall_tol  = 0.5;

difference() {
    union() {
        translate([-plate_w / 2, -plate_l / 2, 0]) cube([plate_w, plate_l, plate_t]);
        for (x = [-plate_w / 2 : pitch_x : plate_w / 2])
            for (y = [-plate_l / 2 : pitch_y : plate_l / 2])
                translate([x, y, -1]) cylinder(h = plate_t + 2, d = tube_d);
        for (x = [-plate_w / 2 : pitch_x : plate_w / 2])
            translate([x, -plate_l / 2 - 1, 0]) cube([pitch_x, plate_l, wall_h]);
        translate([-plate_w / 2, plate_l / 2, 0]) cube([plate_w, plate_l, wall_h]);
    }
    translate([-plate_w / 2, -plate_l / 2, plate_t]) cube([plate_w, plate_l, wall_h]);
}