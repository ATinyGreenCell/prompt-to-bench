// Dimensions
outer_diameter_spout = 10;
inner_diameter_spout = outer_diameter_spout - 2 * 1.6;
outer_diameter_cone = 60;
inner_diameter_cone = outer_diameter_cone - 2 * 1.6;
height_cone = 50;
height_spout = 20;
wall_thickness = 1.6;

// Spout
spout = cylinder_d(outer_diameter_spout, height_spout, center = true) -
        cylinder_d(inner_diameter_spout, height_spout + 1, center = true);

// Cone
cone = rotate_extrudeconvex($fn = 64)
      (translate<[0, 0, height_spout])
      (circle_d(outer_diameter_cone, center = true) -
       circle_d(inner_diameter_cone, center = true));

// Final model
difference() {
    union() {
        spout
        (translate<[0, 0, height_spout])
        cone
    (translate<[0, 0, -wall_thickness])
    cube([outer_diameter_spout + 2 * wall_thickness, outer_diameter_spout + 2 * wall_thickness, wall_thickness], center = true)
    ;
}
}