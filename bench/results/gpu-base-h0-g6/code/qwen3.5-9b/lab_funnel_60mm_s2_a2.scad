// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel)
// Starts at z = $spout_length, ends at z = $spout_length + $cone_height
$cone_bottom_diameter = 10; // Matches spout outer diameter at z=20
$cone_top_diameter = 60;    // Rim diameter at z=50
$cone_height = 30;          // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for curved surfaces
$fn = 64;

// --- Helper Module for Hollow Cylinder ---
// Creates a cylinder with a hole through the center.
// The inner cylinder extends 0.1mm past the outer height to ensure a clean cut.
module hollow_cylinder(outer_d, inner_d, h) {
    difference() {
        cylinder(d = outer_d, h = h, $fn = $fn);
        cylinder(d = inner_d, h = h + 0.1, $fn = $fn);
    }
}

// --- Helper Module for Hollow Frustum (Cone with tip cut) ---
// Creates a frustum with specified bottom and top diameters and height.
// The inner frustum extends 0.1mm past the outer height to ensure a clean cut.
// Orientation: Bottom at z=0, Top at z=height.
module hollow_frustum(bottom_d, top_d, h) {
    // Calculate the virtual tip of the cone to use for subtraction
    // Slope = (top_radius - bottom_radius) / height
    // Distance from bottom to tip = bottom_radius / slope
    $r_bottom = bottom_d / 2;
    $r_top = top_d / 2;
    $slope = ($r_top - $r_bottom) / h;
    $tip_offset = $r_bottom / $slope;
    
    // Total height of the virtual cone from the tip to the top rim
    $virtual_height = h + $tip_offset;
    
    difference() {
        // Outer Frustum: Large Cone - Small Cone (tip)
        // Large Cone: Radius = $r_top, Height = $virtual_height
        // Small Cone: Radius = $r_bottom, Height = $tip_offset
        // Position: Tip at z = -$tip_offset, Top at z = h
        
        // Outer Large Cone
        cylinder(d = top_d, h = $virtual_height, center = [0, 0, $virtual_height/2 - $tip_offset], $fn = $fn);
        
        // Outer Small Cone (tip)
        cylinder(d = bottom_d, h = $tip_offset, center = [0, 0, -$tip_offset/2], $fn = $fn);
        
        // Inner Large Cone (hole)
        cylinder(d = top_d, h = $virtual_height, center = [0, 0, $virtual_height/2 - $tip_offset], $fn = $fn);
        
        // Inner Small Cone (hole tip)
        cylinder(d = bottom_d, h = $tip_offset, center = [0, 0, -$tip_offset/2], $fn = $fn);
    }
}

// --- Main Construction ---
// We build the solid outer shell and subtract the inner hole in one go to ensure perfect alignment.
// However, to keep the code modular and clear, we will build the outer volume and then subtract the inner volume.

// Calculate inner diameters
$inner_spout_d = $spout_inner_diameter;
$inner_cone_bottom_d = $cone_bottom_diameter - 2*$wall_thickness;
$inner_cone_top_d = $cone_top_diameter - 2*$wall_thickness;

// Extend inner dimensions slightly to ensure clean cuts
$ext = 0.1;
$inner_spout_d_ext = $inner_spout_d + 2*$ext;
$inner_cone_bottom_d_ext = $inner_cone_bottom_d + 2*$ext;
$inner_cone_top_d_ext = $inner_cone_top_d + 2*$ext;

// Start with the outer solid volume
union() {
    // 1. Spout (Cylinder)
    cylinder(d = $spout_outer_diameter, h = $spout_length, center = [0, 0, $spout_length/2], $fn = $fn);
    
    // 2. Funnel (Frustum)
    // Positioned from z = $spout_length to z = $spout_length + $cone_height
    hollow_frustum(
        bottom_d = $cone_bottom_diameter,
        top_d = $cone_top_diameter,
        h = $cone_height
    );
}

// Subtract the inner hole volume
difference() {
    // The union above is the base. We subtract the holes.
    // Since we are inside a difference(), we just define the shapes to subtract.
    
    // 1. Spout Hole
    cylinder(d = $inner_spout_d_ext, h = $spout_length, center = [0, 0, $spout_length/2], $fn = $fn);
    
    // 2. Funnel Hole
    // Positioned from z = $spout_length to z = $spout_length + $cone_height
    hollow_frustum(
        bottom_d = $inner_cone_bottom_d_ext,
        top_d = $inner_cone_top_d_ext,
        h = $cone_height
    );
}