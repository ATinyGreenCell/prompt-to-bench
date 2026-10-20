// NEMA 17 L-shaped mounting bracket
// Print orientation: base plate on bed (z=0), builds upward (+Z), centred in X.

$fn = 64;

// ---- Base plate ----
base_xmin = -25;   // left edge of base plate
base_xmax =  25;   // right edge of base plate
base_ymin =   0;   // front edge of base plate
base_ymax =  45;   // back edge of base plate
base_zmin =   0;   // bottom of base plate (bed)
base_zmax =   5;   // top of base plate

// ---- Vertical motor plate ----
mp_xmin = -25;     // left edge of motor plate
mp_xmax =  25;     // right edge of motor plate
mp_ymin =   0;     // front face of motor plate
mp_ymax =   5;     // back face of motor plate (meets base plate)
mp_zmin =   0;     // bottom of motor plate
mp_zmax =  50;     // top of motor plate

// ---- Motor plate holes (cut along Y) ----
boss_d   = 23;     // motor centring boss hole diameter
boss_cx  =  0;     // boss hole centre X
boss_cz  = 28;     // boss hole centre Z
screw_d  =  3.4;   // M3 screw hole diameter
screw_sq =  31;    // square pattern side length (centred on boss)

// ---- Base plate holes (cut along Z) ----
base_hole_d = 4.5; // M4 vertical through-hole diameter
base_hole_x = 17;  // |x| of the two base holes
base_hole_y = 30;  // y of the two base holes

// ---- Gussets ----
gusset_t   =  5;   // gusset thickness (X)
gusset_leg = 20;   // right-triangle leg length (Y and Z)
gusset_y0  =   5;  // right-angle corner Y (where plates meet)
gusset_z0  =   5;  // right-angle corner Z (where plates meet)

// ---- Base plate solid ----
base_plate = translate([base_xmin, base_ymin, base_zmin])
    cube([base_xmax - base_xmin, base_ymax - base_ymin, base_zmax - base_zmin]);

// ---- Vertical motor plate solid ----
motor_plate = translate([mp_xmin, mp_ymin, mp_zmin])
    cube([mp_xmax - mp_xmin, mp_ymax - mp_ymin, mp_zmax - mp_zmin]);

// ---- Motor plate cutters (extend 1 mm past both Y faces) ----
boss_cut = translate([boss_cx, mp_ymin - 1, boss_cz])
    rotate([90, 0, 0])
    cylinder(h = mp_ymax - mp_ymin + 2, d = boss_d, $fn = $fn);

screw_cut = [for (sx = [-1, 1]) for (sz = [-1, 1])]
    translate([boss_cx + sx * screw_sq / 2, mp_ymin - 1, boss_cz + sz * screw_sq / 2])
    rotate([90, 0, 0])
    cylinder(h = mp_ymax - mp_ymin + 2, d = screw_d, $fn = $fn);

// ---- Base plate cutters (extend 1 mm past both Z faces) ----
base_hole_cut = [for (sx = [-1, 1])]
    translate([sx * base_hole_x, base_hole_y, base_zmin - 1])
    cylinder(h = base_zmax - base_zmin + 2, d = base_hole_d, $fn = $fn);

// ---- Triangular gussets (right triangle in YZ, extruded in X) ----
gusset = [for (sx = [-1, 1])]
    translate([sx * 25 - (sx < 0 ? 0 : gusset_t), gusset_y0, gusset_z0])
    linear_extrude(height = gusset_t)
    polygon(points = [[0, 0], [gusset_leg, 0], [0, gusset_leg]]);

// ---- Assemble ----
difference() {
    union() {
        base_plate;
        motor_plate;
        gusset;
    }
    boss_cut;
    screw_cut;
    base_hole_cut;
}