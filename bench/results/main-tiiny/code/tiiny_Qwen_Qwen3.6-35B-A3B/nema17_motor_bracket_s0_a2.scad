// NEMA 17 Stepper Motor Mounting Bracket for Syringe Pump
// Units: mm

// --- Base Plate Dimensions ---
base_x_half = 25;       // Half-width of base plate (x: -25 to 25)
base_y_len = 45;        // Length of base plate (y: 0 to 45)
base_z_thick = 5;       // Thickness of base plate (z: 0 to 5)

// --- Motor Mounting Plate Dimensions ---
motor_plate_x_half = 25; // Half-width of vertical plate (x: -25 to 25)
motor_plate_y_thick = 5; // Thickness of vertical plate (y: 0 to 5)
motor_plate_z_height = 50; // Height of vertical plate (z: 0 to 50)

// --- Hole Dimensions ---
m4_dia = 4.5;           // Diameter of M4 mounting holes
m3_dia = 3.4;           // Diameter of M3 screw holes
boss_dia = 23;          // Diameter of centring boss hole

// --- Hole Positions ---
// M4 holes on base plate
m4_x = 17;
m4_y = 30;

// M3 holes on motor plate (31mm square pattern)
m3_pitch = 31;
m3_x = m3_pitch / 2;
m3_y = m3_pitch / 2; // Note: The plate is thin in Y, so these are effectively just X offsets relative to center, but defined as a square pattern. Since the plate is only 5mm thick in Y, the "square" refers to the X-Z projection or the hole centers in X and Z. The prompt says "square pattern centred on the boss hole". Boss is at z=28. So holes are at z = 28 +/- 15.5.

// Boss Hole Center
boss_x = 0;
boss_z = 28;

// --- Gusset Dimensions ---
gusset_thick = 5;       // Thickness of gusset (along X)
gusset_leg_y = 20;      // Leg length along Y
gusset_leg_z = 20;      // Leg length along Z
// Right angle corner at y=5, z=5.
// Left gusset: x from -25 to -20.
// Right gusset: x from 20 to 25.

// --- Extrusion Depth for Cutting ---
cut_extend = 0.02;

// --- Module: Base Plate ---
module base_plate() {
    $fn = 64;
    // Main block
    difference() {
        cube([base_x_half * 2, base_y_len, base_z_thick], center = false);
        
        // M4 Holes
        // Hole 1
        translate([-m4_x, m4_y, -cut_extend])
            cylinder(d = m4_dia, h = base_z_thick + cut_extend * 2, center = false);
        // Hole 2
        translate([m4_x, m4_y, -cut_extend])
            cylinder(d = m4_dia, h = base_z_thick + cut_extend * 2, center = false);
    }
}

// --- Module: Motor Plate ---
module motor_plate() {
    $fn = 64;
    // Main block
    // The plate stands on the back edge of the base. 
    // Base is y: 0 to 45. Back edge is y=0? Or y=45?
    // "standing on the back edge of the base". Usually, if base is y:0-45, the "back" is often y=0 if the front is y=45, or vice versa.
    // Let's assume the base extends from y=0 to y=45. The motor plate is at the "back".
    // If the base is y:0-45, and the motor plate is y:0-5, it sits on the edge at y=0.
    // Let's verify the gusset position. "Right-angle corner at y=5, z=5".
    // If the motor plate is y:0-5, and the base is z:0-5, the corner (y=5, z=5) is the inner corner where they meet.
    // This implies the motor plate is at y:0-5 and the base is at z:0-5.
    // So the motor plate occupies y:0-5, z:0-50, x:-25-25.
    
    difference() {
        cube([motor_plate_x_half * 2, motor_plate_y_thick, motor_plate_z_height], center = false);
        
        // Boss Hole (along Y)
        // Center at x=0, z=28.
        // The hole goes through the thickness of the motor plate (y: 0 to 5).
        // We need to extend it past the faces y=0 and y=5.
        translate([boss_x, -cut_extend, boss_z])
            cylinder(d = boss_dia, h = motor_plate_y_thick + cut_extend * 2, center = false, axis = [0,1,0]);
            
        // M3 Screw Holes
        // 31mm square pattern centred on boss hole (x=0, z=28).
        // Holes are at x = +/- 15.5, z = 28 +/- 15.5.
        // z positions: 28 - 15.5 = 12.5; 28 + 15.5 = 43.5.
        // x positions: -15.5, 15.5.
        
        m3_holes = [
            [-m3_x, boss_z - m3_y],
            [ m3_x, boss_z - m3_y],
            [-m3_x, boss_z + m3_y],
            [ m3_x, boss_z + m3_y]
        ];
        
        for (p = m3_holes) {
            translate([p[0], -cut_extend, p[1]])
                cylinder(d = m3_dia, h = motor_plate_y_thick + cut_extend * 2, center = false, axis = [0,1,0]);
        }
    }
}

// --- Module: Gusset ---
module gusset(side) {
    $fn = 64;
    // Side is -1 for left, 1 for right.
    // Left: x from -25 to -20. Right: x from 20 to 25.
    // Right angle corner at y=5, z=5.
    // Legs: 20mm along +Y, 20mm along +Z.
    // So the triangle in YZ plane has vertices:
    // (y=5, z=5) - Right angle
    // (y=5+20, z=5) = (y=25, z=5)
    // (y=5, z=5+20) = (y=5, z=25)
    
    // We will create a polygon in YZ and extrude it along X.
    // For the left gusset, X is from -25 to -20.
    // For the right gusset, X is from 20 to 25.
    
    y1 = 5;
    z1 = 5;
    y2 = 5 + gusset_leg_y;
    z2 = 5 + gusset_leg_z;
    
    // Define the triangle vertices in YZ
    tri_yz = [
        [y1, z1],
        [y2, z1],
        [y1, z2]
    ];
    
    if (side == -1) {
        x_start = -25;
        x_end = -20;
    } else {
        x_start = 20;
        x_end = 25;
    }
    
    // Create the 2D shape
    shape = polygon(points = tri_yz);
    
    // Extrude along X
    // linear_extrude builds along Z by default. To build along X, we can rotate the result.
    // Or we can use rotate_extrude, but that's for revolution.
    // Let's use linear_extrude on a 2D shape, but rotate the whole object.
    // Actually, linear_extrude(height, center=false) builds along Z.
    // We want to build along X.
    // So: Create shape in YZ. Extrude it along Z (which becomes X after rotation), then rotate.
    // Wait, if we extrude along Z, the height is the length in Z.
    // We want the length in X.
    // So: Create shape in YZ. Extrude along Z with height = gusset_th