// L-shaped mounting bracket for NEMA 17 stepper motor.
// Base plate: 50 x 45 x 5 mm. Vertical plate: 50 x 5 x 50 mm.
// Includes M4 holes in base, motor boss hole, M3 screw holes, and gussets.

// Base dimensions
base_x = 50;
base_y = 45;
base_z = 5;

// Vertical plate dimensions
vert_x = 50;
vert_y = 5;
vert_z = 50;

// Hole positions and sizes
m4_x1 = -17;
m4_y1 = 30;
m4_x2 = 17;
m4_y2 = 30;
m4_d = 4.5;

boss_x = 0;
boss_z = 28;
boss_d = 23;

m3_d = 3.4;
m3_pattern_size = 31;

// Gusset dimensions
gusset_x_start = -25;
gusset_x_end = -20;
gusset_y_leg = 20;
gusset_z_leg = 20;
gusset_thickness = 5;

$fn = 64;

// Create the base plate
base = translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);

// Create the vertical plate (standing on the back edge of the base)
// The back edge of the base is at y = base_y. The plate sits there.
// Plate x: -25 to 25 (width 50). Plate y: 0 to 5 (thickness 5). Plate z: 0 to 50.
// We position it so its bottom face is at y = base_y.
vert = translate([-vert_x / 2, base_y, 0]) cube([vert_x, vert_y, vert_z]);

// Create the motor boss hole (through the vertical plate along Y)
// Hole is 23mm diameter, centred at x=0, z=28.
// It goes through the plate thickness (5mm).
boss_hole = translate([boss_x, base_y + vert_y / 2, boss_z]) cylinder(h = vert_y, d = boss_d);

// Create the four M3 screw holes in the motor plate (along Y)
// Pattern: 31mm square, centred on the boss hole.
// Boss is at x=0, z=28.
// Pattern corners relative to boss: +/- 15.5 in X, +/- 15.5 in Z.
// Absolute positions:
// x = 0 +/- 15.5 -> -15.5, 15.5
// z = 28 +/- 15.5 -> 12.5, 43.5
// y is through the plate thickness.
m3_holes = [
    translate([-m3_pattern_size / 2, base_y + vert_y / 2, boss_z - m3_pattern_size / 2]) cylinder(h = vert_y, d = m3_d),
    translate([m3_pattern_size / 2, base_y + vert_y / 2, boss_z - m3_pattern_size / 2]) cylinder(h = vert_y, d = m3_d),
    translate([-m3_pattern_size / 2, base_y + vert_y / 2, boss_z + m3_pattern_size / 2]) cylinder(h = vert_y, d = m3_d),
    translate([m3_pattern_size / 2, base_y + vert_y / 2, boss_z + m3_pattern_size / 2]) cylinder(h = vert_y, d = m3_d)
];

// Create the two M4 holes in the base plate
// Positions: (-17, 30) and (17, 30).
// They go through the base thickness (5mm).
m4_holes = [
    translate([m4_x1, m4_y1, base_z / 2]) cylinder(h = base_z, d = m4_d),
    translate([m4_x2, m4_y2, base_z / 2]) cylinder(h = base_z, d = m4_d)
];

// Create the gussets
// Right triangle in YZ plane. Legs 20mm along +Y and 20mm along +Z.
// Right angle at (y=5, z=5) relative to the plate corner.
// The plate corner is at y=5 (top of base), z=0 (bottom of plate).
// So the triangle vertices in local YZ coords (origin at plate corner y=5, z=0):
// (0,0) -> y=5, z=0 (corner)
// (20,0) -> y=25, z=0 (along Y)
// (0,20) -> y=5, z=20 (along Z)
// Wait, the prompt says "right-angle corner at y = 5, z = 5".
// Let's re-read: "legs 20 mm along +Y and 20 mm along +Z, its right-angle corner at y = 5, z = 5".
// This implies the triangle occupies:
// Y from 5 to 25.
// Z from 5 to 25.
// The hypotenuse connects (y=25, z=5) and (y=5, z=25).
// The vertices are (y=5, z=5), (y=25, z=5), (y=5, z=25).
// This forms a right triangle with legs of length 20.
// The gusset is 5mm thick in X.
// Left gusset: x from -25 to -20.
// Right gusset: x from 20 to 25.

// Define the polygon for the gusset profile in YZ plane
// Vertices: [y, z]
// (5, 5), (25, 5), (5, 25)
gusset_profile = [[5, 5], [25, 5], [5, 25]];

// Left Gusset
left_gusset = translate([-25, 0, 0]) linear_extrude(height = gusset_thickness) polygon(gusset_profile);

// Right Gusset
right_gusset = translate([20, 0, 0]) linear_extrude(height = gusset_thickness) polygon(gusset_profile);

// Combine everything
difference() {
    union() {
        base;
        vert;
        left_gusset;
        right_gusset;
    }
    union() {
        boss_hole;
        for (h = m3_holes) h;
        for (h = m4_holes) h;
    }
}