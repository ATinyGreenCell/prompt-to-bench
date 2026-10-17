// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
$w_outer = 120; // X width
$d_outer = 70;  // Y depth
$h_outer = 40;  // Z height

// Wall and Floor Thickness
$wall_thick = 3;
$floor_thick = 3;

// Platform Dimensions
$plat_len = 60;   // Length in X
$plat_width = $d_outer; // Spans full outer width (effectively inner width + walls)
$plat_height = 10; // Height above inner floor

// Hole Dimensions
$hole_dia = 2;
$hole_y = 0;
$hole_z = 30;

// Configuration
$fn = 64;

// Derived Dimensions
$inner_w = $w_outer - 2*$wall_thick;
$inner_d = $d_outer - 2*$wall_thick;
$inner_h = $h_outer - $floor_thick;
$plat_z_top = $floor_thick + $plat_height;

// Main Tank Construction
difference() {
    // 1. Create the solid outer block
    translate([0, 0, 0])
    cube([$w_outer, $d_outer, $h_outer], center=false);

    // 2. Cut the top opening (open-top tank)
    // Cut slightly below the top surface to ensure clean edges
    translate([0, 0, $h_outer - 0.01])
    cube([$w_outer, $d_outer, 1], center=false);

    // 3. Cut the main internal cavity (the empty space for buffer)
    // This block represents the void inside the tank walls and above the floor.
    // Position: Starts at inner wall coordinates, goes up to the top of the walls.
    translate([$wall_thick, $wall_thick, $floor_thick])
    cube([$inner_w, $inner_d, $inner_h], center=false);

    // 4. Cut the Platform Void
    // The platform is a solid object inside the tank. We must subtract its volume.
    // Position:
    // X: Centered ($w_outer/2 - $plat_len/2)
    // Y: Spans the full inner width ($wall_thick to $d_outer - $wall_thick)
    // Z: From the top of the floor ($floor_thick) to the top of the platform ($plat_z_top)
    translate([
        ($w_outer - $plat_len)/2, 
        $wall_thick, 
        $floor_thick
    ])
    cube([$plat_len, $inner_d, $plat_height], center=false);

    // 5. Cut Electrode Holes
    // Drill 2mm diameter holes through the end walls at y=0, z=30 along X axis.
    // The hole goes through the wall thickness.
    
    // Left Hole (at negative X end)
    // Center X is at the inner face of the left wall? 
    // No, the hole is in the "end wall". The end wall is at X = +/- ($w_outer/2 - $wall_thick/2).
    // The hole is horizontal along X, so it passes through the wall thickness.
    // Center X = +/- ($w_outer/2 - $wall_thick/2)
    // Center Y = $hole_y (0)
    // Center Z = $hole_z (30)
    // Length = $wall_thick (to go through the wall)
    
    // Left Hole
    translate([
        -$w_outer/2 + $wall_thick/2, 
        $hole_y,
        $hole_z
    ])
    cylinder(h=$wall_thick, r=$hole_dia/2, $fn=$fn);
    
    // Right Hole
    translate([
        $w_outer/2 - $wall_thick/2, 
        $hole_y,
        $hole_z
    ])
    cylinder(h=$wall_thick, r=$hole_dia/2, $fn=$fn);
}