// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_length = 20;      // Length of the straight spout (z=0 to z=20)
$spout_od = 10;          // Outer diameter of the spout
$spout_id = 6.8;        // Inner diameter of the spout (10 - 2*1.6)

// Cone (Funnel)
$cone_start_z = 20;      // Z position where cone starts (top of spout)
$cone_end_z = 50;       // Z position of the funnel rim
$cone_od_start = 10;    // Outer diameter at cone start (matches spout)
$cone_od_end = 60;      // Outer diameter at cone rim
$cone_id_start = 6.8;   // Inner diameter at cone start (matches spout bore)
$cone_id_end = 46.8;    // Inner diameter at cone rim (60 - 2*1.6)

// Wall Thickness
$wall_thickness = 1.6;

// Resolution
$fn = 64;

// --- Construction ---

module lab_funnel() {
    // We build the funnel as a single solid using linear_extrude with a polygon profile.
    // The profile is defined in the XZ plane (width = X, height = Z).
    // We extrude along the Y axis to create the tube.
    
    // Calculate the profile points: [x, z]
    // Start at bottom (z=0) to top rim (z=50).
    
    // 1. Bottom of spout (z=0)
    // Outer radius = 5, Inner radius = 3.4
    // Points: [-5, 0], [-3.4, 0]
    
    // 2. Top of spout / Bottom of cone (z=20)
    // Outer radius = 5, Inner radius = 3.4
    // Points: [-5, 20], [-3.4, 20]
    
    // 3. Top rim of cone (z=50)
    // Outer radius = 30, Inner radius = 23.4
    // Points: [-30, 50], [-23.4, 50]
    
    // Close the loop for the outer wall
    // 4. Back up the outer wall to z=0
    // Points: [-30, 50] -> [-5, 20] -> [-5, 0]
    // Wait, linear_extrude creates a closed polygon.
    // Let's define the full perimeter:
    // Outer path: (-5,0) -> (-30,50) -> (-30,50) [Wait, need to go back]
    // Correct path logic:
    // Start bottom left outer: (-5, 0)
    // Go up outer wall to cone top: (-30, 50)
    // Go down outer wall back to start: (-5, 0) -- No, that's not right for a closed loop in 2D.
    
    // Let's define the polygon vertices explicitly:
    // 1. Bottom Left Outer: -5, 0
    // 2. Top Left Outer: -30, 50
    // 3. Top Right Outer: 30, 50
    // 4. Bottom Right Outer: 5, 0
    // 5. Bottom Left Outer: -5, 0 (Close loop)
    
    // Inner hole path (must be closed and opposite orientation):
    // 1. Bottom Left Inner: -3.4, 0
    // 2. Top Left Inner: -23.4, 50
    // 3. Top Right Inner: 23.4, 50
    // 4. Bottom Right Inner: 3.4, 0
    // 5. Bottom Left Inner: -3.4, 0 (Close loop)
    
    // Combine into one polygon list
    $outer_bottom_x = -$spout_od / 2;
    $outer_top_x = -$cone_od_end / 2;
    $outer_top_x_right = $cone_od_end / 2;
    $outer_bottom_x_right = $spout_od / 2;
    
    $inner_bottom_x = -$spout_id / 2;
    $inner_top_x = -$cone_id_end / 2;
    $inner_top_x_right = $cone_id_end / 2;
    $inner_bottom_x_right = $spout_id / 2;
    
    // Define the polygon points
    // Outer boundary
    $pts_outer = [
        [$outer_bottom_x, 0],
        [$outer_top_x, $cone_end_z],
        [$outer_top_x_right, $cone_end_z],
        [$outer_bottom_x_right, 0]
    ];
    
    // Inner boundary
    $pts_inner = [
        [$inner_bottom_x, 0],
        [$inner_top_x, $cone_end_z],
        [$inner_top_x_right, $cone_end_z],
        [$inner_bottom_x_right, 0]
    ];
    
    // Create the profile polygon
    // We need to merge these into a single polygon list for linear_extrude
    // Order: Outer CCW, then Inner CW (or Outer CCW, then Inner CCW and let OpenSCAD handle holes if we use difference, 
    // but linear_extrude with a single polygon handles holes automatically if the inner loop is defined correctly).
    // Actually, standard practice for linear_extrude with holes: define outer loop, then inner loops.
    
    $profile_points = [];
    // Add outer points
    for (p = $pts_outer) {
        $profile_points = concat($profile_points, p);
    }
    // Add inner points
    for (p = $pts_inner) {
        $profile_points = concat($profile_points, p);
    }
    
    // Extrude along Y axis (default for linear_extrude is Z, but we want Y to make a tube? 
    // Wait, the prompt says "rests on the XY plane at z = 0 and builds upward (+Z)".
    // So the height is Z. The tube runs from z=0 to z=20.
    // The cross section is in the XY plane.
    // So we should use rotate_extrude or just define the shape in XY and extrude in Z.
    // Let's re-evaluate:
    // If the funnel rests on XY plane, the base is at Z=0.
    // The spout is a cylinder along Z.
    // The cone is a frustum along Z.
    // So the cross-section is in the XY plane.
    // We can use linear_extrude with the profile in XY, extruding along Z.
    
    // Profile in XY:
    // Outer: (-5, 0) -> (-30, 0) -> (30, 0) -> (5, 0) -> (-5, 0) ? No, that's a rectangle.
    // The funnel is rotationally symmetric.
    // We can use rotate_extrude with a 2D profile in the XZ plane? 
    // No, if we rotate a 2D profile in XZ around Z, we get a 3D object where Z is the axis of symmetry.
    // This matches the description: "straight spout... runs from z=0 to z=20", "cone widens...".
    // So the axis of symmetry is Z.
    // We define a 2D profile in the XZ plane (radius vs height) and rotate_extrude around Z.
    
    // Profile points in XZ plane (radius x, height z):
    // Start at z=0, radius=5 (outer), radius=3.4 (inner)
    // End at z=50, radius=30 (outer), radius=23.4 (inner)
    
    $profile_xz = [
        [$spout_od / 2, 0],           // Outer bottom
        [$cone_od_end / 2, $cone_end_z], // Outer top
        [$cone_id_end / 2, $cone_end_z], // Inner top
        [$spout_id / 2, 0]            // Inner bottom
    ];
    
    // Close the inner loop
    $profile_xz = concat($profile_xz, [$spout_id / 2, 0]);
    
    // Rotate extrude around Z axis
    // Center the object at origin. 
    // The prompt says "centre it on the origin in X and Y".
    // With rotate_extrude, the center of rotation is (0,0,0).
    // Our profile goes from z=0 to z=50. This is perfect.
    
    rotate_ex