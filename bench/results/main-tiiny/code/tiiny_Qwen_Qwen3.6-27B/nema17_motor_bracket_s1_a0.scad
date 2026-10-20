// NEMA 17 L-Bracket for Syringe Pump
// Print orientation: Base on bed (XY plane), building up Z.

// --- Dimensions ---
// Base Plate
base_x_min = -25;
base_x_max = 25;
base_y_min = 0;
base_y_max = 45;
base_z = 5;

// Vertical Motor Plate
vert_x_min = -25;
vert_x_max = 25;
vert_y_min = 0;
vert_y_max = 5;
vert_z = 50;

// Base Holes (M4)
base_hole_dia = 4.5;
base_hole_y = 30;
base_hole_x_offset = 17;

// Motor Boss Hole
boss_hole_dia = 23;
boss_hole_z = 28;

// Motor Mount Holes (M3)
mount_hole_dia = 3.4;
mount_pattern_size = 31; // Square pattern side length
mount_pattern_offset = mount_pattern_size / 2;

// Gussets
gusset_thickness = 5;
gusset_leg = 20;
gusset_x_start = 20; // Distance from center to start of gusset (25 - 5)
gusset_x_end = 25;

// --- Settings ---
$fn = 64; // High resolution for round holes

// --- Main Structure ---
difference() {
    union() {
        // 1. Base Plate
        translate([0, 0, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z], center = [base_x_min + (base_x_max - base_x_min)/2, base_y_min, 0]);

        // 2. Vertical Motor Plate
        // Note: The prompt says y from 0 to 5. The base is y 0 to 45.
        // The vertical plate stands on the "back edge". Usually back is y=0 or y=max.
        // Given the base holes are at y=30 and gussets go +Y, the vertical plate is likely at y=0 (back).
        translate([vert_x_min, vert_y_min, 0])
            cube([vert_x_max - vert_x_min, vert_y_max - vert_y_min, vert_z]);

        // 3. Gussets
        // Left Gusset
        translate([base_x_min, vert_y_max, base_z]) {
            linear_extrude(height = gusset_thickness, convexity = 10)
                polygon(points = [
                    [0, 0], // Corner at y=5, z=5 (relative to start)
                    [gusset_leg, 0], // Along +Y
                    [0, gusset_leg]  // Along +Z
                ]);
        }

        // Right Gusset
        translate([base_x_max - gusset_thickness, vert_y_max, base_z]) {
            linear_extrude(height = gusset_thickness, convexity = 10)
                polygon(points = [
                    [0, 0], // Corner at y=5, z=5 (relative to start)
                    [gusset_leg, 0], // Along +Y
                    [0, gusset_leg]  // Along +Z
                ]);
        }
    }

    // --- Cuts ---

    // 1. Base Plate Holes (M4)
    // Hole 1
    translate([-base_hole_x_offset, base_hole_y, -1])
        cylinder(h = base_z + 2, r = base_hole_dia / 2, center = true);
    // Hole 2
    translate([base_hole_x_offset, base_hole_y, -1])
        cylinder(h = base_z + 2, r = base_hole_dia / 2, center = true);

    // 2. Motor Boss Hole (Through Y)
    // Center at x=0, z=28. Cuts through the vertical plate (y 0 to 5).
    translate([0, vert_y_min + (vert_y_max - vert_y_min)/2, boss_hole_z])
        rotate([90, 0, 0]) // Rotate to align cylinder along Y
        cylinder(h = vert_y_max - vert_y_min + 2, r = boss_hole_dia / 2, center = true);

    // 3. Motor Mount Holes (M3)
    // 4 holes on a 31mm square pattern centered on the boss hole (x=0, z=28)
    // Pattern is in the XZ plane of the vertical plate.
    // Holes go through Y.
    for (dx = [-mount_pattern_offset, mount_pattern_offset]) {
        for (dz = [-mount_pattern_offset, mount_pattern_offset]) {
            translate([dx, vert_y_min + (vert_y_max - vert_y_min)/2, boss_hole_z + dz])
                rotate([90, 0, 0]) // Align along Y
                cylinder(h = vert_y_max - vert_y_min + 2, r = mount_hole_dia / 2, center = true);
        }
    }
}