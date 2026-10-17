// Adapter Sleeve for 0.2mL PCR Tube in 1.5mL Rack
// Print Orientation: Upside down (Collar on bed)
// Units: mm

// Dimensions
$fn = 128; // High resolution for smooth curves

// Collar (Base)
$collar_diameter = 13;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_outer_diameter = 10.8;
$sleeve_total_height = 21.5;
$sleeve_body_height = $sleeve_total_height - $collar_thickness;

// Bore
$bore_diameter = 6.2;

// Offset for cutting operations (Rule 5)
$cut_offset = 0.1;

// --- Main Block Construction ---

// 1. Create the Collar (Base)
// Lies on XY plane, centered at origin
collar = translate([0, 0, 0])
    cylinder(h = $collar_thickness, d = $collar_diameter, center = true);

// 2. Create the Sleeve Body
// Starts at z = $collar_thickness, ends at z = $sleeve_total_height
// Outer diameter is $sleeve_outer_diameter
// Bore is $bore_diameter
sleeve_body = translate([0, 0, $collar_thickness])
    cylinder(h = $sleeve_body_height, 
             d = $sleeve_outer_diameter, 
             d2 = $bore_diameter, 
             center = true);

// 3. Create the Bore through the Collar
// The bore must extend slightly past the collar faces to ensure clean cutting
// Top of collar is at z = $collar_thickness
// Bottom of collar is at z = 0
bore_in_collar = translate([0, 0, $collar_thickness + $cut_offset])
    cylinder(h = $collar_thickness + ($cut_offset * 2), 
             d = $bore_diameter, 
             center = true);

// 4. Create the Bore through the Sleeve Body
// The bore must extend slightly past the sleeve body faces
// Top of sleeve body is at z = $sleeve_total_height
// Bottom of sleeve body is at z = $collar_thickness
bore_in_body = translate([0, 0, $collar_thickness - $cut_offset])
    cylinder(h = $sleeve_body_height + ($cut_offset * 2), 
             d = $bore_diameter, 
             center = true);

// --- Assembly ---

// Combine Collar and Sleeve Body
main_shape = union(
    collar,
    sleeve_body
);

// Subtract the bores
final_part = difference(
    main_shape,
    bore_in_collar,
    bore_in_body
);

// Render the final part
final_part;