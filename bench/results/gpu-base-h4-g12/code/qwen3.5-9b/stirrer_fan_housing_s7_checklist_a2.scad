difference() {
    // Main block
    translate([0, 0, 0]) 
        cube([outer_w, outer_h, box_h]);
    
    // Subtract mounting holes (4 holes)
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([i * hole_x, j * hole_y, 0]) {
                cylinder(h = top_t + 0.1, d = mounting_hole_d);
            }
        }
    }
    ...
}