// Lab Funnel Design - Corrected
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel Body)
$cone_bottom_diameter = 10; // Matches spout outer diameter
$cone_top_diameter = 60;
$cone_height = 30; // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for smooth curves
$fn = 128;

// --- Main Assembly ---
// The part rests on the XY plane at z = 0.
// The spout runs from z = 0 to z = 20.
// The cone widens from z = 20 to z = 50.

translate([0, 0, 0]) {
    union() {
        // 1. The Spout (Outer Shell)
        // Cylinder from z=0 to z=20
        cylinder(
            h = $spout_length,
            d = $spout_outer_diameter,
            center = false
        );
        
        // 2. The Spout (Inner Bore)
        // Cylinder from z=0 to z=20
        cylinder(
            h = $spout_length,
            d = $spout_inner_diameter,
            center = false
        );
        
        // 3. The Cone (Outer Shell)
        // Cone from z=20 to z=50
        // bottom_d: diameter at z=20 (10mm)
        // top_d: diameter at z=50 (60mm)
        // height: 30mm
        cone(
            h = $cone_height,
            bottom_radius = $cone_bottom_diameter / 2,
            top_radius = $cone_top_diameter / 2,
            center = false
        );
        
        // 4. The Cone (Inner Bore)
        // Cone from z=20 to z=50
        // Calculate inner radii
        inner_bottom_radius = ($cone_bottom_diameter - $wall_thickness * 2) / 2;
        inner_top_radius = ($cone_top_diameter - $wall_thickness * 2) / 2;
        
        cone(
            h = $cone_height,
            bottom_radius = inner_bottom_radius,
            top_radius = inner_top_radius,
            center = false
        );
    }
}