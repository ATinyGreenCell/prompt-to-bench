// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
$fn = 64;

// Base plate
base_x0 = -25;      // base plate X start
base_x1 = 25;       // base plate X end
base_y0 = 0;        // base plate Y start
base_y1 = 45;       // base plate Y end
base_z0 = 0;        // base plate Z start
base_z1 = 5;        // base plate Z end
hole_m4_x = -17;    // M4 through-hole X position (left)
hole_m4_y = 30;     // M4 through-hole Y position
hole_m4_r = 2.25;   // M4 hole radius

// Vertical motor plate
motor_x0 = -25;     // motor plate X start
motor_x1 = 25;      // motor plate X end
motor_y0 = 0;       // motor plate Y start
motor_y1 = 5;       // motor plate Y end (sits on back edge of base)
motor_z0 = 0;       // motor plate Z start
motor_z1 = 50;      // motor plate Z end

// Boss hole (motor centring boss)
boss_r = 11.5;      // boss hole radius (23 mm diameter)
boss_x = 0;         // boss hole X centre
boss_z = 28;        // boss hole Z centre

// Screw holes for boss
screw_r = 1.7;      // M3 screw hole radius (3.4 mm diameter)
screw_n = 4;        // number of screw holes
screw_p = 31;       // square pattern side length
screw_a = 90;       // screw hole rotation angle (degrees)

// Gussets
gusset_t = 5;       // gusset thickness (along X)
gusset_w = 20;      // gusset leg length along +Y
gusset_h = 20;      // gusset leg length along +Z
gusset_x0 = -25;    // left gusset X start
gusset_x1 = -20;    // left gusset X end
// right gusset runs from x = 20 to x = 25

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([base_x0, base_y0, base_z0])
            cube([base_x1 - base_x0, base_y1 - base_y0, base_z1 - base_z0]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -1])
                cylinder(r = hole_m4_r, h = base_z1 + 2);
    }

    // Vertical motor plate with boss hole and screw holes
    difference() {
        translate([motor_x0, motor_y0, motor_z0])
            cube([motor_x1 - motor_x0, motor_y1 - motor_y0, motor_z1 - motor_z0]);
        // Boss hole along Y, extending past top and bottom faces
        translate([boss_x, -1, boss_z])
            rotate([0, 90, 0])
                cylinder(r = boss_r, h = motor_y1 - motor_y0 + 2);
        // Screw holes on square pattern, centred on boss hole
        for (i = [0 : screw_n - 1]) {
            a = screw_a * i / (screw_n - 1);
            translate([boss_x + (screw_p / 2) * cos(a),
                       boss_z + (screw_p / 2) * sin(a),
                       -1])
                cylinder(r = screw_r, h = motor_z1 + 2);
        }
    }

    // Triangular gussets, flush with left and right edges
    for (gx = [gusset_x0, 20]) {
        translate([gx, gusset_w, gusset_h])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, 0],
                        [gusset_w, 0],
                        [gusset_w, gusset_h]
                    ]);
    }
}