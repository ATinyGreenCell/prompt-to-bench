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
$platform_y = $outer_y; // Spans full inner width
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
// Located in the middle of the tank, spanning full inner width
translate([
    ($outer_x - $platform_x) / 2, 
    $wall_thick, // Positioned at the inner wall Y coordinate
    $floor_thick + $platform_height
]) {
    // Platform Base (matching the void cut logic to ensure it sits flush inside)
    // We model the platform as a solid block that sits inside the tank volume
    // Its bottom is at z = floor_thick + platform_height = 3 + 10 = 13
    // Its top is at z = 44
    // It spans the full inner width (Y)
    
    // To make it a solid part of the tank, we add it to the union of the tank walls
    // However, since we used difference() for the tank, we need to add this platform 
    // as a separate positive object that overlaps with the tank walls.
    
    // Platform Dimensions:
    // X: 60 (centered)
    // Y: Full inner width (64)
    // Z: From 13 to 44 (height 31)
    
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

// We need to cut these holes through the tank walls.
// Since the tank is defined by a difference of a solid and a void, 
// we can simply use difference() again on the whole assembly to cut the holes.
// The holes are cylinders oriented along X.

difference() {
    // Re-create the base tank and platform logic here to ensure the holes cut through everything
    // OR, simpler: Just cut the holes from the existing assembly if we were building incrementally.
    // Since this is a single script, we will rebuild the tank and platform, then subtract the holes.
    
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
        $floor_thick + $platform_height
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