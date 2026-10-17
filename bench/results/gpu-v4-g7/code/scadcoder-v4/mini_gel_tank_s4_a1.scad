// Mini horizontal gel-electrophoresis box - buffer tank
// Print orientation: tank rests on XY plane at z = 0, builds upward (+Z)

// ---------------- Parameters ----------------
tank_x      = 120;   // outer length along X (mm)
tank_y      = 70;    // outer width along Y (mm)
tank_h      = 40;    // outer height along Z (mm)
wall        = 3;     // wall thickness (mm)
floor       = 3;     // floor thickness (mm)

platform_x  = 60;    // platform length along X (mm), centred
platform_y  = tank_y - 2 * wall;  // platform spans full inner width (mm)
platform_top = 10;   // platform top height above inner floor (mm) -> z = floor + platform_top

hole_d      = 2;     // electrode hole diameter (mm)
hole_y      = 0;     // electrode hole Y position (mm)
hole_z      = 30;    // electrode hole Z position (mm)

eps         = 0.5;   // cutter overshoot past faces (mm)
$fn         = 96;    // curve resolution

// ---------------- Derived ----------------
inner_floor_z = floor;
platform_z    = inner_floor_z + platform_top;
chamber_h     = hole_z - platform_z;   // height of buffer chambers above platform

// ---------------- Model ----------------
difference() {
    // Tank body: outer block with floor and walls, open top
    translate([-tank_x/2, -tank_y/2, 0])
        cube([tank_x, tank_y, tank_h]);

    // Cut out the two end buffer chambers above the platform
    for (sx = [-1, 1]) {
        translate([sx > 0 ? tank_x/2 - platform_x : -tank_x/2, -platform_y/2, platform_z])
            cube([platform_x, platform_y, chamber_h + eps]);
    }

    // Horizontal electrode holes through each end wall, along X
    for (sx = [-1, 1]) {
        translate([sx * (tank_x/2 - hole_d/2 - eps), hole_y, hole_z])
            rotate([0, 90, 0])
                cylinder(d = hole_d, h = tank_x + 2*eps);
    }
}