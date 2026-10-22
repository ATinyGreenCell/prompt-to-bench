// Bore (subtract cylinder from center, extending past both ends)
    translate([0, 0, -0.01]) {
        cylinder(h = total_height + 0.02, r = bore_radius, center = false);
    }