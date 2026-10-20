$fn = 64;

// --- Dimensions ---
base_x = 50;   // Base width (x: -25 to 25)
base_y = 45;   // Base length (y: 0 to 45)
base_z = 5;    // Base thickness

vert_x = 50;   // Vertical plate width
vert_y = 5;    // Vertical plate thickness (y: 0 to 5)
vert_z = 50;   // Vertical plate height (z: 0 to 50)

gusset_x_len = 5; // Gusset thickness (along X)
gusset_y_leg = 20; // Gusset leg along Y
gusset_z_leg = 20; // Gusset leg along Z
gusset_corner_y = 5; // Gusset corner Y position
gusset_corner_z = 5; // Gusset corner Z position

hole_m4_dia = 4.5;  // Diameter for mounting holes
hole_m3_dia = 3.4;  // Diameter for motor screw holes
hole_boss_dia = 23; // Diameter for motor shaft boss
boss_z_pos = 28;    // Z position of motor boss hole
boss_pattern_size = 31; // Size of the square pattern for M3 holes

// --- Base Plate ---
base_plate = cube([base_x, base_y, base_z]);

// --- Vertical Motor Plate ---
// Positioned on top of the base (at z = base_z)
vertical_plate = cube([vert_x, vert_y, vert_z]);

// --- Assembly ---
bracket = union() {
    base_plate;
    translate([0, 0, base_z]) vertical_plate;
};

// --- Cutouts ---
cutouts = difference() {
    bracket;

    // Base M4 holes
    translate([-17, 30, -0.1]) cylinder(h = base_z + 0.2, d = hole_m4_dia);
    translate([17, 30, -0.1]) cylinder(h = base_z + 0.2, d = hole_m4_dia);

    // Vertical Plate Boss Hole (23mm)
    // Hole is along Y axis (through the 5mm thickness)
    translate([0, 0, boss_z_pos - 0.1]) cylinder(h = vert_y + 0.2, d = hole_boss_dia);

    // Vertical Plate M3 Holes (4 holes on 31mm square pattern)
    // Pattern centered on boss hole (0, 28)
    // Half-size = 15.5mm
    for (x_offset = [-15.5, 15.5]) {
        for (z_offset = [-15.5, 15.5]) {
            translate([x_offset, 0, boss_z_pos + z_offset - 0.1])
                cylinder(h = vert_y + 0.2, d = hole_m3_dia);
        }
    }
};

// --- Gussets ---
// Right triangle in YZ plane, legs 20mm, thickness 5mm
// Corner at y=5, z=5
gusset_shape = polygon([
    [0, 0],
    [gusset_y_leg, 0],
    [0, gusset_z_leg]
]);

// Left Gusset (x: -25 to -20, center -22.5)
left_gusset = translate([-22.5, gusset_corner_y, gusset_corner_z]) {
    linear_extrude(height = gusset_x_len) {
        gusset_shape;
    }
};

// Right Gusset (x: 20 to 25, center 22.5)
right_gusset = translate([22.5, gusset_corner_y, gusset_corner_z]) {
    linear_extrude(height = gusset_x_len) {
        gusset_shape;
    }
};

// --- Final Part ---
final_part = union() {
    cutouts;
    left_gusset;
    right_gusset;
};

// Render
final_part;