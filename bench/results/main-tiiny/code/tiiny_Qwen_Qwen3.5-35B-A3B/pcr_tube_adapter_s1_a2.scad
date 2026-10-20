// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Dimensions measured in mm

// Collar dimensions
collar_diameter = 13;
collar_thickness = 1.5;

// Sleeve body dimensions
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5 - collar_thickness; // Total height 21.5, collar takes 1.5

// Bore dimensions
bore_diameter = 6.2;

// Build orientation: Collar on XY plane (z=0 to 1.5), sleeve rises from there
// Centered on origin in X and Y

// Define the collar base
collar = cylinder(d = collar_diameter, h = collar_thickness, center = false);

// Define the sleeve body
sleeve_body = cylinder(d = sleeve_outer_diameter, h = sleeve_height, center = false);

// Define the bore (hole)
// The bore runs through the full height (21.5 mm)
// We create a cylinder that extends slightly past the top and bottom to ensure clean cuts
bore = cylinder(d = bore_diameter, h = 21.5 + 0.02, center = false);

// Combine collar and sleeve body
adapter_body = union() {
    translate([0, 0, 0]) collar;
    translate([0, 0, collar_thickness]) sleeve_body;
};

// Subtract the bore from the combined body
// The bore cylinder is slightly taller to ensure it cuts through completely without coplanar faces
final_part = difference() {
    adapter_body;
    translate([0, 0, -0.01]) bore; // Extend slightly below z=0
};

// Render the final part
render() {
    final_part;
}