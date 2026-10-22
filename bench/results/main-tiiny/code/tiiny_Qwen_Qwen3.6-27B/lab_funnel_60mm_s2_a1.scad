// Lab Funnel - OpenSCAD Model
// Dimensions measured in millimetres

// Spout dimensions
spout_outer_diameter = 10;          // Outer diameter of the spout (mm)
spout_inner_diameter = 6.8;         // Inner diameter (bore) of the spout (mm)
spout_height = 20;                  // Height of the straight spout section (mm)

// Cone dimensions
cone_bottom_outer_diameter = 10;    // Outer diameter at the base of the cone (matches spout) (mm)
cone_top_outer_diameter = 60;       // Outer diameter at the rim of the funnel (mm)
cone_height = 30;                   // Height of the cone section (z=20 to z=50) (mm)

// Wall thickness
wall_thickness = 1.6;               // Uniform wall thickness (mm)

// Derived dimensions
cone_bottom_inner_diameter = cone_bottom_outer_diameter - 2 * wall_thickness; // 6.8 mm
cone_top_inner_diameter = cone_top_outer_diameter - 2 * wall_thickness;       // 56.8 mm

// Resolution for smooth curves
$fn = 64;

// Main funnel body (union of spout and cone)
union() {
    // Spout section (z = 0 to z = 20)
    // Outer cylinder
    translate([0, 0, 0])
        cylinder(h = spout_height, r = spout_outer_diameter / 2, center = false);
    
    // Spout inner bore (cutout) - extends slightly past bottom and top
    translate([0, 0, -0.05])
        cylinder(h = spout_height + 0.1, r = spout_inner_diameter / 2, center = false);
    
    // Cone section (z = 20 to z = 50)
    // Outer cone
    translate([0, 0, spout_height])
        cylinder(h = cone_height, r1 = cone_bottom_outer_diameter / 2, r2 = cone_top_outer_diameter / 2, center = false);
    
    // Inner cone (cutout) - extends slightly past bottom and top
    translate([0, 0, spout_height - 0.05])
        cylinder(h = cone_height + 0.1, r1 = cone_bottom_inner_diameter / 2, r2 = cone_top_inner_diameter / 2, center = false);
}