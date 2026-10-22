// --- Parameters ---
// Main tube dimensions
outer_diameter = 25.0;       // OD of the main tube
wall_thickness = 1.2;        // Wall thickness of the tube
bore_diameter = 22.6;        // Inner diameter of the tube
tube_height = 32.0;          // Height of the main tube body

// Floor dimensions
floor_thickness = 1.2;        // Thickness of the bottom floor

// Flare/Collar dimensions
flare_start_z = 26.0;        // Z height where flare begins
flare_end_z = 30.0;          // Z height where flare ends
flare_top_diameter = 33.0;   // Diameter at the top of the flare
rim_height = 32.0;           // Z height of the top rim

// Hole dimensions (for the floor)
hole_diameter = 1.0;         // Diameter of the strainer holes
grid_spacing = 2.0;          // Distance between hole centers (square grid)
max_hole_radius = 10.0;      // Max distance from axis for a hole center

// Vent notch dimensions
notch_width = 3.0;           // Width of the vent notches
notch_cut_radius = 12.5;     // Radius from axis where notches start cutting
notch_start_z = 25.0;        // Z height where notches begin

// Rendering quality
$fn = 64;

// --- Calculations ---
outer_radius = outer_diameter / 2;
bore_radius = bore_diameter / 2;
flare_start_radius = outer_diameter / 2;
flare_end_radius = flare_top_diameter / 2;
rim_radius = flare_top_diameter / 2;

// --- Main Model ---

union() {
    difference() {
        // 1. The Main Body (Tube + Flare + Rim)
        union() {
            // Main Tube Body
            cylinder(h = tube_height, d = outer_diameter);
            
            // Flare (Conical section)
            hull() {
                translate([0, 0, flare_start_z])
                    cylinder(h = 0.01, d = outer_diameter);
                translate([0, 0, flare_end_z])
                    cylinder(h = 0.01, d = flare_top_diameter);
            }
            
            // Top Rim
            translate([0, 0, flare_end_z])
                cylinder(h = rim_height - flare_end_z, d = flare_top_diameter);
        }

        // 2. The Bore (Hollow out the inside)
        // We subtract the bore from z=0 to the top of the tube
        translate([0, 0, -0.01])
            cylinder(h = tube_height + 0.01, d = bore_diameter);

        // 3. Vent Notches
        // Removes material on +X and -X sides to allow air escape
        for (side = [-1, 1]) {
            translate([0, 0, notch_start_z - 0.01])
                rotate([0, 0, 0]) // Placeholder for logic
                // We use a large cube to cut the notch
                // The notch is 3mm wide, so we use a cube of width 100 to ensure it clears
                // We rotate it to align with X axis, but the prompt says "on +X and -X sides"
                // meaning the notch is cut into the side of the cylinder.
                // To cut a notch 3mm wide on the X axis, we rotate the cube.
                // Actually, "3mm wide notches on +X and -X sides" implies the notch 
                // is oriented such that its width is along the Y axis.
                translate([0, 0, 0])
                rotate([0, 0, 0])
                // We use a cylinder or a cube to cut. Let's use a cube.
                // To cut a notch on the side, we place a cube centered on the X axis.
                // The notch width is 3mm (along Y).
                // The notch depth is from notch_cut_radius to infinity.
                translate([notch_cut_radius - 1, -notch_width/2, 0])
                    cube([outer_diameter + 10, notch_width, tube_height + 1]);
                    
            // Wait, the prompt says "on the +X and -X sides". 
            // This usually means the notch is centered on the X axis.
            // Let's refine the notch:
            // It removes material beyond 12.5mm from axis.
            // It is 3mm wide.
        }
        
        // Corrected Vent Notches:
        // We need to cut the collar/rim where R > 12.5.
        // We'll use a difference to remove the outer parts on the X axis.
        // Since it's on +X and -X, we cut two segments.
        for (x_pos = [-1, 1]) {
            translate([0, 0, notch_start_z - 0.01])
            rotate([0, 0, 0])
            // We use a cylinder to cut the notch to ensure it's smooth, 
            // but the prompt says "3mm wide notches". 
            // A cube is better for a "notch".
            // To cut on the +X side:
            // The notch is 3mm wide (Y direction) and cuts from R=12.5 outwards.
            translate([x_pos * notch_cut_radius, -notch_width/2, 0])
                cube([outer_diameter, notch_width, tube_height + 1]);
        }
    }

    // 4. The Floor with Holes
    // We create the floor as a separate solid and subtract holes
    difference() {
        // The floor disk
        cylinder(h = floor_thickness, d = outer_diameter);
        
        // The holes
        // Grid: 2mm square grid, centered on axis.
        // One hole at center.
        // Keep holes whose center is within 10mm of axis.
        // We use a loop from -10 to 10 with step 2.
        for (x = [-10 : grid_spacing : 10]) {
            for (y = [-10 : grid_spacing : 10]) {
                // Check if center is within 10mm of axis
                if (sqrt(x*x + y*y) <= 10.0) {
                    translate([x, y, -0.01])
                        cylinder(h = floor_thickness + 0.02, d = hole_diameter);
                }
            }
        }
    }
}

// Note: The logic above for the floor is inside a union, but it should be 
// part of the main body. Let's restructure the final code to be clean.