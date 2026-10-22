$fn = 64;

// Dimensions (mm)
puck_diameter = 80;
puck_radius = puck_diameter / 2;
puck_height = 26;
flat_cut_x = 34;
num_tubes = 8;
circle_radius = 25;
hole_diameter = 11.2;
hole_radius = hole_diameter / 2;
hemisphere_lowest_z = 6;
hemisphere_center_z = hemisphere_lowest_z + hole_radius;
cylinder_height = puck_height - hemisphere_center_z;

difference() {
    // Main puck cylinder
    cylinder(h = puck_height, r = puck_radius, center = false);
    
    // Cut off flat side for label (remove everything where x > 34)
    translate([flat_cut_x, -50, -1]) {
        cube([50, 100, puck_height + 2]);
    }
    
    // Eight tube seats, evenly spaced on a 50 mm diameter circle
    for (i = [0:num_tubes-1]) {
        angle = i * 360 / num_tubes;
        x = circle_radius * cos(angle);
        y = circle_radius * sin(angle);
        
        // Cylindrical hole from hemisphere center to top
        translate([x, y, hemisphere_center_z]) {
            cylinder(h = cylinder_height + 0.1, r = hole_radius);
        }
        
        // Hemispherical depression at bottom
        translate([x, y, hemisphere_center_z]) {
            sphere(r = hole_radius);
        }
    }
}