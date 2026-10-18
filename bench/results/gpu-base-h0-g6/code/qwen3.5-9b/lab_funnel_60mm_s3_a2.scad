// Lab Funnel Design (Corrected)
// Units: millimetres
// Orientation: Upright, wide opening at top, resting on XY plane at z=0.

// Global settings
$fn = 128; // High resolution for smooth curves

// Dimensions
// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8; // 10 - 2*1.6
spout_length = 20;
spout_wall_thickness = 1.6;

// Cone (Funnel)
cone_bottom_diameter = 10; // Matches spout outer diameter
cone_top_diameter = 60;
cone_bottom_z = 20; // Start of cone
cone_top_z = 50;    // End of cone (rim)
cone_wall_thickness = 1.6;

// Calculated Cone Dimensions
cone_bottom_radius = cone_bottom_diameter / 2;
cone_top_radius = cone_top_diameter / 2;
cone_height = cone_top_z - cone_bottom_z;

// Inner dimensions at the junction (z=20)
// The inner bore continues from the spout (6.8mm)
inner_bore_diameter = spout_inner_diameter;
inner_bore_radius = inner_bore_diameter / 2;

// Inner dimensions at the top rim (z=50)
// Outer is 60mm, wall is 1.6mm, so inner is 60 - 2*1.6 = 56.8mm
inner_top_diameter = cone_top_diameter - (2 * cone_wall_thickness);
inner_top_radius = inner_top_diameter / 2;

// Main Body Construction
// We build the solid using linear_extrude with twist=360.
// The profile is defined in the XY plane (X=radius, Y=height).
// We subtract the inner void from the outer solid.

difference() {
    // 1. Outer Shell
    linear_extrude(height = cone_height, twist = 360, center = true) {
        polygon(points = [
            [0, 0],
            [cone_bottom_radius, 0],
            [cone_top_radius, cone_height],
            [0, cone_height]
        ]);
    }
    
    // 2. Inner Void (Hole)
    // The inner void is a cylinder from z=0 to z=20, then a cone from z=20 to z=50.
    // We must subtract this void to create the bore.
    linear_extrude(height = cone_height, twist = 360, center = true) {
        polygon(points = [
            [0, 0],
            [inner_bore_radius, 0],
            [inner_top_radius, cone_height],
            [0, cone_height]
        ]);
    }
}