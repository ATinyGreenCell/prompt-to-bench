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
$platform_len = 60;      // Length in X
$platform_width = $outer_y - 2 * $wall_thick; // Matches inner width
$platform_height = 10;   // Height above inner floor
$platform_z_bottom = $floor_thick; // Z position of platform bottom
$platform_z_top = $platform_z_bottom + $platform_height;

// Hole Dimensions
$hole_dia = 2;
$hole_y = 0;
$hole_z = 30;

// Rendering settings
$fn = 64;

// Calculate Inner Dimensions
$inner_x = $outer_x - 2 * $wall_thick;
$inner_y = $outer_y - 2 * $wall_thick;
$inner_z = $outer_z - $floor_thick;

// Build the tank
difference() {
    // 1. Create the main outer block
    cube([
        $outer_x, 
        $outer_y, 
        $outer_z
    ]);

    // 2. Cut out the bottom floor
    translate([0, 0, 0]) {
        cube([
            $inner_x, 
            $inner_y, 
            $floor_thick - 0.01 // Slightly less than floor thickness
        ]);
    }

    // 3. Cut out the top opening (open-top tank)
    // The opening is at the very top, extending down to the top of the floor
    translate([0, 0, $outer_z - $floor_thick]) {
        cube([
            $inner_x, 
            $inner_y, 
            $floor_thick - 0.01 // Cut down just past the floor level
        ]);
    }

    // 4. Cut out the side walls to create the hollow cavity
    // We define the cavity volume and subtract it from the block.
    // Cavity bounds:
    // X: $wall_thick to $outer_x - $wall_thick
    // Y: $wall_thick to $outer_y - $wall_thick
    // Z: $floor_thick to $outer_z - $floor_thick
    
    // Left Wall Cut
    translate([0, 0, 0]) {
        cube([
            $wall_thick, 
            $inner_y, 
            $inner_z - 0.01
        ]);
    }
    // Right Wall Cut
    translate([$outer_x - $wall_thick, 0, 0]) {
        cube([
            $wall_thick, 
            $inner_y, 
            $inner_z - 0.01
        ]);
    }
    // Front Wall Cut
    translate([0, 0, 0]) {
        cube([
            $inner_x, 
            $wall_thick, 
            $inner_z - 0.01
        ]);
    }
    // Back Wall Cut
    translate([0, $outer_y - $wall_thick, 0]) {
        cube([
            $inner_x, 
            $wall_thick, 
            $inner_z - 0.01
        ]);
    }

    // 5. Add the solid raised platform
    // Position: Centered in X, spanning full inner width Y
    translate([
        ($outer_x - $platform_len) / 2, 
        0, 
        $platform_z_bottom
    ]) {
        cube([
            $platform_len, 
            $platform_width, 
            $platform_height
        ]);
    }

    // 6. Drill electrode holes
    // Hole position: y = $hole_y, z = $hole_z
    // Axis: X (horizontal)
    // Length: Must span the entire tank width in X to pass through both end walls.
    // We place the cylinder centered at the hole coordinates.