// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Dimensions in millimetres

// Outer Dimensions
$w_outer = 120; // Width (X)
$d_outer = 70;  // Depth (Y)
$h_outer = 40;  // Height (Z)

// Wall and Floor Thickness
$w_thick = 3;   // Wall thickness
$f_thick = 3;   // Floor thickness

// Platform Dimensions
$p_len = 60;    // Platform length (X)
$p_height = 10; // Platform height above inner floor

// Hole Dimensions
$h_dia = 2;     // Hole diameter
$h_y = 0;       // Hole Y position
$h_z = 30;      // Hole Z position

// Configuration
$fn = 128;      // Facets for smooth curves

// Derived Dimensions
$w_inner = $w_outer - 2*$w_thick;
$d_inner = $d_outer - 2*$w_thick;
$h_inner = $h_outer - $f_thick;

// Calculate Platform Width (spans full inner width)
$p_width = $d_inner;

// Main Tank Body (Hollow Box)
// Constructed as a solid block with a void subtracted
translate([0, 0, 0])
difference() {
    // Outer Solid Block
    cube([
        $w_outer, 
        $d_outer, 
        $h_outer
    ], center = false);
    
    // Inner Void (The empty space for buffer)
    // Starts at z = floor thickness
    translate([
        $w_thick, 
        $w_thick, 
        $f_thick
    ])
    cube([
        $w_inner, 
        $d_inner, 
        $h_inner
    ], center = false);
}

// Raised Platform
// Positioned in the middle of the tank, spanning full inner width
// It sits on the floor (z = f_thick) and extends up to z = f_thick + p_height
translate([
    ($w_outer - $p_len) / 2, // Center X
    $w_thick,               // Start at inner wall Y
    $f_thick                // Bottom at floor level
])
cube([
    $p_len, 
    $p_width, 
    $p_height
], center = false);

// Electrode Holes
// Drilled through the end walls at y=0, z=30 along X axis
// We need to cut a cylinder through the solid walls at the ends.
// The tank ends are at x = 0 and x = $w_outer.
// The hole is at y=0 (inner surface of the side wall? or center?).
// "through each end wall... at y = 0". Since the tank is 70mm deep and walls are 3mm,
// y=0 is the inner surface of the front wall.
// The hole runs along X.
// We will cut cylinders centered at the ends of the tank.

// Left End Hole
translate([
    $w_thick, // Center X on the left wall face
    $w_thick, // Center Y on the inner face (y=0 relative to outer, but we are at x=$w_thick)
    $h_z      // Center Z
])
difference() {
    // Cut a cylinder through the left wall
    cylinder(
        h = $w_thick + 1, // Extend slightly past the wall thickness
        r = $h_dia / 2,
        $fn = $fn
    );
}

// Right End Hole
translate([
    $w_outer - $w_thick, // Center X on the right wall face
    $w_thick, // Center Y on the inner face
    $h_z      // Center Z
])
difference() {
    // Cut a cylinder through the right wall
    cylinder(
        h = $w_thick + 1, // Extend slightly past the wall thickness
        r = $h_dia / 2,
        $fn = $fn
    );
}