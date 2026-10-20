// Lab Funnel - OpenSCAD Model
// Dimensions measured in millimetres

// Spout dimensions
spout_outer_diameter = 10;       // Outer diameter of the spout (mm)
spout_inner_diameter = 6.8;      // Inner diameter (bore) of the spout (mm)
spout_height = 20;               // Height of the straight spout section (mm)

// Cone dimensions
cone_bottom_outer_diameter = 10; // Outer diameter at the base of the cone (matches spout) (mm)
cone_top_outer_diameter = 60;    // Outer diameter at the rim of the funnel (mm)
cone_height = 30;                // Height of the cone section (50 - 20 = 30 mm)

// Wall thickness
wall_thickness = 1.6;            // Uniform wall thickness (mm)

// Derived dimensions
cone_bottom_inner_diameter = cone_bottom_outer_diameter - 2 * wall_thickness; // 6.8 mm
cone_top_inner_diameter = cone_top_outer_diameter - 2 * wall_thickness;       // 56.8 mm

// Resolution for curved shapes
$fn = 64;

// Build the funnel in print orientation: spout at bottom (z=0), cone above, open at top and bottom
difference() {
    // Solid outer shape: spout cylinder + cone
    union() {
        // Spout: solid cylinder from z=0 to z=spout_height
        translate([0, 0, 0])
            cylinder(h = spout_height, r = spout_outer_diameter / 2, center = false);
        
        // Cone: solid cone from z=spout_height to z=spout_height+cone_height
        translate([0, 0, spout_height])
            cylinder(h = cone_height, r1 = cone_bottom_outer_diameter / 2, r2 = cone_top_outer_diameter / 2, center = false);
    }
    
    // Hollow out the interior: spout bore + cone bore
    // Extend cuts slightly past boundaries to avoid coplanar faces
    union() {
        // Spout bore: cylinder from z=-0.5 to z=spout_height+0.5
        translate([0, 0, -0.5])
            cylinder(h = spout_height + 1, r = spout_inner_diameter / 2, center = false);
        
        // Cone bore: cone from z=spout_height-0.5 to z=spout_height+cone_height+0.5
        translate([0, 0, spout_height - 0.5])
            cylinder(h = cone_height + 1, r1 = cone_bottom_inner_diameter / 2, r2 = cone_top_inner_diameter / 2, center = false);
    }
}