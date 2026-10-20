translate([x, y, -disc_thickness / 2 + 0.01]) {
    cylinder(h = disc_thickness + 0.02, r = hole_diameter / 2, center = true);
}