// --- Dimensions ---
// Overall extrusion length along X axis
length_x = 84; 

// Wall thickness of the bucket
wall_thickness = 12; 

// Vertical height of the legs
leg_height = 50; 

// Thickness of the top bridge
bridge_thickness = 4; 

// Width of the legs (Y-axis dimension)
leg_width = 4; 

// Gap between legs (should be slightly larger than wall thickness)
gap_width = 12.5; 

// Ledge thickness (Z-axis dimension)
ledge_thickness = 6; 

// Ledge depth (Y-axis dimension)
ledge_depth = 30; 

// PCR tube hole diameter
hole_diameter = 6.4; 

// PCR tube hole spacing (X-axis)
hole_spacing_x = 9; 

// Number of tubes
num_tubes = 8; 

// Number of tubes Y-position (offset from origin)
hole_y_pos = -15; 

// Smoothness for cylinders
fn_val = 64;

// --- Implementation ---

// The part is built in the print orientation: rests on XY plane at Z=0.
// The profile is defined in the YZ plane and extruded along X.

module holder_profile() {
    difference() {
        // Main U-shape body
        union() {
            // Inner Leg (y = 0 to 4)
            translate([0, 0, 0])
                cube([leg_width, 4, leg_height]);
            
            // Outer Leg (y = 16.5 to 20.5)
            // Note: User specified y=16.5 to 20.5. 
            // This implies a gap of 16.5 - 4 = 12.5mm.
            translate([0, 16.5, 0])
                cube([leg_width, 4, leg_height]);
            
            // Top Bridge (z = 46 to 50)
            // Connects the two legs
            translate([0, 0, leg_height - bridge_thickness])
                cube([leg_width, 20.5, bridge_thickness]);
        }

        // Ledge subtraction/addition logic:
        // The user wants a ledge from y=0 to y=-30, z=0 to z=6.
        // Since we are building the main body, we add the ledge as a union 
        // or define the profile carefully. Let's use union for the ledge.
    }
}

// Corrected approach: Build the solid profile and then extrude.
module profile_shape() {
    union() {
        // Inner Leg
        translate([0, 0, 0]) cube([leg_width, 4, leg_height]);
        // Outer Leg
        translate([0, 16.5, 0]) cube([leg_width, 4, leg_height]);
        // Top Bridge
        translate([0, 0, leg_height - bridge_thickness]) cube([leg_width, 20.5, bridge_thickness]);
        // Ledge
        translate([0, -ledge_depth, 0]) cube([leg_width, ledge_depth, ledge_thickness]);
    }
}

// Final Assembly
difference() {
    // Main Body extruded along X
    translate([-length_x/2, 0, 0])
        linear_extrude(height = length_x)
            profile_shape();

    // Tube Holes
    // Holes are 6.4mm diameter, vertical (Z-axis), 
    // centered on X, at y = -15, through the ledge.
    // We extend the hole in Z to ensure a clean cut.
    for (i = [0 : num_tubes - 1]) {
        // Calculate X offset to center the 8 holes
        // Total span = (7 * 9) = 63. 
        // Center of span is at (63/2) = 31.5.
        // We want the group centered on X=0.
        x_offset = (i * hole_spacing_x) - ((num_tubes - 1) * hole_spacing_x / 2);
        
        translate([x_offset, hole_y_pos, -1]) // -1 to ensure cut through bottom
            cylinder(h = ledge_thickness + 2, d = hole_diameter, $fn = fn_val);
    }
}

// Note: The user requested the profile to be extruded 84mm along X, 
// centered on X=0. This means X goes from -42 to 42.
// The code above uses translate([-length_x/2, 0, 0]) to achieve this.