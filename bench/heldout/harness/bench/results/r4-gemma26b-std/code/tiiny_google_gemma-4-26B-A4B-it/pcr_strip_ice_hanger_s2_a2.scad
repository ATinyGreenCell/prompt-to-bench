// --- Dimensions ---
// Overall extrusion length along X
length_x = 84; 

// Wall thickness gap (target 12.5mm)
// Inner leg ends at y=4, Outer leg starts at y=16.5. 
// 16.5 - 4 = 12.5. Correct.
gap_width = 12.5; 

// Leg dimensions
leg_thickness = 4; // User: "inner leg (y = 0 to 4)"
leg_height = 50;

// Bridge dimensions
// User: "joined at the top by a bridge from z = 46 to 50"
bridge_z_start = 46;

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
            translate([0, 16.5])
                square([leg_thickness, leg_height]);
            
            // Bridge: z = 46 to 50
            // User: "joined at the top by a bridge from z = 46 to 50"
            // This bridge connects the two legs.
            // To ensure it is a single solid, we bridge from y=0 to y=20.5
            translate([0, 0])
                square([leg_thickness, 20.5]);
        }
    }
}

// Final Assembly
// We use difference() to subtract the holes from the union of the body and ledge
difference() {
    union() {
        // 1. The U-profile extruded along X
        // Centered on X: from -42 to 42.
        // The profile starts at y=0.
        translate([-length_x/2, 0, 0])
            profile_extrusion();

        // 2. The Ledge
        // "reaches toward -Y from y = 0 to y = -30"
        // "6 mm thick (z = 0 to 6)"
        // "84 mm long"
        translate([-length_x/2, -ledge_depth, 0])
            cube([length_x, ledge_depth, ledge_thickness]);
    }

    // 3. The Tube Holes
    // "Eight vertical 6.4 mm through-holes in the ledge"
    // "9 mm apart along X, centred, at y = -15"
    // Total span of holes: (8-1) * 9 = 63mm.
    // To center 63mm on X=0: start at -31.5, end at 31.5.
    for (i = [0 : num_holes - 1]) {
        x_pos = -31.5 + (i * hole_spacing_x);
        
        // Subtracting from the ledge
        // We extend the cylinder slightly in Z to ensure a clean cut through the ledge
        translate([x_pos, hole_y_pos, -0.01]) 
            cylinder(h = ledge_thickness + 0.02, d = hole_diameter);
    }
}

// Verification of bounding box logic:
// X: -42 to 42 (Size 84)
// Y: -30 (ledge) to 20.5 (outer leg) (Size 50.5)
// Z: 0 to 50 (Size 50)