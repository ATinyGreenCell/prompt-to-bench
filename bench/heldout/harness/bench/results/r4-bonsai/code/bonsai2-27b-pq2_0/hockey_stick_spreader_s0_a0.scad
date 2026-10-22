// L-shaped (hockey-stick) cell spreader for plating bacteria
// Printed lying flat on the XY plane, z = 0 is the bed side.

// ---- Named dimensions (mm) ----
handle_len   = 150;   // handle length along +X
handle_w     = 6;     // handle width (Y)
handle_t     = 4;     // handle thickness (Z)

foot_len     = 40;    // spreading foot length
foot_w       = 5;     // foot width
foot_t       = 2.5;   // foot thickness (bed side at z=0)

boss_d       = 6;     // round boss diameter at origin
boss_h       = 4;     // boss height

hole_d       = 4;     // hanging hole diameter
hole_x       = 143;   // hanging hole centre X
hole_y       = 0;     // hanging hole centre Y

foot_angle   = 120;   // foot centre-line angle CCW from +X (deg)

// ---- Print quality ----
$fn = 64;             // high resolution for round holes/boss

// ---- Geometry ----
// Handle: bar from x=0..150, y=-3..3, z=0..4
handle = cube([handle_len, handle_w, handle_t], center=[false, true, false]);

// Foot: 40 mm bar, 5 mm wide, 2.5 mm thick, centred on origin,
// rotated 120 deg CCW about Z.  Its centre line runs from origin outward.
foot = cube([foot_len, foot_w, foot_t], center=[true, true, false]);
foot = rotate([0, 0, foot_angle]) foot;

// Round boss at the origin joining the two bars.
boss = cylinder(d = boss_d, h = boss_h, center=[false, false, false]);

// Hanging hole through the handle at x=143, y=0.
// Cut extends 1 mm past the top/bottom faces to avoid coplanar faces.
hole = cylinder(d = hole_d, h = handle_t + 2, center=[false, false, false]);
hole = translate([hole_x, hole_y, -1]) hole;

// ---- Assemble ----
union() {
    union() {
        handle;
        foot;
        boss;
    }
    difference() {
        // (handled below)
    }
}