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
$p_len = 60;    // Length (X)
$p_width = $d_outer - (2 * $wall_thick); // Spans full inner width (Y)
$p_height = 10; // Height above inner floor
$p_z_base = $floor_thick + $p_height; // Z position of platform top

// Hole Dimensions
$hole_dia = 2;
$hole_y = 0;
$hole_z = 30;

// Configuration
$fn = 128; // High resolution for smooth curves and accurate hole sizing

// Calculate Inner Dimensions
$w_inner = $w_outer - (2 * $wall_thick);
$d_inner = $d_outer - (2 * $wall_thick);
$h_inner = $h_outer - $floor_thick;

// Main Tank Body
// Constructed as a hollow box with a floor
difference() {
    // Outer Block
    cube([
        $w_outer, 
        $d_outer, 
        $h_outer
    ], center = false);
    
    // Cut out the open top and inner void
    // We subtract a block that is the size of the inner void + top opening
    translate([
        -$wall_thick, 
        -$wall_thick, 
        0
    ]) {
        cube([
            $w_inner, 
            $d_inner, 
            $h_outer
        ], center = false);
    }
}

// Raised Platform
// Located in the middle of the tank, spanning full inner width
translate([
    ($w_outer / 2) - ($p_len / 2), // Center in X
    ($d_outer / 2) - ($p_width / 2), // Center in Y
    $floor_thick // Base on the floor
]) {
    // Platform is a solid block
    cube([
        $p_len, 
        $p_width, 
        $p_height
    ], center = false);
}

// Electrode Holes
// Two holes: one at each end wall (X ends), along the X axis
// Position: y = 0, z = 30
// We use a loop to create the two holes at x = -60 and x = 60 (approx ends)
// Actually, the ends are at x = +/- ($w_outer/2 - $wall_thick/2) relative to center?
// No, the hole is "Through each end wall". 
// End walls are at X = -60 and X = +60 (outer edges).
// The hole goes through the wall thickness along X.
// Center of hole in X should be at the inner face of the end wall? 
// Or centered in the wall? Usually centered in the wall thickness.
// Wall thickness is 3mm. So center is at X = +/- (60 - 1.5) = +/- 58.5.

$hole_x_pos = [$w_outer/2 - $wall_thick/2, -$w_outer/2 + $wall_thick/2];

difference() {
    // Re-select the main assembly to cut holes
    // Note: In OpenSCAD, difference() applies to the current context. 
    // We need to rebuild the object or use a temporary variable.
    // Since we cannot use variables for complex unions easily in one pass without re-defining,
    // we will reconstruct the base geometry here specifically for the hole operation.
    
    // 1. Outer Block
    cube([
        $w_outer, 
        $d_outer, 
        $h_outer
    ], center = false);
    
    // 2. Inner Void (Open top)
    translate([
        -$wall_thick, 
        -$wall_thick, 
        0
    ]) {
        cube([
            $w_inner, 
            $d_inner, 
            $h_outer
        ], center = false);
    }
    
    // 3. Platform
    translate([
        ($w_outer / 2) - ($p_len / 2), 
        ($d_outer / 2) - ($p_width / 2), 
        $floor_thick
    ]) {
        cube([
            $p_len, 
            $p_width, 
            $p_height
        ], center = false);
    }
    
    // 4. Cut Holes
    for (i = [0 : 1]) {
        $x = $hole_x_pos[i];
        
        // Cylinder for the hole
        // Extend slightly past the wall thickness to ensure clean cut
        translate([
            $x, 
            $hole_y, 
            $hole_z
        ]) {
            cylinder(
                h = $w_outer + 1, // Extend past both ends
                r = $hole_dia / 2,
                $fn = $fn
            );
        }
    }
}