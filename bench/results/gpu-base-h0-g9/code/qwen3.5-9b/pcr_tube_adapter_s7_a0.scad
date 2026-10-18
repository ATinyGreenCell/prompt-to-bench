// Adapter Sleeve for 0.2mL PCR tube in 1.5mL rack
// Print orientation: Upside down (Collar on bed)
// Units: mm

// Dimensions
$fn = 128; // High resolution for smooth curves

// Collar (Base)
$collar_outer_d = 13;
$collar_thickness = 1.5;
$collar_inner_d = 10.8; // Matches sleeve OD to create a smooth transition

// Sleeve Body
$sleeve_outer_d = 10.8;
$sleeve_total_height = 21.5;
$sleeve_body_height = $sleeve_total_height - $collar_thickness; // 20.0 mm

// Bore
$bore_d = 6.2;
$bore_radius = $bore_d / 2;

// Build parameters
$bed_z = 0;
$collar_z_top = $collar_thickness;
$sleeve_top_z = $sleeve_total_height;

// --- Main Body Construction ---

// 1. Create the Collar (Base)
// Cylinder centered at origin, height = collar_thickness
// We will offset it later to sit on Z=0 if needed, but prompt says "lies on the bed"
// Assuming the user wants the bottom of the collar at Z=0.
// So we translate the cylinder down by half its height.
collar = translate([0, 0, -$collar_thickness/2]) 
    cylinder(h = $collar_thickness, 
             d = $collar_outer_d, 
             center = true);

// 2. Create the Sleeve Body
// Cylinder centered at origin, height = sleeve_body_height
// Positioned so its bottom is at Z = collar_thickness
sleeve_body = translate([0, 0, $collar_thickness]) 
    cylinder(h = $sleeve_body_height, 
             d = $sleeve_outer_d, 
             center = true);

// 3. Create the Bore (Hole)
// A cylinder running through the full height (collar + sleeve)
// Total height = 21.5 mm
// Centered at Z = 10.75 (half of 21.5)
bore = translate([0, 0, $sleeve_total_height/2]) 
    cylinder(h = $sleeve_total_height, 
             d = $bore_d, 
             center = true);

// --- Assembly ---

// Start with the union of Collar and Sleeve Body
part_base = union(
    collar,
    sleeve_body
);

// Subtract the bore
final_part = difference() {
    part_base;
    bore;
};

// Output the final part
// The prompt asks for the part to be built in the orientation described.
// The logic above places the bottom of the collar at Z=0.
// We output the final_part directly.
final_part;