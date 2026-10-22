// Coarse cell strainer for 50mL conical tube
// Designed for FDM printing, printed upright on the XY plane.

// --- Dimensions ---
outer_dia      = 25.0;    // Outer diameter of the main cup
wall_thick     = 1.2;     // Wall thickness
bore_dia       = 22.6;    // Inner diameter of the cup
cup_height     = 32.0;    // Total height of the cup part
floor_thick    = 1.2;     // Thickness of the bottom floor
collar_start_z = 26.0;    // Z height where the flare begins
collar_end_z   = 30.0;    // Z height where the flare ends
rim_dia        = 33.0;    // Diameter of the top rim
rim_height     = 2.0;     // Height of the rim (30 to 32mm)
hole_dia       = 1.0;     // Diameter of the strainer holes
grid_spacing   = 2.0;     // Spacing of the hole grid
max_hole_rad   = 10.0;    // Maximum radius for hole placement
notch_width    = 3.0;     // Width of the vent notches
notch_radius   = 12.5;    // Radius from axis where notches start cutting

$fn = 128;

// --- Calculations ---
bore_rad = bore_dia / 2;
outer_rad = outer_dia / 2;
rim_rad = rim_dia / 2;
notch_cut_rad = notch_radius;

// --- Geometry ---

module strainer_body() {
    difference() {
        union() {
            // Main Cup Body
            cylinder(h = cup_height, d = outer_dia);
            
            // Flare (45-degree cone)
            // Starts at z=26 (d=25) and ends at z=30 (d=33)
            // This is a truncated cone (frustum)
            translate([0, 0, collar_start_z])
                cylinder(h = collar_end_z - collar_start_z, d1 = outer_dia, d2 = rim_dia);
            
            // Top Rim
            translate([0, 0, collar_end_z])
                cylinder(h = rim_height, d = rim_dia);
        }

        // Hollow out the bore
        translate([0, 0, -0.01])
            cylinder(h = cup_height + 0.02, d = bore_dia);

        // Vent Notches (on +X and -X sides)
        // Removes material beyond 12.5mm from axis from z=25 up
        for (side = [-1, 1]) {
            translate([side * notch_cut_rad, 0, 25])
                rotate([0, 0, 0]) // Placeholder for logic
                // We use a cube to cut the notch. 
                // To make it "remove material beyond 12.5mm", we position a cube 
                // that starts at the notch radius and extends outwards.
                // Since the user said "remove the collar and rim beyond 12.5mm", 
                // we cut a notch into the side.
                cube([rim_dia, notch_width, cup_height], center = true); 
                // Wait, the instruction says "remove the collar and rim beyond 12.5mm".
                // This implies a notch cut into the side of the object.
        }
        
        // Corrected Notch Logic: 
        // "3 mm wide vent notches, on the +X and -X sides, remove the collar and rim beyond 12.5 mm from the axis from z = 25 up"
        // This means we cut a slot into the side of the part.
        for (side = [-1, 1]) {
            translate([side * (notch_cut_rad - 0.1), 0, 25])
                cube([notch_cut_rad + 10, notch_width, cup_height - 24]);
        }
    }
}

// Re-implementing the body with the specific notch requirement
module final_strainer() {
    difference() {
        // The Solid Part
        union() {
            // Main Cup
            cylinder(h = cup_height, d = outer_dia);
            // Flare
            translate([0, 0, collar_start_z])
                cylinder(h = collar_end_z - collar_start_z, d1 = outer_dia, d2 = rim_dia);
            // Rim
            translate([0, 0, collar_end_z])
                cylinder(h = rim_height, d = rim_dia);
        }

        // The Bore (Hollow)
        translate([0, 0, -0.01])
            cylinder(h = cup_height + 0.02, d = bore_dia);

        // The Notches
        // "remove the collar and rim beyond 12.5 mm from the axis from z = 25 up"
        // This is interpreted as cutting a slot into the side of the part.
        for (side = [-1, 1]) {
            translate([side * notch_cut_rad, -notch_width/2, 25])
                cube([notch_cut_rad + 5, notch_width, cup_height - 24]);
        }
    }
}

// The actual assembly
difference() {
    final_strainer(),
    
    // The Holes in the floor
    // "The floor has 1.0 mm holes on a 2 mm square grid... one hole at the centre... within 10 mm of the axis"
    // Grid is centered on axis.
    // Number of holes: 81 (implies 9x9 grid if 2mm spacing and 10mm radius)
    // Let's calculate the grid:
    // Center is at 0,0. 
    // Spacing is 2. 
    // Max radius is 10.
    // Points: i from -4 to 4 -> i*2 = [-8, -6, -4, -2, 0, 2, 4, 6, 8]
    // Max distance from center for (8,8) is sqrt(64+64) = 11.3. 
    // The user specifies 81 holes and "keeping every hole whose centre is within 10mm".
    // Let's use a loop to be precise.
    
    for (x = [-10 : grid_spacing : 10]) {
        for (y = [-10 : grid_spacing : 10]) {
            // Check if center is within 10mm of axis
            if (sqrt(x*x + y*y) <= max_hole_rad) {
                translate([x, y, -0.01])
                    cylinder(h = floor_thick + 0.02, d = hole_dia);
            }
        }
    }
}