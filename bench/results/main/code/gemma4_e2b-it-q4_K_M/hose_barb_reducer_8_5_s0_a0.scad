// Dimensions
hose_length = 41;      // Total height of the part (Z dimension)
bore_diameter = 3;       // Diameter of the central bore
barb1_height = 10;       // Height of the 8mm tubing barbs (Z range: 0 to 10)
collar_height = 5;      // Height of the collar section (Z range: 20 to 25)
barb2_height = 16;       // Height of the 5mm tubing barbs (Z range: 25 to 41)

// Barb 1 (8mm tubing) dimensions
barb1_bottom_od = 7.5;   // Outer diameter at the bottom of barb 1
barb1_top_od = 9.5;      // Outer diameter at the top of barb 1
barb1_step_od = 7.5;     // Outer diameter at the step back (sawtooth)

// Barb 2 (5mm tubing) dimensions
barb2_bottom_od = 6.5;   // Outer diameter at the bottom of barb 2
barb2_top_od = 5.0;      // Outer diameter at the top of barb 2
barb2_step_od = 6.5;     // Outer diameter at the step out (sawtooth)

collar_diameter = 12;    // Diameter of the cylindrical collar

// Feature parameters
bore_radius = bore_diameter / 2;
fn = 64; // Resolution for curved shapes

module create_barb(z_start, height, bottom_od, top_od, step_od) {
    // Calculate linear interpolation factors based on the barb height
    t_bottom = 0;
    t_top = 1;

    // Function to calculate outer diameter at a given Z position within the barb section
    calculate_od = (z) => {
        if (z >= z_start && z <= z_start + height) {
            // Linear interpolation for growth/shrinkage
            t = (z - z_start) / height;
            return bottom_od + t * (top_od - bottom_od);
        } else if (z > z_start + height && z <= z_start + height + 1) {
             // Step back to the step diameter (assuming a small transition zone for simplicity, though description implies a sharp step)
            return step_od;
        } else {
            // Return a safe value or handle outside range if necessary, but for this structure, we focus on the main body.
            return 0; // Should not be reached in the main loop context
        }
    };

    // Create the main barb shape using hull/cylinder approximation for smooth transition (or simple cylinder sweep)
    // Since the profile is defined by linear growth and a step, we use a series of stacked cylinders or a hull.
    
    // For simplicity and robustness in FDM printing, we model this as a swept shape or stack of profiles.
    // Given the description "outer diameter grows linearly... then steps straight back", we will approximate with stacked sections.

    // Section 1: Linear growth (Bottom to Top)
    barb_linear = linear_extrude(height, circle(d = bottom_od));
    
    // We need a way to define the profile change precisely. Since OpenSCAD doesn't easily handle complex profiles defined by functions over Z, 
    // we will use a series of stacked shapes or rely on hull for approximation if the shape is truly revolutionally symmetric.
    
    // Let's model the entire barb as a single revolved shape defined by its profile in the R-Z plane.
    
    // Define the cross-section profile (R vs Z) for one side of the barb
    profile_points = [
        [0, z_start], // Start point (center line)
        [bottom_od / 2, z_start + height/3], // Mid point approximation
        [top_od / 2, z_start + 2*height/3], // Mid point approximation
        [step_od / 2, z_start + height] // End point (step back)
    ];

    // Since the description implies a smooth linear growth followed by a step, we will use hull for a general shape if the profile is complex.
    // However, to ensure the bore passes through and the outer diameter is correct, we define the outer boundary.

    // Create the main body (approximated as a cylinder with varying radius)
    barb_body = rotate_extrude(360)
        (
            linear_extrude(height, 
                offset = bottom_od / 2, // Start radius
                points = [
                    [0, z_start],
                    [bottom_od / 2, z_start + height/4],
                    [top_od / 2, z_start + 3*height/4],
                    [step_od / 2, z_start + height]
                ]
            )
        );

    // Create the inner bore cutout (must be centered)
    bore_cutout = cylinder(r = bore_radius, h = height + 1, $fn = fn);


    // Combine them. Since we are building a reducer, we assume the barb is an extrusion around the central axis.
    // We use difference to cut the hole from the solid shape defined by the outer profile.
    union() {
        barb_body;
        difference() {
            bore_cutout;
        }
    }
}


// --- Main Assembly ---

// 1. Central Bore (runs full length)
central_bore = cylinder(r = bore_radius, h = hose_length, $fn = fn);

// 2. Barb 1 (Z=0 to Z=10)
barb1_z_start = 0;
barb1_body = create_barb(barb1_z_start, barb1_height, barb1_bottom_od, barb1_top_od, barb1_step_od);

// 3. Collar (Z=20 to Z=25)
collar = cylinder(r = collar_diameter / 2, h = collar_height, $fn = fn);

// 4. Barb 2 (Z=25 to Z=41)
barb2_z_start = 25;
barb2_body = create_barb(barb2_z_start, barb2_height, barb2_bottom_od, barb2_top_od, barb2_step_od);


// Combine all parts
union() {
    central_bore;
    barb1_body;
    collar;
    barb2_body;
}