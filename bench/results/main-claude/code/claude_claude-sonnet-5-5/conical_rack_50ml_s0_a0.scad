// Rack for six 50 mL conical tubes (print orientation, upside down)

$fn = 64;

plate_x = 130;      // plate length (X)
plate_y = 90;       // plate width (Y)
plate_t = 4;        // plate thickness (Z)

hole_d = 30.5;      // tube hole diameter
hole_pitch = 40;    // centre-to-centre spacing in X and Y
n_x = 3;            // holes along X
n_y = 2;            // holes along Y

wall_len = 130;     // wall length (X)
wall_t = 4;         // wall thickness (Y)
wall_h = 70;        // wall top height (Z)

cut_ext = 0.5;      // cutter overshoot

difference() {
    union() {
        // base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);
        // two long walls, flush with long edges
        for (s = [-1, 1])
            translate([-wall_len/2, s > 0 ? plate_y/2 - wall_t : -plate_y/2, 0])
                cube([wall_len, wall_t, wall_h]);
    }
    // tube holes
    for (i = [0 : n_x - 1])
        for (j = [0 : n_y - 1])
            translate([(i - (n_x - 1)/2) * hole_pitch,
                       (j - (n_y - 1)/2) * hole_pitch,
                       -cut_ext])
                cylinder(d = hole_d, h = plate_t + 2*cut_ext);
}