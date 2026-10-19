// L-shaped NEMA 17 Stepper Motor Mounting Bracket
// Corrected version: Gussets strictly contained within X [-25, 25]

// --- Dimensions ---
// Base Plate
base_x_min = -25;
base_x_max = 25;
base_y_min = 0;
base_y_max = 45;
base_z_max = 5;

// M4 Holes (Base)
m4_hole_d = 4.5;
m4_x1 = -17;
m4_y1 = 30;
m4_x2 = 17;
m4_y2 = 30;

// Vertical Motor Plate
vert_x_min = -25;
vert_x_max = 25;
vert_y_min = 0;
vert_y_max = 5;
vert_z_max = 50;

// Motor Boss Hole (Vertical Plate)
boss_d = 23;
boss_x = 0;
boss_z = 28;

// M3 Holes (Motor Plate)
m3_hole_d = 3.4;
m3_pattern_size = 31;

// Gussets
gusset_thick = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_y_start = 5; // Corner at y=5
gusset_z_start = 5; // Corner at z=5

$fn = 64;

// --- Modeling ---

module gusset_shape() {
    // Right triangle in YZ plane
    // Corner at (0,0) in local YZ coords
    polygon(points = [
        [0, 0],
        [gusset_leg_y, 0],
        [0, gusset_leg_z]
    ]);
}

difference() {
    union() {
        // Base Plate
        translate([base_x_min, base_y_min, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z_max]);
        
        // Vertical Motor Plate
        translate([vert_x_min, vert_y_min, 0])
            cube([vert_x_max - vert_x_min, vert_y_max, vert_z_max]);
            
        // Gusset Left (Flush with x = -25, thickness 5mm)
        // Positioned from x = -25 to -20
        translate([base_x_min, gusset_y_start, gusset_z_start])
            linear_extrude(height = gusset_thick)
            gusset_shape();
            
        // Gusset Right (Flush with x = 25, thickness 5mm)
        // Positioned from x = 20 to 25
        translate([base_x_max - gusset_thick, gusset_y_start, gusset_z_start])
            linear_extrude(height = gusset_thick)
            gusset_shape();
    }

    // --- Subtractions ---

    // M4 Holes in Base Plate
    translate([m4_x1, m4_y1, -1]) 
        cylinder(h = base_z_max + 2, d = m4_hole_d);
    translate([m4_x2, m4_y2, -1]) 
        cylinder(h = base_z_max + 2, d = m4_hole_d);

    // Motor Boss Hole (Through the vertical plate along Y)
    translate([boss_x, -1, boss_z])
        rotate([0, 90, 0])
        cylinder(h = vert_y_max + 2, d = boss_d);

    // M3 Screw Holes (4 holes on 31mm square pattern)
    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([sx * (m3_pattern_size / 2), -1, boss_z + sy * (m3_pattern_size / 2)])
            rotate([0, 90, 0])
            cylinder(h = vert_y_max + 2, d = m3_hole_d);
    }
}