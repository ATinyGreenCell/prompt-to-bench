// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
open_top_z   = 40;    // height of open top
outer_size   = 90;    // outer X/Y size of box
screw_hole   = 4.5;   // M4 screw hole diameter
screw_pitch  = 71.5;  // square pattern size for screw holes
cable_notch_w = 12;   // cable notch width
cable_notch_d = 8;    // cable notch depth from open edge
eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Main box body
    union() {
        // Top plate
        translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, plate_t]);
        // Walls
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([outer_size/2 - wall_t, -outer_size/2, plate_t])
                    cube([wall_t, outer_size, open_top_z - plate_t]);
    }

    // Screw holes through top plate
    for (x = [-screw_pitch/2, screw_pitch/2])
        for (y = [-screw_pitch/2, screw_pitch/2])
            translate([x, y, -eps])
                cylinder(d = screw_hole, h = plate_t + 2*eps);

    // Cable notch in one wall (centred along Y, from z = 32 to z = 40)
    translate([-outer_size/2, -cable_notch_w/2, open_top_z - cable_notch_d])
        cube([outer_size, cable_notch_w, cable_notch_d + eps]);
}