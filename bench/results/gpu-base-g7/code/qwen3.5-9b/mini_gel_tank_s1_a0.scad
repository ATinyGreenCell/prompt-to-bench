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
$platform_pos_x = 0;     // Centered in X
$platform_height = 10;   // Height above inner floor
$platform_z_base = $outer_z - $floor_thick - $platform_height; // Z position of platform top

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

// Calculate Platform Inner Width (matches tank inner width)
$platform_w = $inner_y;

// Build the tank
difference() {
    // 1. Create the main outer block
    cube([
        $outer_x, 
        $outer_y, 
        $outer_z
    ]);

    // 2. Cut out the top opening (open-top tank)
    translate([0, 0, $outer_z - $floor_thick]) {
        cube([
            $inner_x, 
            $inner_y, 
            0.01 // Slightly less than wall thickness to leave walls
        ]);
    }

    // 3. Cut out the bottom floor
    translate([0, 0, 0]) {
        cube([
            $inner_x, 
            $inner_y, 
            $floor_thick - 0.01 // Slightly less than floor thickness
        ]);
    }

    // 4. Cut out the side walls (to create the inner cavity)
    // Left Wall
    translate([0, 0, 0]) {
        cube([
            $wall_thick, 
            $inner_y, 
            $outer_z - $floor_thick - 0.01
        ]);
    }
    // Right Wall
    translate([$outer_x - $wall_thick, 0, 0]) {
        cube([
            $wall_thick, 
            $inner_y, 
            $outer_z - $floor_thick - 0.01
        ]);
    }
    // Front Wall
    translate([0, 0, 0]) {
        cube([
            $inner_x, 
            $wall_thick, 
            $outer_z - $floor_thick - 0.01
        ]);
    }
    // Back Wall
    translate([0, $outer_y - $wall_thick, 0]) {
        cube([
            $inner_x, 
            $wall_thick, 
            $outer_z - $floor_thick - 0.01
        ]);
    }

    // 5. Cut out the central platform (it is solid, so we subtract it)
    // The platform sits on the floor, so its bottom is at z = $floor_thick
    // Its top is at z = $floor_thick + $platform_height
    translate([
        $platform_pos_x - $platform_len / 2, 
        0, 
        $floor_thick
    ]) {
        cube([
            $platform_len, 
            $platform_w, 
            $platform_height
        ]);
    }

    // 6. Drill electrode holes
    // Hole position: y = $hole_y, z = $hole_z
    // We need to cut a cylinder through the end walls.
    // The hole is horizontal along X.
    // We place the cylinder such that it passes through the wall at the ends.
    // The tank ends are at x = $wall_thick and x = $outer_x - $wall_thick.
    // The hole is centered in Y ($hole_y) and at height $hole_z.
    
    // Left End Hole
    translate([
        $hole_y, 
        $hole_z, 
        0 // Cylinder axis is X, so Z is the height in our local frame, but we need to rotate
    ]) {
        // Rotate to align cylinder axis with X
        rotate([90, 0, 0]) {
            cylinder(
                h = $outer_x + 10, // Extend past both ends
                r = $hole_dia / 2,
                center = true
            );
        }
    }
    
    // Right End Hole (Duplicate for symmetry/clarity, though one long cylinder covers both)
    // Actually, a single long cylinder centered at the hole coordinates works perfectly.
    // The translation above [hole_y, hole_z, 0] with rotation [90,0,0] creates a cylinder along X.
    // We just need to ensure it's centered correctly.
    // The previous block was correct for a single long hole.
    
    // Let's refine the hole logic to be absolutely sure it cuts through the specific walls.
    // The hole is at y=$hole_y, z=$hole_z.
    // We need to remove material where x is between the walls? No, the hole goes THROUGH the walls.
    // So we need a cylinder that spans the entire X length of the tank, centered at the specific Y and Z.
    
    // Re-doing the hole subtraction to be precise:
    // Position: y = $hole_y, z = $hole_z.
    // Axis: X.
    // Length: Must cover the whole tank width in X.
    
    translate([
        $hole_y, 
        $hole_z, 
        0
    ]) {
        rotate([90, 0, 0]) {
            cylinder(
                h = $outer_x + 5, // Extend slightly past ends
                r = $hole_dia / 2,
                center = true
            );
        }
    }
}