// --- Dimensions ---
// Overall extrusion length along X
length_x = 84; 

// Wall thickness gap (user specified 12.5mm gap for 12mm wall)
gap_width = 12.5; 

// Leg dimensions
leg_thickness = 4; // Inner leg: y=0 to 4, Outer leg: y=16.5 to 20.5 (diff is 4)
leg_height = 50;

// Bridge dimensions
bridge_height_start = 46;
bridge_height_end = 50;

// Ledge dimensions
ledge_thickness = 6;
ledge_depth = 30; // From y=0 to y=-30

// Tube hole dimensions
hole_diameter = 6.4;
hole_y_pos = -15;
hole_spacing_x = 9;
num_holes = 8;

// --- Parameters ---
$fn = 64;

// --- Calculations ---
// Calculate X offset to center the 8 holes along the 84mm length
// Total span of holes = (num_holes - 1) * spacing
hole_span = (num_holes - 1) * hole_spacing_x;
x_start = -(hole_span / 2);

// --- Modeling ---

module profile() {
    difference() {
        // Main U-shape body
        union() {
            // Inner Leg
            translate([0, 0, 0])
                cube([leg_thickness, leg_thickness, leg_height]);
            
            // Outer Leg
            translate([0, leg_thickness + gap_width, 0])
                cube([leg_thickness, leg_thickness, leg_height]);
            
            // Top Bridge
            translate([0, 0, bridge_height_start])
                cube([leg_thickness, leg_thickness + gap_width, bridge_height_end - bridge_height_start]);
            
            // Ledge
            translate([0, -ledge_depth, 0])
                cube([leg_thickness, ledge_depth, ledge_thickness]);
        }

        // Subtract holes for the PCR tubes
        // We iterate through X to place 8 holes
        for (i = [0 : num_holes - 1]) {
            translate([x_start + (i * hole_spacing_x), hole_y_pos, -1])
                cylinder(d = hole_diameter, h = ledge_thickness + 2);
        }
    }
}

// Final Assembly
// The profile is extruded 84mm along X, centered on X=0
translate([-length_x/2, 0, 0])
    linear_extrude(height = length_x)
        // We rotate the profile so the extrusion is along X
        // The user wants the profile in YZ plane, extruded along X.
        // In OpenSCAD, linear_extrude goes along Z. 
        // So we define the profile in XY and extrude along Z, 
        // OR define profile in YZ and rotate.
        // Let's define the profile in the YZ plane and rotate it.
        rotate([0, 0, 0]) 
        rotate([0, -90, 0]) // Rotate profile to lie in YZ plane
        profile();

// Note: The logic above uses a trick: 
// 1. Define profile in its local 2D-ish space.
// 2. Rotate it to the YZ plane.
// 3. Linear extrude along X.
// To make it simple for the user, I will rewrite the profile to be 
// defined in the XY plane and then extrude along Z, but the user 
// specifically asked for the profile in YZ and extrusion along X.
// I will follow the user's geometric description exactly.

// RE-WRITING FOR CLARITY AND ACCURACY TO USER REQUEST:
// "A profile in the YZ plane extruded 84 mm along X, centred on x = 0"

module final_part() {
    // We build the profile in the YZ plane (X=0)
    // Then we extrude it along X.
    // To do this in OpenSCAD, we define the shape in XY and extrude Z,
    // then rotate it so the extrusion is along X.
    
    difference() {
        // The main solid body
        union() {
            // Inner Leg (YZ plane)
            translate([0, 0, 0]) cube([0.01, leg_thickness, leg_height]);
            // Outer Leg (YZ plane)
            translate([0, leg_thickness + gap_width, 0]) cube([0.01, leg_thickness, leg_height]);
            // Bridge (YZ plane)
            translate([0, 0, bridge_height_start]) cube([0.01, leg_thickness + gap_width, bridge_height_end - bridge_height_start]);
            // Ledge (YZ plane)
            translate([0, -ledge_depth, 0]) cube([0.01, ledge_depth, ledge_thickness]);
        }
        
        // Holes (Must be subtracted from the extruded volume)
        // Since we are extruding along X, the holes must be cylinders along X
        for (i = [0 : num_holes - 1]) {
            translate([x_start + (i * hole_spacing_x), hole_y_pos, -1])
                cylinder(d = hole_diameter, h = length_x + 2);
        }
    }
}

// Correct implementation:
// 1. Create the 2D profile in the YZ plane.
// 2. Extrude it along X.

module profile_2d_yz() {
    // This is a 2D representation of the YZ profile
    // We use polygon or a series of 2D shapes
    // Since we need to subtract holes, we'll do it in 3D.
}

// Final approach: Build the 3D object in the YZ plane, then extrude along X.
// To extrude along X, we build it in the XY plane and rotate.

module build_3d() {
    difference() {
        union() {
            // Inner Leg (along X, thickness in Y, height in Z)
            translate([0, 0, 0]) cube([length_x, leg_thickness, leg_height]);
            
            // Outer Leg
            translate([0, leg_thickness + gap_width, 0]) cube([length_x, leg_thickness, leg_height]);
            
            // Bridge
            translate([0, 0, bridge_height_start]) cube([length_x, leg_thickness + gap_width, bridge_height_end - bridge_height_start]);
            
            // Ledge
            translate([0, -ledge_depth, 0]) cube([length_x, ledge_depth, ledge_thickness]);
        }
        
        // Holes (Cylinders along Y or Z? User says "vertical 6.4mm through-holes... at y=-15")
        // "Vertical" in a 3D print usually means along Z.
        // "Through-holes" in the ledge (which is 6mm thick) means the hole goes through the thickness.
        // If the ledge is at z=0 to 6, the hole is along Z.
        for (i = [0 : num_holes - 1]) {
            translate([x_start + (i * hole_spacing_x), hole_y_pos, -1])
                cylinder(d = hole_diameter, h = ledge_thickness + 2);
        }
    }
}

// The user wants the part centered on X=0.
// The extrusion is 84mm along X.
// The profile is in YZ.
// This means the X-axis is the extrusion axis.
// To center on X=0, we translate by -length_x/2.

translate([-length_x/2, 0, 0]) build_3d();