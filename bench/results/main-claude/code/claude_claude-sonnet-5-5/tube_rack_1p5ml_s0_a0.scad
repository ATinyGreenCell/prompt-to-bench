// Bench rack for 1.5 mL microcentrifuge tubes

block_x = 106;      // block length (X)
block_y = 72;       // block width (Y)
block_z = 30;       // block height (Z)

cols = 6;           // holes along X
rows = 4;           // holes along Y
pitch = 16;         // centre-to-centre spacing (X and Y)

hole_d = 11.2;      // hole diameter
hole_depth = 25;    // hole depth from top
floor_t = block_z - hole_depth; // solid floor thickness (5 mm)

eps = 0.5;          // cutter overshoot past top face

$fn = 64;

difference() {
    // solid block, centred in X and Y, resting on z = 0
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // hole grid centred on the block
    for (i = [0 : cols - 1])
        for (j = [0 : rows - 1])
            translate([(i - (cols - 1)/2) * pitch,
                       (j - (rows - 1)/2) * pitch,
                       floor_t])
                cylinder(d = hole_d, h = hole_depth + eps);
}