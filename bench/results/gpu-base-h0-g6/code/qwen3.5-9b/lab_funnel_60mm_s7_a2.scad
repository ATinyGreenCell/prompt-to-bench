// Lab Funnel Design - Robust Version
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0

$fn = 128; // High resolution for smooth curves

// --- Dimensions ---
// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8; // 10 - 2*1.6
spout_length = 20;
spout_wall_thickness = 1.6;

// Cone (Funnel)
cone_bottom_outer_diameter = 10; // Matches spout outer
cone_top_outer_diameter = 60;
cone_bottom_z = 20; // Start of cone
cone_top_z = 50;    // End of cone
cone_wall_thickness = 1.6;

// --- Derived Radii ---
// Outer Radii
outer_spout_radius = spout_outer_diameter / 2;
outer_cone_bottom_radius = cone_bottom_outer_diameter / 2;
outer_cone_top_radius = cone_top_outer_diameter / 2;

// Inner Radii
inner_spout_radius = spout_inner_diameter / 2;
inner_cone_bottom_radius = spout_inner_diameter / 2; // Matches spout inner
inner_cone_top_radius = (cone_top_outer_diameter / 2) - cone_wall_thickness;

// --- Construction ---
// We use rotate_extrude to create the solids