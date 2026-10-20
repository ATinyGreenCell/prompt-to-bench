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
    // We build the funnel using rotate_extrude.
    // The profile is defined in the XZ plane (radius vs height).
    // We rotate this profile 360 degrees around the Z axis to create the solid of revolution.
    
    // Profile points: [radius (x), height (z)]
    // 1. Bottom of spout (z=0): Outer radius = 5, Inner radius = 3.4
    // 2. Top of spout / Bottom of cone (z=20): Outer radius = 5, Inner radius = 3.4
    // 3. Top rim of cone (z=50): Outer radius = 30, Inner radius = 23.4
    
    // We define the outer boundary and the inner boundary separately to create a hollow tube.
    // Outer path: (5, 0) -> (30, 50) -> (30, 50) [Wait, need to close the loop properly]
    // Actually, for rotate_extrude, we just need a closed polygon in the XZ plane.
    // Path: Start bottom outer -> Top outer -> Top inner -> Bottom inner -> Close to start.
    
    $outer_bottom_x = $spout_od / 2;      // 5
    $outer_top_x = $cone_od_end / 2;      // 30
    
    $inner_bottom_x = $spout_id / 2;      // 3.4
    $inner_top_x = $cone_id_end / 2;      // 23.4
    
    // Define the polygon points for the profile
    // Order: Outer Bottom -> Outer Top -> Inner Top -> Inner Bottom -> (back to Outer Bottom)
    // Note: rotate_extrude expects a closed polygon.
    
    $profile_points = [
        [$outer_bottom_x, 0],             // Start: Bottom Outer
        [$outer_top_x, $cone_end_z],      // Top Outer
        [$inner_top_x, $cone_end_z],      // Top Inner
        [$inner_bottom_x, 0]              // Bottom Inner
    ];
    
    // Close the loop by connecting back to the start point
    $profile_points = concat($profile_points, [$outer_bottom_x, 0]);
    
    // Extrude the profile around the Z axis
    rotate_extrude($a=360, $h=$cone_end_z) {
        polygon(points=$profile_points, convexity=10);
    }
}

// Center the object on the origin in X and Y as requested.
// Since we used rotate_extrude centered at (0,0,0) and the profile starts at z=0,
// the object is already centered in X and Y and rests on z=0.
lab_funnel();