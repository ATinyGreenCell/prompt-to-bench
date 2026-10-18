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
$platform_height = 10;   // Height above inner floor
$platform_top_z = $floor_thick + $platform_height; // Z position of platform top (13)

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

    // 2. Cut out the main inner cavity (creates walls and floor thickness)
    // This removes the space inside the walls and the space above the floor
    translate([0, 0, 0]) {
        cube([
            $inner_x, 
            $inner_y, 
            $outer_z - $floor_thick
        ]);
    }

    // 3. Cut out the top opening (make it open-top)
    // The cavity cut above goes up to ($outer_z - $floor_thick).
    // We need to remove the space above that up to the top of the tank.
    translate([0, 0, $outer_z - $floor_thick]) {
        cube([
            $inner_x, 
            $inner_y, 
            $floor_thick // Remove the top 3mm layer to open it
        ]);
    }

    // 4. Cut out the platform void
    // The platform is solid, so we remove the space it occupies.
    // It sits on the floor (z = $floor_thick) and goes up to $platform_top_z.
    // It spans the full inner width ($inner_y) and is centered in X.
    translate([
        ($outer_x - $platform_len) / 2, 
        0, 
        $floor_thick
    ]) {
        cube([
            $platform_len, 
            $inner_y, 
            $platform_height
        ]);
    }

    // 5. Drill electrode holes
    // Hole position: y = $hole_y, z = $hole_z
    // We need to cut a cylinder through the end walls along the X axis.
    // The hole is at Y=0, Z=30.
    // We place a cylinder centered at (0, $hole_y, $hole_z) with length > $outer_x.
    translate([
        0, 
        $hole_y, 
        $hole_z
    ]) {
        cylinder(
            h = $outer_x + 10, // Extend past both ends to ensure clean cut
            r = $hole_dia / 2,
            center = true
        );
    }
}