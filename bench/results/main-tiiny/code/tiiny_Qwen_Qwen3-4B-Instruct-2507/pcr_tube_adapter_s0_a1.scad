// Adapter sleeve for 0.2 mL PCR tube in a 1.5 mL rack hole
// Designed to fit 0.2 mL tube into a 1.5 mL rack hole
// Print orientation: collar on z=0 to z=1.5, body from z=1.5 to z=21.5
// Bore: 6.2 mm diameter, full height, open at both ends

$fn = 64;

// Dimensions in millimeters
collar_diameter = 13.0;           // diameter of the collar at z=0 to z=1.5
collar_thickness = 1.5;          // height of collar
sleeve_outer_diameter = 10.8;    // outer diameter of sleeve body (from z=1.5 to z=21.5)
sleeve_height = 20.0;            // height of sleeve body (from z=1.5 to 21.5)
bore_diameter = 6.2;             // diameter of the central bore

// Create the collar (bottom part: cylinder from z=0 to z=1.5)
collar = cylinder(d = collar_diameter / 2, h = collar_thickness, center = true);

// Create the sleeve body (from z=1.5 to z=21.5)
// This is a cylinder of outer diameter 10.8mm, height 20.0mm, centered at origin
sleeve_body = cylinder(d = sleeve_outer_diameter / 2, h = sleeve_height, center = true, translate = [0, 0, 1.5]);

// Create the central bore (6.2mm diameter, full height from z=0 to z=21.5)
bore = cylinder(d = bore_diameter / 2, h = 21.5, center = true);

// Create the full structure: collar + sleeve body (union)
full_sleeve = union() {
    collar;
    sleeve_body;
};

// Final part: full structure minus the central bore
final_adapter = difference() {
    full_sleeve;
    bore;
};

// Output the final adapter
final_adapter;