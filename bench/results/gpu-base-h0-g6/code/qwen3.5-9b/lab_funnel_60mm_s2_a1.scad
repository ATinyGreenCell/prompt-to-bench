// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel)
$cone_bottom_diameter = 10; // Matches spout outer diameter
$cone_top_diameter = 60;
$cone_height = 30; // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for curved surfaces
$fn = 64;

// --- Main Module ---
module lab_funnel() {
    // Define the start and end radii for the cone section
    $cone_bottom_radius = $cone_bottom_diameter / 2;
    $cone_top_radius = $cone_top_diameter / 2;
    
    // Calculate the virtual tip of the cone to use for subtraction
    // The cone widens from bottom_radius to top_radius over height $cone_height
    // Slope = (top - bottom) / height
    // Distance from bottom to tip = bottom / slope
    $cone_slope = ($cone_top_radius - $cone_bottom_radius) / $cone_height;
    $cone_tip_offset = $cone_bottom_radius / $cone_slope;
    
    // Total height of the virtual cone from the tip to the top rim
    $cone_virtual_height = $cone_height + $cone_tip_offset;
    
    // Inner radii for the hollow parts
    $spout_inner_radius = $spout_inner_diameter / 2;
    $cone_inner_bottom_radius = $cone_bottom_radius - $wall_thickness;
    $cone_inner_top_radius = $cone_top_radius - $wall_thickness;
    
    // Calculate inner cone tip offset
    $cone_inner_slope = ($cone_inner_top_radius - $cone_inner_bottom_radius) / $cone_height;
    $cone_inner_tip_offset = $cone_inner_bottom_radius / $cone_inner_slope;
    $cone_inner_virtual_height = $cone_height + $cone_inner_tip_offset;
    
    // --- Build the Outer Shell ---
    // 1. Spout (Cylinder)
    // 2. Cone (Frustum)
    
    union() {
        // Spout
        cylinder(
            d = $spout_outer_diameter,
            h = $spout_length,
            center = [0, 0, $spout_length/2],
            $fn = $fn
        );
        
        // Cone
        // We create a large cone and subtract a smaller cone at the bottom to get the frustum
        // Large Cone: Radius = $cone_top_radius, Height = $cone_virtual_height
        // Small Cone: Radius = $cone_bottom_radius, Height = $cone_tip_offset
        // Position: Tip at z = -$cone_tip_offset, Top at z = $cone_height
        
        difference() {
            // Large Cone
            cylinder(
                d = $cone_top_diameter,
                h = $cone_virtual_height,
                center = [0, 0, $cone_virtual_height/2 - $cone_tip_offset],
                $fn = $fn
            );
            
            // Small Cone (to cut off the tip)
            cylinder(
                d = $cone_bottom_diameter,
                h = $cone_tip_offset,
                center = [0, 0, -$cone_tip_offset/2],
                $fn = $fn
            );
        }
    }
    
    // --- Build the Inner Hole (to subtract) ---
    // 1. Spout Hole
    // 2. Cone Hole
    
    difference() {
        // Spout Hole
        cylinder(
            d = $spout_inner_diameter,
            h = $spout_length,
            center = [0, 0, $spout_length/2],
            $fn = $fn
        );
        
        // Cone Hole
        // Similar logic: Large inner cone minus small inner cone
        difference() {
            // Large Inner Cone
            cylinder(
                d = $cone_inner_top_diameter,
                h = $cone_inner_virtual_height,
                center = [0, 0, $cone_inner_virtual_height/2 - $cone_inner_tip_offset],
                $fn = $fn
            );
            
            // Small Inner Cone (to cut off the tip)
            cylinder(
                d = $cone_inner_bottom_diameter,
                h = $cone_inner_tip_offset,
                center = [0, 0, -$cone_inner_tip_offset/2],
                $fn = $fn
            );
        }
    }
}

// --- Execution ---
// Extend the inner hole slightly past the outer shell to ensure clean cuts
// Spout extension
$spout_ext = 0.1;
$cone_ext = 0.1;

// Re-calculate inner dimensions with extension for the subtraction step
$spout_inner_d_ext = $spout_inner_diameter + 2*$spout_ext;
$cone_inner_bottom_d_ext = ($cone_bottom_diameter - 2*$wall_thickness) + 2*$cone_ext;
$cone_inner_top_d_ext = ($cone_top_diameter - 2*$wall_thickness) + 2*$cone_ext;

// Recalculate virtual heights for the extended inner cone
$cone_inner_slope_ext = (($cone_inner_top_d_ext/2) - ($cone_inner_bottom_d_ext/2)) / $cone_height;
$cone_inner_tip_offset_ext = ($cone_inner_bottom_d_ext/2) / $cone_inner_slope_ext;
$cone_inner_virtual_height_ext = $cone_height + $cone_inner_tip_offset_ext;

// Re-run the subtraction logic with extended inner dimensions
difference() {
    // 1. Create the solid outer shape
    union() {
        cylinder(
            d = $spout_outer_diameter,
            h = $spout_length,
            center = [0, 0, $spout_length/2],
            $fn = $fn
        );
        
        difference() {
            cylinder(
                d = $cone_top_diameter,
                h = $cone_virtual_height,
                center = [0, 0, $cone_virtual_height/2 - $cone_tip_offset],
                $fn = $fn
            );
            cylinder(
                d = $cone_bottom_diameter,
                h = $cone_tip_offset,
                center = [0, 0, -$cone_tip_offset/2],
                $fn = $fn
            );
        }
    }
    
    // 2. Subtract the extended inner hole
    difference() {
        cylinder(
            d = $spout_inner_d_ext,
            h = $spout_length,
            center = [0, 0, $spout_length/2],
            $fn = $fn
        );
        
        difference() {
            cylinder(
                d = $cone_inner_top_d_ext,
                h = $cone_inner_virtual_height_ext,
                center = [0, 0, $cone_inner_virtual_height_ext/2 - $cone_inner_tip_offset_ext],
                $fn = $fn
            );
            cylinder(
                d = $cone_inner_bottom_d_ext,
                h = $cone_inner_tip_offset_ext,
                center = [0, 0, -$cone_inner_tip_offset_ext/2],
                $fn = $fn
            );
        }
    }
}