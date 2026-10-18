// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions (Specified)
$w_outer = 120; // Width (X)
$d_outer = 70;  // Depth (Y)
$h_outer = 40;  // Height (Z)

// Wall and Floor Thickness
$wall_thick = 3;
$floor_thick = 3;

// Platform Dimensions
$plat_len = 60;   // Length in X
$plat_height = 13; // Height from bed to reach Z=13 (10mm above inner floor at Z=3)

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
// Constructed by taking a solid block and subtracting the top opening.
// The tank rests on the bed at Z=0.
difference() {
    // 1. Solid Block (Outer Dimensions)
    cube([
        $w_outer, 
        $d_outer, 
        $h_outer
    ]);
    
    // 2. Cut out the top opening
    // The opening is the inner dimensions.
    // It starts at the top of the tank (h_outer) and goes down to the top of the floor (floor_thick).
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
// Positioned relative to the tank body.
// It sits on the bed (Z=0) and is 13mm high.
// Top of platform is at Z=13.
translate([
    0, // Centered in X (will be shifted by parent group if needed, but here we center the tank first)
    0, // Centered in Y
    0  // Base on bed
])
cube([
    $plat_len, 
    $d_outer, // Spans full outer width to match tank walls
    $plat_height
]);

// Electrode Holes
// Drilled through the end walls (X ends) at specific Y and Z
// We use a loop to create two holes (left and right ends)
// The tank is centered at X=0, so ends are at X = +/- ($w_outer/2 - $wall_thick)
$hole_offset_x = ($w_outer / 2) - $wall_thick;

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
    }
}