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
notch_cut_rad  = 12.5;    // Radius from axis where notches start cutting

$fn = 128;

// --- Geometry ---

module strainer_body() {
    difference() {
        // The Solid Part
        union() {
            // Main Cup
            cylinder(h = cup_height, d = outer_dia);
            
            // Flare (45-degree cone)
            // Starts at z=26 (d=25) and ends at z=30 (d=33)
            translate([0, 0, collar_start_z])
                cylinder(h = collar_end_z - collar_start_z, d1 = outer_dia, d2 = rim_dia);
            
            // Rim
            translate([0, 0, collar_end_z])
                cylinder(h = rim_height, d = rim_dia);
        }

        // The Bore (Hollow)
        // Subtracting from z=floor_thick to cup_height
        translate([0, 0, floor_thick - 0.01])
            cylinder(h = cup_height - floor_thick + 0.02, d = bore_dia);

        // The Notches
        // "remove the collar and rim beyond 12.5 mm from the axis from z = 25 up"
        // We create a notch by subtracting a shape that exists only outside 12.5mm radius.
        // The notch is 3mm wide on +X and -X sides.
        for (side = [-1, 1]) {
            translate([side * notch_cut_rad, 0, 25])
            rotate([0, 0, 90]) // Orient the notch width along Y
            // We use a large cube to ensure it cuts through the outer edges
            cube([20, notch_width, cup_height], center = true);
        }
    }
}

// --- Final Assembly ---

difference() {
    strainer_body();
    
    // The Holes in the floor
    // "The floor has 1.0 mm holes on a 2 mm square grid... one hole at the centre... within 10 mm of the axis"
    // To get 81 holes (9x9) with 2mm spacing, we need indices -4 to 4.
    // We use a loop that covers the range and checks the radius.
    for (i = [-4 : 4]) {
        for (j = [-4 : 4]) {
            let (x_pos = i * grid_spacing, y_pos = j * grid_spacing)
            if (sqrt(x_pos*x_pos + y_pos*y_pos) <= max_hole_rad) {
                translate([x_pos, y_pos, -0.01])
                    cylinder(h = floor_thick + 0.02, d = hole_dia);
            }
        }
    }
}