// Dimensions for PCR tube adapter sleeve (0.2 mL tube in 1.5 mL rack hole)
// All units in millimeters

// Collar dimensions (base resting on bed)
collar_diameter = 13;
collar_height = 1.5;

// Sleeve body dimensions (rises from collar)
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5 - collar_height; // Total height 21.5, collar is 1.5

// Bore dimensions (straight hole through full height)
bore_diameter = 6.2;

// Print orientation: Collar on XY plane (z=0), builds upward
// Centered on origin in X and Y

// Define the collar
collar = cylinder(d = collar_diameter, h = collar_height, center = false);

// Define the sleeve body (cylinder on top of collar)
sleeve_body = cylinder(d = sleeve_outer_diameter, h = sleeve_height, center = false);

// Define the bore (cylinder to subtract, slightly larger to ensure clearance)
// Using 6.21 to ensure 0.01mm clearance past the face as per rule 5
bore = cylinder(d = bore_diameter + 0.01, h = 21.5 + 0.01, center = false);

// Union collar and sleeve body
adapter_body = union(
    translate([0, 0, 0]) collar,
    translate([0, 0, collar_height]) sleeve_body
);

// Subtract the bore from the combined body
adapter = difference(
    adapter_body,
    translate([0, 0, -0.01]) bore // Extend slightly below z=0 to ensure clean cut
);

// Final output
adapter;