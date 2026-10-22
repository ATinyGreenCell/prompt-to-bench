// Dimensions
outer_diameter_spout = 10;
inner_diameter_spout = outer_diameter_spout - 2 * 1.6;
outer_diameter_cone = 60;
inner_diameter_cone = outer_diameter_cone - 2 * 1.6;
height_cone = 50;
height_spout = 20;
wall_thickness = 1.6;

// Spout
spout = cylinder(h = height_spout, r = outer_diameter_spout / 2, center = true) -
        cylinder(h = height_spout + 0.01, r = inner_diameter_spout / 2, center = true);

// Cone
cone = cylinder(h = height_cone, r1 = outer_diameter_cone / 2, r2 = 0, center = true) -
       cylinder(h = height_cone + 0.01, r1 = inner_diameter_cone / 2, r2 = 0, center = true);

// Combine spout and cone
funnel = spout + translate([0, 0, height_spout]) * cone;

// Final model
difference() {
    funnel;
    cylinder(h = 100, r = outer_diameter_cone / 2 + 1, center = true);
}