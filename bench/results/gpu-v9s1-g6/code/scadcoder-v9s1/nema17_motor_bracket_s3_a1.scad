// L-shaped mounting bracket for a NEMA 17 stepper motor
// Print orientation: base plate on the bed (z = 0), vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
$fn = 64;               // curve resolution

// ---- Base plate ----
base_x0 = -25;          // plate left edge (X)
base_x1 = 25;           // plate right edge (X)
base_y0 = 0;            // plate front edge (Y)
base_y1 = 45;           // plate back edge (Y)
base_z0 = 0;            // plate bottom face (Z)
base_z1 = 5;            // plate top face (Z)
mount_hole_d = 4.5;     // M4 mounting hole diameter
mount_hole_x = -17;     // mounting hole X position
mount_hole_y = 30;      // mounting hole Y position

// ---- Vertical motor plate ----
motor_plate_x0 = -25;   // plate left edge (X)
motor_plate_x1 = 25;    // plate right edge (X)
motor_plate_y0 = 0;     // plate front edge (Y)
motor_plate_y1 = 5;     // plate back edge (Y) (sits on base back edge)
motor_plate_z0 = 0;     // plate bottom face (Z)
motor_plate_z1 = 50;    // plate top face (Z)

// ---- Motor boss hole ----
boss_hole_d = 23;       // hole diameter for motor centring boss
boss_hole_x = 0;        // hole centre X
boss_hole_z = 28;       // hole centre Z

// ---- M3 screw holes (square pattern around boss hole) ----
screw_d = 3.4;          // M3 screw hole diameter
screw_count = 4;        // number of screw holes
screw_pattern_size = 31; // square side length (centre to centre)

// ---- Gussets ----
gusset_thickness = 5;   // gusset thickness along X
gusset_leg_y = 20;      // right-triangle leg along +Y
gusset_leg_z = 20;      // right-triangle leg along +Z
gusset_hole_d = 3.4;    // through-hole diameter in gussets (M3)

// ---- Cutting overlap ----
eps = 0.5;              // extension of cutters past faces

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate with mounting holes
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);
        for (sx = [-1, 1])
            translate([sx * mount_hole_x, mount_hole_y, base_z0 - eps])
                cylinder(d = mount_hole_d, h = base_z1 + 2 * eps);

        // Vertical motor plate
        translate([motor_plate_x0, motor_plate_y0, motor_plate_z0])
            cube([motor_plate_x1 - motor_plate_x0,
                  motor_plate_y1 - motor_plate_y0,
                  motor_plate_z1 - motor_plate_z0]);

        // Motor boss hole (along Y, through the plate)
        translate([boss_hole_x, motor_plate_y1 + eps, boss_hole_z])
            rotate([90, 0, 0])
                cylinder(d = boss_hole_d, h = motor_plate_y1 + 2 * eps);

        // M3 screw holes on square pattern, centred on boss hole
        for (i = [0 : screw_count - 1]) {
            angle = i * 360 / screw_count;
            translate([boss_hole_x,
                       motor_plate_y0 - screw_pattern_size / 2,
                       boss_hole_z])
                rotate([0, 90, angle])
                    cylinder(d = screw_d, h = screw_pattern_size);
        }

        // Triangular gussets, flush with left and right edges
        for (gx = [motor_plate_x0, motor_plate_x1 - gusset_thickness])
            translate([gx, 0, 0])
                linear_extrude(height = gusset_thickness)
                    polygon(points = [
                        [0, 0],
                        [gusset_leg_y, 0],
                        [0, gusset_leg_z]
                    ]);
    }
}