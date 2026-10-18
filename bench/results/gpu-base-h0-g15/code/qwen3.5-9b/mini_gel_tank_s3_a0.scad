// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
$w_outer = 120; // Width (X)
$d_outer = 70;  // Depth (Y)
$h_outer = 40;  // Height (Z)

// Wall and Floor Thickness
$wall_thick = 3;
$floor_thick = 3;

// Platform Dimensions
$plat_len = 60;   // Length in X
$plat_width = $d_outer; // Spans full inner width
$plat_height = 10; // Height above inner floor
$plat_z_base = $floor_thick + $plat_height; // Z position of platform top

// Hole Dimensions
$hole_dia = 2;
$hole_y = 0;
$hole_z = 30;

// Configuration
$fn = 128; // High resolution for smooth curves

// Derived Dimensions
$w_inner = $w_outer - 2*$wall_thick;
$d_inner = $d_outer - 2*$wall_thick;
$h_inner = $h_outer - $floor_thick;

// Main Tank Body (Open Top)
// Constructed by taking a solid block and subtracting the top opening
difference() {
    // 1. Solid Block
    cube([
        $w_outer, 
        $d_outer, 
        $h_outer
    ]);
    
    // 2. Cut out the top opening (Open Top)
    // The opening is the inner dimensions, extending from the top down to the floor thickness
    translate([
        -$wall_thick, 
        -$wall_thick, 
        $h_outer - $floor_thick
    ])
    cube([
        $w_inner, 
        $d_inner, 
        $floor_thick
    ]);
}

// Platform (Raised in the middle)
// Positioned relative to the tank body
translate([
    ($w_outer - $plat_len)/2, // Center in X
    0,                         // Center in Y (aligned with tank center)
    $floor_thick              // Base on the floor
])
difference() {
    // 1. Solid Platform Block
    cube([
        $plat_len, 
        $plat_width, 
        $plat_height
    ]);
    
    // 2. Cut out the top opening of the platform (to match tank opening)
    // The platform is solid up to its top, but the tank opening cuts through it.
    // We need to subtract the volume of the tank opening that overlaps with the platform.
    // Tank opening top is at z = h_outer - floor_thick.
    // Platform top is at z = floor_thick + plat_height.
    // Since the tank is open top, the platform is effectively cut through at the tank's top level.
    
    // Calculate the Z range to cut: from platform top down to the tank opening level
    $cut_start_z = $floor_thick + $plat_height;
    $cut_end_z = $h_outer - $floor_thick;
    
    // If the platform is lower than the tank opening, we don't need to cut the top of the platform
    // because the tank opening is already there. However, the prompt implies the platform divides the bottom.
    // The tank is open at the top. The platform sits inside.
    // The "cut" is actually the tank opening itself.
    // We need to subtract the volume defined by the tank's inner cross-section, 
    // starting from the platform's top surface up to the tank's top opening.
    
    if ($cut_start_z < $cut_end_z) {
        translate([
            -$wall_thick, 
            -$wall_thick, 
            $cut_start_z
        ])
        cube([
            $w_inner, 
            $d_inner, 
            $cut_end_z - $cut_start_z
        ]);
    }
}

// Electrode Holes
// Drilled through the end walls (X ends) at specific Y and Z
// We use a loop to create two holes (left and right ends)
$hole_offset_x = ($w_outer / 2) - ($hole_dia / 2);
$hole_offset_x_left = -$hole_offset_x;
$hole_offset_x_right = $hole_offset_x;

for (side = [1, -1]) {
    translate([
        side * $hole_offset_x,
        $hole_y,
        $hole_z
    ])
    difference() {
        // Create a cylinder that extends slightly past the wall thickness to ensure clean cut
        // Wall thickness is 3mm. We extend 0.5mm past each side.
        $cyl_len = $wall_thick + 1; 
        
        cylinder(
            h = $cyl_len,
            r = $hole_dia / 2,
            $fn = $fn
        );
        
        // Optional: If the hole needs to go all the way through the tank depth (Y), 
        // we would subtract a larger cylinder. The prompt says "horizontal hole along X".
        // Usually, this means a hole through the wall thickness. 
        // If it needs to go through the whole tank depth, the logic changes.
        // "Through each end wall... drill a 2 mm diameter horizontal hole along X"
        // This implies a hole through the 3mm wall.
    }
}