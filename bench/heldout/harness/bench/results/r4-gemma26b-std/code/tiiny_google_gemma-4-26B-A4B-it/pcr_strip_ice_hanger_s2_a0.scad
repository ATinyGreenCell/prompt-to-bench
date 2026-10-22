// --- Dimensions ---
// Overall extrusion length along X
length_x = 84; 

// Wall thickness gap (target 12.5mm)
gap_width = 12.5; 

// Leg dimensions
leg_thickness = 4;
leg_height = 50;

// Bridge dimensions
bridge_height = 4; // from z=46 to z=50
bridge_thickness = 4; // thickness of the top piece

// Ledge dimensions
ledge_thickness = 6;
ledge_depth = 30; // from y=0 to y=-30

// Tube hole dimensions
hole_diameter = 6.4;
hole_y_pos = -15;
hole_spacing_x = 9;
num_holes = 8;

// --- Parameters ---
$fn = 64;

// --- Modeling ---

// The part is centered on X and Y, resting on Z=0
// The profile is defined in the YZ plane and extruded along X

module profile() {
    difference() {
        // Main U-shape body
        union() {
            // Inner Leg (y = 0 to 4)
            translate([0, 0, 0])
                cube([leg_thickness, leg_thickness, leg_height]);
            
            // Outer Leg (y = 16.5 to 20.5)
            // Note: User specified y=16.5 to 20.5, which is a 4mm thickness
            translate([0, 16.5, 0])
                cube([leg_thickness, 4, leg_height]);
            
            // Bridge (z = 46 to 50)
            // Connects the legs at the top
            translate([0, 0, leg_height - bridge_height])
                cube([leg_thickness, 16.5 + 4, bridge_height]);
        }

        // Subtract the ledge from the bottom of the inner leg
        // The ledge is a separate feature added to the inner leg
        // But to keep the profile clean, we define the ledge as a union below
    }
}

// Final Assembly
union() {
    // 1. The U-profile extruded along X
    // We center the extrusion on X=0, so it goes from -42 to 42
    translate([-length_x/2, 0, 0])
    linear_extrude(height = leg_height) {
        difference() {
            // The outer boundary of the U
            union() {
                // Inner Leg
                square([leg_thickness, leg_height]);
                // Outer Leg
                translate([0, 16.5]) square([leg_thickness, leg_height]);
                // Bridge
                translate([0, 0]) square([leg_thickness, 16.5 + 4]);
            }
            
            // Subtract the gap for the wall (to make it a true U)
            // We extend the subtraction slightly to ensure clean cuts
            translate([0, 4, -1])
                square([leg_thickness + 2, gap_width + 2]);
        }
    }

    // 2. The Ledge (reaches toward -Y from y=0 to y=-30)
    // It is 6mm thick (z=0 to 6) and 84mm long (X)
    translate([-length_x/2, -ledge_depth, 0])
        cube([length_x, ledge_depth, ledge_thickness]);

    // 3. The Tube Holes
    // 8 vertical 6.4mm through-holes in the ledge
    // Centered on X, 9mm apart, at y = -15
    for (i = [0 : num_holes - 1]) {
        // Calculate X position to center the grid of 8 holes
        // Total span = (7 * 9) = 63mm. 
        // Start X = -31.5, End X = 31.5
        x_pos = -31.5 + (i * hole_spacing_x);
        
        translate([x_pos, hole_y_pos, -0.01]) // Extend slightly below Z=0
            cylinder(h = ledge_thickness + 0.02, d = hole_diameter);
    }
}