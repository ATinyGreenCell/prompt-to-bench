// NEMA 17 L-Shaped Mounting Bracket
// Units: mm

// --- Dimensions ---
base_x = 50;       // -25 to 25
base_y = 45;       // 0 to 45
base_z = 5;        // 0 to 5

motor_plate_x = 50; // -25 to 25
motor_plate_y = 5;  // 0 to 5
motor_plate_z = 50; // 0 to 50

hole_m4_d = 4.5;   // Vertical mounting holes
hole_m4_pos_x = [-17, 17];
hole_m4_pos_y = 30;

hole_motor_centre_d = 23; // Hole for motor boss
hole_motor_centre_z = 28; // Z position of hole centre
hole_motor_centre_x = 0;

hole_m3_d = 3.4;   // M3 screw holes
hole_m3_spacing = 31; // 31mm square pattern
hole_m3_z = 28;    // Z position of M3 holes (same as boss)

gusset_thickness = 5;
gusset_leg_y = 20; // Leg along +Y
gusset_leg_z = 20; // Leg along +Z
gusset_y_start = 5; // Where the plates meet (y=5)
gusset_z_start = 5; // Where the plates meet (z=5)

// --- Settings ---
$fn = 64;

// --- Main Body ---
module main_body() {
    union() {
        // Base Plate
        translate([0, 0, 0])
            cube([base_x, base_y, base_z], center=true);
        
        // Vertical Motor Plate
        translate([0, 0, 0])
            cube([motor_plate_x, motor_plate_y, motor_plate_z], center=true);
    }
}

// --- Cutouts ---
module cutouts() {
    difference() {
        main_body();
        
        // 1. M4 Vertical Holes
        for (x = hole_m4_pos_x) {
            translate([x, hole_m4_pos_y, 0])
                cylinder(h = base_z + 2, d = hole_m4_d, center=true);
        }
        
        // 2. Motor Centring Boss Hole (23mm)
        translate([hole_motor_centre_x, 0, hole_motor_centre_z])
            cylinder(h = motor_plate_z + 2, d = hole_motor_centre_d, center=true);
        
        // 3. M3 Screw Holes (31mm square pattern)
        // Pattern offsets from center: -15.5, 0, 15.5
        for (ox = [-hole_m3_spacing/2, 0, hole_m3_spacing/2]) {
            for (oy = [-hole_m3_spacing/2, 0, hole_m3_spacing/2]) {
                translate([ox, oy, hole_m3_z])
                    cylinder(h = motor_plate_z + 2, d = hole_m3_d, center=true);
            }
        }
    }
}

// --- Gussets ---
module gussets() {
    // Left Gusset (x = -25 to -20)
    translate([-22.5, gusset_y_start, gusset_z_start]) {
        // Right triangle in YZ plane, legs 20mm
        // Corner at (0,0) is the right angle.
        // Leg along Y: 20mm. Leg along Z: 20mm.
        polygon([
            [0, 0], 
            [gusset_leg_y, 0], 
            [0, gusset_leg_z]
        ]);
    }
    
    // Right Gusset (x = 20 to 25)
    mirror([1, 0, 0])
        translate([-22.5, gusset_y_start, gusset_z_start]) {
            polygon([
                [0, 0], 
                [gusset_leg_y, 0], 
                [0, gusset_leg_z]
            ]);
        }
}

// --- Assembly ---
gussets();
cutouts();