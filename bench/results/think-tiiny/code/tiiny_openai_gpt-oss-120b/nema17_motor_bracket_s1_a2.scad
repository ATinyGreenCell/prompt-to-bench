//--------------------
// Parameters
//--------------------
base_x = 50;               // total width of base plate (x: -25 to 25)
base_y = 45;               // length of base plate (y: 0 to 45)
base_z = 5;                // thickness of base plate (z: 0 to 5)

m4_dia = 4.5;             // M4 hole diameter
m4_radius = m4_dia/2;
m4_extend = 0.2;          // extra length beyond faces for clean cut

motor_y = 5;               // thickness of motor plate in Y direction
motor_z = 50;              // height of motor plate in Z direction

boss_dia = 23;             // motor centring boss hole diameter
boss_radius = boss_dia/2;
boss_extend = 0.2;         // extra length beyond faces for clean cut

m3_dia = 3.4;              // M3 screw hole diameter
m3_radius = m3_dia/2;
m3_extend = 0.2;           // extra length beyond faces for clean cut

gusset_thick = 5;          // thickness of gussets (in X)
gusset_leg = 20;           // leg length of right‑triangle in Y and Z
gusset_extend = 0.2;       // extra length beyond faces for clean cut
// pre‑computed offsets for the gusset polygon (Y‑Z plane)
gusset_y0 = 5 - gusset_extend;          // start Y (flush with base plate top)
gusset_y1 = gusset_y0 + gusset_leg;    // end Y
gusset_z0 = -5;                        // start Z (negative to allow rotation)
gusset_z1 = gusset_z0 - gusset_leg;    // end Z (negative)

//--------------------
// Geometry
//--------------------
$fn = 64;

// Base plate with M4 holes (vertical through Z)
module base_plate() {
    difference() {
        // solid block
        translate([-base_x/2, 0, 0])
            cube([base_x, base_y, base_z], center = false);
        // M4 holes
        for (pos = [[-17, 30], [17, 30]]) {
            translate([pos[0], pos[1], -m4_extend])
                cylinder(r = m4_radius,
                         h = base_z + 2*m4_extend,
                         center = true);
        }
    }
}

// Motor plate with boss hole and M3 screw holes (cut along Y)
module motor_plate() {
    difference() {
        // solid block
        translate([-base_x/2, 0, 0])
            cube([base_x, motor_y, motor_z], center = false);
        // Boss hole (cylinder along Y)
        translate([0, motor_y/2, 28])
            rotate([90,0,0])
                cylinder(r = boss_radius,
                         h = motor_y + 2*boss_extend,
                         center = true);
        // Four M3 holes (cylinder along Y)
        for (dx = [-15.5, 15.5])
            for (dz = [12.5, 43.5])
                translate([dx, motor_y/2, dz])
                    rotate([90,0,0])
                        cylinder(r = m3_radius,
                                 h = motor_y + 2*m3_extend,
                                 center = true);
    }
}

// Single triangular gusset (right‑triangle in YZ, extruded in X)
module triangular_gusset() {
    // Define the triangle in the YZ plane with Y positive after rotation
    // (original Z is negative so that after rotate([0,90,0]) Y becomes positive)
    rotate([0,90,0])                     // rotate so extrusion goes along +X
        linear_extrude(height = gusset_thick + gusset_extend)
            polygon(points = [
                [gusset_y0, gusset_z0],                 // right‑angle corner
                [gusset_y1, gusset_z0],                 // point along +Y
                [gusset_y0, gusset_z1]                  // point along +Z
            ]);
}

// Left gusset (flush with x = -25 edge)
module left_gusset() {
    translate([-25, 0, 0])   // shift to the left edge
        triangular_gusset();
}

// Right gusset (flush with x = 25 edge)
module right_gusset() {
    translate([20, 0, 0])    // shift to the right edge (x = 20..25)
        triangular_gusset();
}

//--------------------
// Assembly
//--------------------
union() {
    base_plate();
    motor_plate();
    left_gusset();
    right_gusset();
}