// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
$outer_x = 120;
$outer_y = 70;
$outer_z = 40;

// Wall and Floor Thickness
$wall_thick = 3;
$floor_thick = 3;

// Platform Dimensions
$platform_x = 60;
$platform_y = $outer_y; // Spans full outer width to ensure structural integrity and alignment
$platform_height = 10;  // Height above inner floor
$platform_z_top = $outer_z - $wall_thick - $floor_thick + $platform_height; // 40 - 3 - 3 + 10 = 44

// Hole Dimensions
$hole_diameter = 2;
$hole_y = 0;
$hole_z = 30;

// Configuration
$fn = 128; // High resolution for smooth curves and accurate hole sizing

// Derived Dimensions
$inner_x = $outer_x - 2*$wall_thick; // 114
$inner_y = $outer_y - 2*$wall_thick; // 64
$inner_z = $outer_z - $floor_thick;  // 37 (Top of inner floor)

// Main Tank Body
// Constructed as a hollow box with a floor
difference() {
    // Outer Block
    cube([
        $outer_x, 
        $outer_y, 
        $outer_z
    ], center = false);

    // Inner Void (Hollow part)
    // The void starts at the top of the floor and goes up to the top of the tank
    translate([
        $wall_thick, 
        $wall_thick, 
        $floor_thick
    ]) {
        cube([
            $inner_x, 
            $inner_y, 
            $outer_z - $floor_thick
        ], center = false);
    }
    
    // Extend the inner void slightly past the top to ensure clean cut
    translate([
        $wall_thick, 
        $wall_thick, 
        $outer_z + 0.1
    ]) {
        cube([
            $inner_x, 
            $inner_y, 
            1
        ], center = false);
    }
}

// Raised Platform
// Located in the middle of the tank, spanning full width
// It sits on the inner floor (Z=3) and rises 10mm (Top at Z=13)
translate([
    ($outer_x - $platform_x) / 2, 
    $wall_thick, // Positioned at the inner wall Y coordinate
    $floor_thick
]) {
    // Platform Base
    cube([
        $platform_x,
        $inner_y,
        $platform_height
    ], center = false);
    
    // Extend slightly above to ensure it connects seamlessly with the top wall
    translate([
        ($outer_x - $platform_x) / 2,
        $wall_thick,
        $outer_z - $wall_thick + 0.1
    ]) {
        cube([
            $platform_x,
            $inner_y,
            1
        ], center = false);
    }
}

// Electrode Holes
// Two holes, one at each X end, through the end walls
// Position: y = 0, z = 30
// Direction: Along X axis

difference() {
    // Re-create the base tank and platform logic here to ensure the holes cut through everything
    // 1. Tank Body
    difference() {
        cube([
            $outer_x, 
            $outer_y, 
            $outer_z
        ], center = false);
        
        translate([
            $wall_thick, 
            $wall_thick, 
            $floor_thick
        ]) {
            cube([
                $inner_x, 
                $inner_y, 
                $outer_z - $floor_thick
            ], center = false);
            
            // Extend void past top
            translate([
                $wall_thick, 
                $wall_thick, 
                $outer_z + 0.1
            ]) {
                cube([
                    $inner_x, 
                    $inner_y, 
                    1
                ], center = false);
            }
        }
    }
    
    // 2. Platform
    translate([
        ($outer_x - $platform_x) / 2, 
        $wall_thick, 
        $floor_thick
    ]) {
        cube([
            $platform_x,
            $inner_y,
            $platform_height
        ], center = false);
        
        // Extend above
        translate([
            ($outer_x - $platform_x) / 2,
            $wall_thick,
            $outer_z - $wall_thick + 0.1
        ]) {
            cube([
                $platform_x,
                $inner_y,
                1
            ], center = false);
        }
    }
    
    // 3. Cut Holes
    // Left Hole
    translate([
        -$outer_x/2 + $hole_diameter/2, // Centered on left face
        $hole_y,
        $hole_z
    ]) {
        cylinder(
            h = $outer_x + 1, // Extend past both ends
            r = $hole_diameter/2,
            $fn = $fn
        );
    }
    
    // Right Hole
    translate([
        $outer_x/2 - $hole_diameter/2, // Centered on right face
        $hole_y,
        $hole_z
    ]) {
        cylinder(
            h = $outer_x + 1, // Extend past both ends
            r = $hole_diameter/2,
            $fn = $fn
        );
    }
}