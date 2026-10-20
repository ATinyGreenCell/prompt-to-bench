$fn = 64; // smooth curves

// ---------------------
// Base plate dimensions
// ---------------------
bp_width     = 50;   // X
bp_length    = 45;   // Y
bp_thickness = 5;   // Z
bp_hole_d    = 4.5; // M4 diameter
bp_hole_r    = bp_hole_d/2;
bp_hole_z    = bp_thickness/2;
bp_hole_y    = 30;
bp_hole_x1   = -17;
bp_hole_x2   = 17;

// ---------------------
// Motor plate dimensions
// ---------------------
mp_width     = 50;   // X
mp_length    = 5;    // Y
mp_thickness = 50;   // Z
mp_hole_d    = 3.4; // M3 diameter
mp_hole_r    = mp_hole_d/2;
mp_boss_d    = 23;   // boss diameter
mp_boss_r    = mp_boss_d/2;
mp_boss_y    = mp_length/2;   // 2.5
mp_boss_z    = 28;           // relative to motor plate origin
mp_screw_pattern = 31; // side length of square pattern
mp_screw_offset  = mp_screw_pattern/2; // 15.5
mp_screw_y      = mp_length/2;   // 2.5
mp_screw_z_base = 28;           // base z of pattern

// ---------------------
// Gusset dimensions
// ---------------------
gusset_thickness = 5;   // extrusion along X
gusset_leg       = 20;  // legs along +Y and +Z
gusset_corner_y = 5;   // right‑angle corner y
gusset_corner_z = 5;   // right‑angle corner z

// ---------------------
// Base plate module
// ---------------------
module base_plate() {
    cube([bp_width, bp_length, bp_thickness], center=false);
}

// ---------------------
// Base plate holes
// ---------------------
module base_holes() {
    // first hole
    translate([bp_hole_x1, bp_hole_y, bp_hole_z])
        cylinder(r=bp_hole_r, h=bp_thickness+0.02, center=false);
    // second hole
    translate([bp_hole_x2, bp_hole_y, bp_hole_z])
        cylinder(r=bp_hole_r, h=bp_thickness+0.02, center=false);
}

// ---------------------
// Motor plate module
// ---------------------
module motor_plate() {
    cube([mp_width, mp_length, mp_thickness], center=false);
}

// ---------------------
// Motor plate holes
// ---------------------
module motor_holes() {
    // boss hole (along Y)
    translate([0, 0, mp_boss_z])
        rotate([90,0,0]) // rotate cylinder from Z to Y
        cylinder(r=mp_boss_r, h=mp_thickness+0.02, center=false);
    // screw holes (along Y)
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([i*mp_screw_offset, 0, mp_screw_z_base + j*mp_screw_offset])
                rotate([90,0,0]) // rotate cylinder from Z to Y
                cylinder(r=mp_hole_r, h=mp_thickness+0.02, center=false);
        }
    }
}

// ---------------------
// Gusset module
// ---------------------
module gusset() {
    // triangle in YZ plane (represented in XY)
    polygon(points=[
        [gusset_corner_y, gusset_corner_z],
        [gusset_corner_y+gusset_leg, gusset_corner_z],
        [gusset_corner_y, gusset_corner_z+gusset_leg]
    ]);
    // extrude along X
    rotate([0,90,0]) linear_extrude(height=gusset_thickness, center=false);
}

// ---------------------
// Assembly
// ---------------------
union() {
    // Base plate with holes
    difference() {
        base_plate();          // at origin (X 0..50, Y 0..45, Z 0..5)
        base