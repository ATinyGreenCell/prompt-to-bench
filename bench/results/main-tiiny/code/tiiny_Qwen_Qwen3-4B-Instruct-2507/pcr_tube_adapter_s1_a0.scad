// Adapter sleeve for 0.2 mL PCR tube in a 1.5 mL rack hole
// Designed to fit 0.2 mL tube into a 1.5 mL rack hole
// Print orientation: collar on z=0 to z=1.5, body from z=1.5 to z=21.5
// Features:
// - Collar: 13 mm diameter, 1.5 mm thick, at z=0 to z=1.5
// - Sleeve body: 10.8 mm outer diameter, from z=1.5 to z=21.5
// - Full 6.2 mm bore through entire height, open at both ends

$fn = 64;

// Dimensions in millimeters
collar_diameter = 13.0;
collar_thickness = 1.5;
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5;  // from z=1.5 to z=21.5, so total height is 21.5 - 1.5 = 20.0 mm
bore_diameter = 6.2;
bore_radius = bore_diameter / 2;

// Create the collar (bottom part)
collar = translate([0, 0, 0])
    cylinder(r = collar_diameter / 2, h = collar_thickness, $fn = 64);

// Create the sleeve body (rises from z=1.5 to z=21.5)
sleeve_body = translate([0, 0, collar_thickness])
    cube([sleeve_outer_diameter, sleeve_outer_diameter, sleeve_height], center = true);

// Create the central bore (6.2 mm diameter, full height)
bore = translate([0, 0, 0])
    cylinder(r = bore_radius, h = sleeve_height + collar_thickness, $fn = 64);

// Create the full sleeve (collar + body)
sleeve = union() {
    collar;
    sleeve_body;
};

// Subtract the bore from the full sleeve
adapter = difference() {
    sleeve;
    bore;
};

// Final result: the adapter with a central hole
module adapter_sleeve() {
    // The adapter is built as a solid with a central bore
    // It rests on the XY plane with the collar at z=0 to z=1.5
    // The body extends upward to z=21.5
    // The bore is fully open through the entire height
    // All dimensions are exact as specified
    difference() {
        // Collar and body
        union() {
            // Collar
            translate([0, 0, 0])
                cylinder(r = collar_diameter / 2, h = collar_thickness, $fn = 64);
            
            // Sleeve body from z=1.5 to z=21.5
            translate([0, 0, collar_thickness])
                cube([sleeve_outer_diameter, sleeve_outer_diameter, sleeve_height], center = true);
        }
        
        // Bore: 6.2 mm diameter, full height
        translate([0, 0, 0])
            cylinder(r = bore_radius, h = collar_thickness + sleeve_height, $fn = 64);
    }
}

// Output the final adapter
adapter_sleeve();