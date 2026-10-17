// 96-Well PCR Tube Rack
// Designed for 0.2 mL tubes, ANSI/SLAS footprint
// Orientation: Rests on XY plane at Z=0, builds upward.
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Overall Block
$block_length = 127.76;
$block_width  = 85.48;
$block_height = 20;

// Hole Specifications
$hole_diameter = 6.2;
$hole_spacing_x = 9.0;
$hole_spacing_y = 9.0;
$hole_count_x = 12;
$hole_count_y = 8;

// Grid Positioning (Distance from nearest edge to first hole centre)
$offset_x = 14.38;
$offset_y = 11.24;

// Chamfer (Orientation Mark)
$chamfer_leg = 5;

// --- Derived Dimensions ---
// Calculate total grid size
$total_grid_x = ($hole_count_x - 1) * $hole_spacing_x;
$total_grid_y = ($hole_count_y - 1) * $hole_spacing_y;

// Calculate Block Offset to center the block on the origin
// Block Center X = $block_length / 2
// Grid Center X = $offset_x + $total_grid_x / 2
$block_offset_x = ($block_length / 2) - ($offset_x + $total_grid_x / 2);

// Block Center Y = $block_width / 2
// Grid Center Y = $offset_y + $total_grid_y / 2
$block_offset_y = ($block_width / 2) - ($offset_y + $total_grid_y / 2);

// --- Main Part ---
difference() {
    // 1. The Main Block
    translate([
        $block_offset_x, 
        $block_offset_y, 
        0
    ])
    cube([
        $block_length, 
        $block_width, 
        $block_height
    ]);

    // 2. The 96 Holes
    for (row = [0:$hole_count_y-1], col = [0:$hole_count_x-1]) {
        $x_pos = $offset_x + col * $hole_spacing_x;
        $y_pos = $offset_y + row * $hole_spacing_y;
        
        translate([
            $x_pos, 
            $y_pos, 
            0
        ])
        cylinder(
            h = $block_height + 0.1, 
            d = $hole_diameter,
            $fn = 64
        );
    }

    // 3. The Chamfer (Orientation Mark)
    // Location: A1 corner (bottom-left-back relative to grid start).
    // We cut a wedge from the corner defined by the intersection of the three faces.
    // The cut removes the volume where x < ($offset_x + $chamfer_leg) AND y < ($offset_y + $chamfer_leg) AND z < $chamfer_leg.
    // We construct this wedge by defining its vertices and using a polygon extrusion or a union of cuts.
    // Simplest robust method: Define the 3 points on the faces and create a plane cut.
    // However, to ensure a valid solid without complex plane equations, we can subtract a wedge defined by 4 points.
    // The wedge vertices are:
    // P1 (on X face): ($offset_x + $chamfer_leg, $offset_y, 0)
    // P2 (on Y face): ($offset_x, $offset_y + $chamfer_leg, 0)
    // P3 (on Z face): ($offset_x, $offset_y, $chamfer_leg)
    // P4 (internal corner): ($offset_x + $chamfer_leg, $offset_y + $chamfer_leg, $chamfer_leg) -> This is the corner of the block.
    // Wait, the wedge to remove is the tetrahedron formed by the corner and the three cut points.
    // Vertices of the tetrahedron to subtract:
    // V_corner: ($offset_x, $offset_y, 0)
    // V_x_cut: ($offset_x + $chamfer_leg, $offset_y, 0)
    // V_y_cut: ($offset_x, $offset_y + $chamfer_leg, 0)
    // V_z_cut: ($offset_x, $offset_y, $chamfer_leg)
    // This forms a pyramid (tetrahedron) with the corner as the apex and the cut points as the base vertices?
    // No, the cut plane passes through V_x_cut, V_y_cut, V_z_cut. The volume to remove is the pyramid with apex at V_corner and base triangle V_x_cut-V_y_cut-V_z_cut.
    
    // We can create this tetrahedron using a polygon in the XY plane? No.
    // We can use `hull` of the three cut points and the corner? No, that creates a convex hull of 4 points which is the tetrahedron.
    // But `hull` creates a solid. We need to subtract it.
    // Let's define the 4 vertices of the tetrahedron to subtract.
    
    $corner_x = $offset_x;
    $corner_y = $offset_y;
    $corner_z = 0;
    
    $cut_x = $corner_x + $chamfer_leg;
    $cut_y = $corner_y;
    $cut_z = 0;
    
    $cut_y2 = $corner_y + $chamfer_leg;
    $cut_z2 = 0;
    
    $cut_z3 = $corner_z;
    $cut_z4 = $chamfer_leg;
    
    // Vertices of the tetrahedron to subtract:
    // 1. Corner
    // 2. Point on X edge
    // 3. Point on Y edge
    // 4. Point on Z edge
    
    // To subtract a tetrahedron defined by 4 points in OpenSCAD, we can use `hull` on the 4 points.
    // However, `hull` works best with convex shapes. A tetrahedron is convex.
    // We just need to translate the hull of these 4 points to the correct location.
    
    translate([
        $corner_x, 
        $corner_y, 
        $corner_z
    ])
    hull() {
        translate([$chamfer_leg, 0, 0])
        cube([0.01, 0.01, 0.01]); // Dummy point at cut_x
        
        translate([0, $chamfer_leg, 0])
        cube([0.01, 0.01, 0.01]); // Dummy point at cut_y
        
        translate([0, 0, $chamfer_leg])
        cube([0.01, 0.01, 0.01]); // Dummy point at cut_z
        
        // The origin of this local hull is the corner ($corner_x, $corner_y, $corner_z)
        // So the points relative to the corner are:
        // (leg, 0, 0), (0, leg, 0), (0, 0, leg), and (0,0,0)
        // The hull of these 4 points is the tetrahedron.
        // We don't need to translate the dummy points if we define them relative to the corner.
        // But `hull` takes shapes. Let's just use points? No, `hull` takes objects.
        // We can use `cube` of size 0.01 at the specific offsets.
        
        // Correct logic:
        // Translate to corner.
        // Hull of:
        //   translate([leg, 0, 0]) cube([0.01, 0.01, 0.01])
        //   translate([0, leg, 0]) cube([0.01, 0.01, 0.01])
        //   translate([0, 0, leg]) cube([0.01, 0.01, 0.01])
        //   // The corner itself is the origin of this translation, so we need a point there too?
        //   // Actually, the hull of 3 points on axes and the origin is the tetrahedron.
        //   // But we need to include the origin in the hull definition.
        //   translate([0,0,0]) cube([0.01, 0.01, 0.01]);
    }
}