// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising above it.
// After printing, flip the part so the walls stand on the bed
// and the tube holes face upward.

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing X and Y (mm)

wall_h       = 70;    // wall height from top of plate (mm)
wall_t       = 4;     // wall thickness along Y (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// Derived
total_h      = plate_t + wall_h;   // max Z of walls
x0           = -(hole_nx - 1) * hole_pitch / 2;  // first hole X
y0           = -(hole_ny - 1) * hole_pitch / 2;  // first hole Y

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x / 2, -plate_y / 2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges, flush with the plate
        for (s = [-1, 1])
            translate([s * (plate_x / 2 - wall_t), -plate_y / 2, 0])
                cube([wall_t, plate_y, total_h]);
    }

    // Tube holes through the plate and walls
    for (i = 0; i < hole_nx * hole_ny; i++)
        translate([x0 + i % hole_nx * hole_pitch,
                   y0 + i / hole_nx * hole_pitch,
                   -eps])
            cylinder(d = hole_d, h = total_h + 2 * eps);
}