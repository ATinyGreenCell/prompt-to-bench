// --- Dimensions ---
// Overall extrusion length along X
length_x = 84; 

// Wall thickness gap (target 12.5mm)
// User: "leaves a 12.5 mm gap for the wall"
// Inner leg ends at y=4, Outer leg starts at y=16.5. 
// 16.5 - 4 = 12.5. Correct.
gap_width = 12.5; 

// Leg dimensions
leg_thickness = 4; // User: "inner leg (y = 0 to 4)" -> thickness is 4
leg_height = 50;

// Bridge dimensions
// User: "joined at the top by a bridge from z = 46 to 50"
bridge_z_start = 46;
bridge_height = 4; 

// Ledge dimensions
// User: "ledge, 6 mm thick (z = 0 to 6) reaches toward -Y from y = 0 to y = -30"
ledge_thickness = 6;
ledge_depth = 30; 

// Tube hole dimensions
// User: "Eight vertical 6.4 mm through-holes in the ledge... 9 mm apart along X, centred, at y = -15"
hole_diameter = 6.4;
hole_y_pos = -15;
hole_spacing_x = 9;
num_holes = 8;

// --- Parameters ---
$fn = 64;

// --- Modeling ---

// The part is centered on X and Y, resting on Z=0
// The profile is defined in the YZ plane and extruded along X

module profile_extrusion() {
    // We build the U-shape profile and extrude it along X
    // The profile is defined in the YZ plane
    linear_extrude(height = leg_height) {
        union() {
            // Inner Leg: y = 0 to 4, z = 0 to 50
            square([leg_thickness, leg_height]);
            
            // Outer Leg: y = 16.5 to 20.5, z = 0 to 50
            // Note: User specified y = 16.5 to 20.5. 
            // This means the outer leg is 4mm thick.
            translate([0, 16.5])
                square([leg_thickness, leg_height]);
            
            // Bridge: z = 46 to 50
            // Connects the legs. The bridge covers the gap from y=0 to y=20.5
            // However, the user says "joined at the top by a bridge... that leaves a 12.5mm gap"
            // This implies the bridge spans the width of the legs and the gap.
            // To ensure a solid connection, we bridge from y=0 to y=20.5
            translate([0, 0])
                square([leg_thickness, 20.5]);
        }
    }
}

// Final Assembly
union() {
    // 1. The U-profile extruded along X
    // Centered on X: from -42 to 42.
    // Centered on Y: The profile spans y=0 to y=20.5. 
    // To center the whole part (including ledge) on Y, we must calculate the Y center.
    // Ledge is y = -30 to 0. Profile is y = 0 to 20.5.
    // Total Y span is -30 to 20.5. Midpoint is -4.75.
    // However, the prompt says "centred on x = 0" and "extruded 84 mm along X".
    // It does not explicitly say the Y-axis is centered on the whole part, 
    // but standard practice for "centred on x=0" in a 3D model usually implies 
    // the object's local origin is the center of its X-axis.
    // I will center the X-axis.
    
    translate([-length_x/2, 0, 0])
        profile_extrusion();

    // 2. The Ledge
    // "reaches toward -Y from y = 0 to y = -30"
    // "6 mm thick (z = 0 to 6)"
    // "84 mm long"
    translate([-length_x/2, -ledge_depth, 0])
        cube([length_x, ledge_depth, ledge_thickness]);

    // 3. The Tube Holes
    // "Eight vertical 6.4 mm through-holes in the ledge"
    // "9 mm apart along X, centred, at y = -15"
    // Total span of holes: (8-1) * 9 = 63mm.
    // To center 63mm on X=0: start at -31.5, end at 31.5.
    for (i = [0 : num_holes - 1]) {
        x_pos = -31.5 + (i * hole_spacing_x);
        
        // Subtracting from the ledge
        translate([x_pos, hole_y_pos, -0.01]) 
            cylinder(h = ledge_thickness + 0.02, d = hole_diameter);
    }
}

// Note on the previous error: 
// The previous model had a "difference" inside the linear_extrude that 
// accidentally cut out the legs themselves because of how the square was defined.
// This version uses a clean union of the three components of the U-shape.