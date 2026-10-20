// === NEMA 17 Stepper Motor Mounting Bracket ===
// Print orientation: base plate on bed (XY plane at z=0)

// --- Base plate dimensions ---
base_x_half = 25;        // Half-width in X (x: -25 to 25)
base_y = 45;             // Depth in Y (y: 0 to 45)
base_z = 5;              // Height/thickness in Z (z: 0 to 5)

// --- Base plate mounting holes (M4, 4.5 mm dia) ---
m4_dia = 4.5;
m4_x = 17;               // X position of holes
m4_y = 30;               // Y position of holes

// --- Vertical motor plate dimensions ---
motor_plate_x_half = 25; // Half-width in X (x: -25 to 25)
motor_plate_y = 5;       // Depth in Y (y: 0 to 5)
motor_plate_z = 50;      // Height in Z (z: 0 to 50)

// --- Motor centring boss hole ---
boss_dia = 23;            // Diameter of centring boss hole
boss_x = 0;               // X centre
boss_z = 28;              // Z centre

// --- Motor mounting holes (M3, 3.4 mm dia) on 31 mm square pattern ---
m3_dia = 3.4;
m3_pattern = 31;           // Square pattern size (31 mm)
m3_half = m3_pattern / 2; // Half of pattern size

// --- Triangular gussets ---
gusset_thickness = 5;     // Thickness in X (flush with edges)
gusset_leg_y = 20;        // Leg along +Y
gusset_leg_z = 20;        // Leg along +Z
gusset_corner_y = 5;       // Y of right-angle corner (where plates meet)
gusset_corner_z = 5;       // Z of right-angle corner

// --- Global fineness for round holes ---
$fn = 64;

// --- Build the part ---
module bracket() {
    // Main body: base plate + vertical motor plate
    union() {
        // Base plate
        cube([2 * base_x_half, base_y, base_z], center = [0, 0, 0]);
        
        // Vertical motor plate (standing on back edge of base at y=0)
        translate([0, 0, base_z]) {
            cube([2 * motor_plate_x_half, motor_plate_y, motor_plate_z], center = [0, 0, 0]);
        }
    }
    
    // Triangular gussets (in YZ plane, thickness in X)
    for (x_off = [-base_x_half, base_x_half - gusset_thickness]) {
        translate([x_off, gusset_corner_y, gusset_corner_z]) {
            // Right triangle in YZ plane, legs along +Y and +Z
            // Extrude in X direction for thickness
            linear_extrude(height = gusset_thickness, center = true) {
                // Rotate to put triangle in YZ plane
                rotate([90, 0, 0]) {
                    polygon([[0, 0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
                }
            }
        }
    }
    
    // Cut holes
    difference() {
        // Re-create the full body
        union() {
            cube([2 * base_x_half, base_y, base_z], center = [0, 0, 0]);
            translate([0, 0, base_z]) {
                cube([2 * motor_plate_x_half, motor_plate_y, motor_plate_z], center = [0, 0, 0]);
            }
            
            // Add gussets
            for (x_off = [-base_x_half, base_x_half - gusset_thickness]) {
                translate([x_off, gusset_corner_y, gusset_corner_z]) {
                    rotate([90, 0, 0]) {
                        linear_extrude(height = gusset_thickness, center = true) {
                            polygon([[0, 0], [gusset_leg_y, 0], [0, gusset_leg_z]]);
                        }
                    }
                }
            }
        }
        
        // M4 holes through base plate (extend past both faces)
        for (x_off = [-m4_x, m4_x]) {
            translate([x_off, m4_y, -0.5]) {
                cylinder(d = m4_dia, h = base_z + 1, center = true);
            }
        }
        
        // Boss hole through motor plate (along Y, extend past front/back)
        translate([boss_x, 0, boss_z]) {
            cylinder(d = boss_dia, h = motor_plate_y + 1, center = true, axis = [0, 1, 0]);
        }
        
        // M3 mounting holes through motor plate (along Y)
        for (x_off = [-m3_half, m3_half]) {
            for (z_off = [-m3_half, m3_half]) {
                translate([x_off, 0, boss_z + z_off]) {
                    cylinder(d = m3_dia, h = motor_plate_y + 1, center = true, axis = [0, 1, 0]);
                }
            }
        }
    }
}

bracket();