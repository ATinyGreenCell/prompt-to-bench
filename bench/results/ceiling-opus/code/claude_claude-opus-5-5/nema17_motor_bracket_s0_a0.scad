// NEMA 17 L-shaped mounting bracket (e.g. for syringe pump)
// Print orientation: base plate on the bed (z = 0), motor plate standing at back edge.

$fn = 64;

// ---------------- Base plate ----------------
base_x_min   = -25;   // left edge of base [mm]
base_x_max   =  25;   // right edge of base [mm]
base_y_min   =   0;   // back edge of base [mm]
base_y_max   =  45;   // front edge of base [mm]
base_t       =   5;   // base plate thickness (z) [mm]

base_hole_d  = 4.5;   // M4 clearance hole diameter [mm]
base_hole_x  =  17;   // |x| of base mounting holes [mm]
base_hole_y  =  30;   // y of base mounting holes [mm]

// ---------------- Motor plate ----------------
mp_y_min     =   0;   // back face of motor plate [mm]
mp_t         =   5;   // motor plate thickness (y) [mm]
mp_h         =  50;   // motor plate height (z) [mm]

boss_d       =  23;   // NEMA 17 centring boss hole diameter [mm]
boss_x       =   0;   // boss centre x [mm]
boss_z       =  28;   // boss centre z [mm]

screw_d      = 3.4;   // M3 clearance hole diameter [mm]
screw_pitch  =  31;   // NEMA 17 square hole pattern [mm]

// ---------------- Gussets ----------------
gusset_t     =   5;   // gusset thickness (x) [mm]
gusset_leg   =  20;   // gusset leg length along +Y and +Z [mm]
gusset_y0    =   5;   // right-angle corner y [mm]
gusset_z0    =   5;   // right-angle corner z [mm]

eps          = 0.5;   // cutter overshoot [mm]

base_w = base_x_max - base_x_min;

// ---------------- Modules ----------------
module base_plate() {
    difference() {
        translate([base_x_min, base_y_min, 0])
            cube([base_w, base_y_max - base_y_min, base_t]);
        for (sx = [-1, 1])
            translate([sx * base_hole_x, base_hole_y, -eps])
                cylinder(d = base_hole_d, h = base_t + 2 * eps);
    }
}

// cylinder cutter running along +Y through the motor plate
module y_hole(x, z, d) {
    translate([x, mp_y_min - eps, z])
        rotate([-90, 0, 0])
            cylinder(d = d, h = mp_t + 2 * eps);
}

module motor_plate() {
    difference() {
        translate([base_x_min, mp_y_min, 0])
            cube([base_w, mp_t, mp_h]);
        // centring boss hole
        y_hole(boss_x, boss_z, boss_d);
        // M3 screw holes on square pattern
        for (sx = [-1, 1], sz = [-1, 1])
            y_hole(boss_x + sx * screw_pitch / 2,
                   boss_z + sz * screw_pitch / 2,
                   screw_d);
    }
}

// right-triangle gusset in YZ plane, extruded along +X starting at x0
module gusset(x0) {
    translate([x0, 0, 0])
        rotate([90, 0, 90])   // polygon X->Y, polygon Y->Z, extrude->X
            linear_extrude(height = gusset_t)
                polygon([
                    [gusset_y0,              gusset_z0],
                    [gusset_y0 + gusset_leg, gusset_z0],
                    [gusset_y0,              gusset_z0 + gusset_leg]
                ]);
}

// ---------------- Assembly ----------------
union() {
    base_plate();
    motor_plate();
    gusset(base_x_min);                 // x = -25 .. -20
    gusset(base_x_max - gusset_t);      // x =  20 ..  25
}