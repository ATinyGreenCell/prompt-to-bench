// Define dimensions
$fn = 64; // For curved shapes

// Collar
collar_diameter = 13;
collar_thickness = 1.5;

// Sleeve body
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5;

// Bore diameter
bore_diameter = 6.2;

// Calculate collar and sleeve dimensions
collar_radius = collar_diameter / 2;
sleeve_radius = sleeve_outer_diameter / 2;
bore_radius = bore_diameter / 2;

// Create collar
collar = cylinder(r=collar_radius, h=collar_thickness, center=true);

// Create sleeve body
sleeve_body = cylinder(r=sleeve_radius, h=sleeve_height, center=true);

// Create bore
bore = cylinder(r=bore_radius, h=sleeve_height, center=true);

// Combine collar and sleeve body
adapter_sleeve = union() {
    collar;
    sleeve_body;
};

// Create bore hole in adapter sleeve
bore_hole = translate([0, 0, -bore_radius]) * cylinder(r=bore_radius, h=2*bore_radius, center=true);

// Combine all parts
final_adapter_sleeve = difference() {
    adapter_sleeve;
    bore_hole;
};

// Print the final adapter sleeve
linear_extrude(height=sleeve_height) {
    final_adapter_sleeve;
};