// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed, motor plate builds upward (+Z)

// ---------------- Parameters ----------------
base_x0      = -25;    // base plate start in X
base_x1      = 25;     // base plate end in X
base_y0      = 0;      // base plate start in Y
base_y1      = 45;     // base plate end in Y
base_z0      = 0;      // base plate start in Z
base_z1      = 5;      // base plate end in Z

hole_x       = -17;    // M4 hole 1, X position
hole_y       = 30;     // M4 hole 1, Y position
hole_d       = 4.5;    // M4 hole diameter

hole_x2      = 17;     // M4 hole 2, X position

plate_x0     = -25;    // motor plate start in X
plate_x1     = 25;     // motor plate end in X
plate_y0     = 0;      // motor plate start in Y
plate_y1     = 5;      // motor plate end in Y
plate_z0     = 0;      // motor plate start in Z
plate_z1     = 50;     // motor plate end in Z

hole_d2      = 23;     // motor centring boss hole diameter
hole_z2      = 28;     // motor centring boss hole Z position

screw_d      = 3.4;    // M3 screw hole diameter
screw_x      = -15.5;  // M3 screw pattern centre X offset (31 mm square)
screw_y      = -15.5;  // M3 screw pattern centre Y offset

gusset_x0    = -25;    // gusset left edge (X)
gusset_x1    = -20;    // gusset right edge (X)
gusset_y0    = 5;      // gusset leg length in Y (from z = 5)
gusset_z0    = 5;      // gusset leg length in Z (from y = 5)

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);
        translate([hole_x, hole_y, -eps])
            cylinder(d = hole_d, h = base_z1 - base_z0 + 2 * eps);
        translate([hole_x2, hole_y, -eps])
            cylinder(d = hole_d, h = base_z1 - base_z0 + 2 * eps);
    }

    // Vertical motor plate with boss hole and M3 screw holes
    difference() {
        translate([plate_x0, plate_y0, plate_z0])
            cube([plate_x1 - plate_x0, plate_y1 - plate_y0, plate_z1 - plate_z0]);
        translate([screw_x, plate_y0, -eps])
            cube([screw_x + 31, plate_y1, screw_d + 2 * eps]);
        translate([screw_x, plate_y1, -eps])
            cube([screw_x + 31, plate_y0, screw_d + 2 * eps]);
        translate([plate_x0, -eps, hole_z2])
            cube([plate_x1 - plate_x0, screw_d + 2 * eps, plate_z1 - hole_z2 + eps]);
        translate([plate_x0, -eps, hole_z2])
            cube([plate_x1 - plate_x0, screw_d + 2 * eps, hole_z2 - plate_z0 + eps]);
    }

    // Triangular gussets, flush with plate edges
    for (gx = [gusset_x0, gusset_x1])
        translate([gx, gusset_y0, gusset_z0])
            rotate([0, 90, 0])
                linear_extrude(height = 5)
                    polygon([
                        [0, 0],
                        [gusset_y0, 0],
                        [0, gusset_z0]
                    ]);
}