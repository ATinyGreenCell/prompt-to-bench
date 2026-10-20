// ------------------- Parameters (mm) -------------------
// Base plate
base_x = 50;          // width  (x: -25 .. 25)
base_y = 45;          // length (y: 0 .. 45)
base_z = 5;           // thickness (z: 0 .. 5)

// Motor plate (vertical)
motor_x = 50;         // width (same as base)
motor_y = 5;          // thickness along Y (back edge of base)
motor_z = 50;         // height along Z

// Hole dimensions
m4_d = 4.5;           // M4 through‑hole diameter
m4_r = m4_d/2;

m3_d = 3.4;           // M3 screw hole diameter
m3_r = m3_d/2;

boss_d = 23;          // motor centring boss hole diameter
boss_r = boss_d/2;
boss_z = 28;          // Z‑center of boss hole (relative to overall Z=0)

// Gusset geometry
gusset_thick = 5;     // thickness in X direction
gusset_leg = 20;      // leg length in Y and Z

$fn = 64;             // resolution for circles/cylinders

// ------------------- Solid parts -------------------
module solid_parts() {
    union() {
        // Base plate (lies on the bed)
        translate([-25, 0, 0])
            cube([base_x, base_y, base_z], center = false);

        // Motor plate (vertical, standing on back edge of base)
        translate([-25, base_y, 0])
            cube([motor_x, motor_y, motor_z], center = false);

        // Left gusset (x = -25 .. -20)
        gusset(-25);

        // Right gusset (x = 20 .. 25)
        gusset(20);
    }
}

// Gusset module: creates a right‑triangle prism of thickness gusset_thick
// positioned so that its right‑angle corner sits at (corner_x, base_y, base_z)
module gusset(corner_x) {
    // triangle defined in the XY plane (points (0,0), (gusset_leg,0), (0,gusset_leg))
    // after rotation it will lie in the YZ plane, and extrusion will give X‑thickness
    translate([corner_x, base_y, base_z])          // move corner to correct location
        rotate([0, 90, 0])                         // rotate so extrusion goes along X
            linear_extrude(height = gusset_thick) // thickness in X
                polygon(points = [[0,0],
                                   [gusset_leg,0],
                                   [0,gusset_leg]]);
}

// ------------------- Cutting features -------------------
module cut_features() {
    union() {
        // M4 through‑holes in base plate
        for (pos = [[-17,30], [17,30]]) {
            translate([pos[0], pos[1], -0.5])          // extend below and above the plate
                cylinder(r = m4_r, h = base_z + 1);
        }

        // Boss hole (oriented along Y) in motor plate
        translate([0, base_y + motor_y/2, base_z + boss_z]) // centre at correct Z
            rotate([90,0,0])                               // rotate cylinder to Y‑axis
                cylinder(r = boss_r, h = motor_y + 2);    // extend beyond Y faces

        // Four M3 screw holes (oriented along Y) in motor plate
        for (dx = [-15.5, 15.5])
            for (dz = [-15.5, 15.5])
                translate([dx, base_y + motor_y/2, base_z + boss_z + dz])
                    rotate([90,0,0])
                        cylinder(r = m3_r, h = motor_y + 2);
    }
}

// ------------------- Final model -------------------
difference() {
    solid_parts();
    cut_features();
}