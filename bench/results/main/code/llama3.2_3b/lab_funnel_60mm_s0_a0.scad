// Dimensions in mm
outer_diameter_spout = 10;
inner_bore_spout = outer_diameter_spout - 2 * 1.6; // 6.8 mm
height_cone = 30;
wall_thickness = 1.6;

// Spout
translate([0, 0, 0]) 
    linear_extrude(height = height_cone) 
        polygon(points=[[0, 0], [outer_diameter_spout, 0], [outer_diameter_spout, outer_diameter_spout/2], [0, outer_diameter_spout]]);

// Cone
translate([0, 0, height_cone]) 
    rotate_extrude(height = height_cone - 30) 
        polygon(points=[[0, 0], [outer_diameter_spout, 0], [outer_diameter_spout + (60-outer_diameter_spout)/2 * sqrt(3), outer_diameter_spout/2]]); 

// Wall
translate([0, 0, height_cone]) 
    for (x = [-1.6, 1.6]) 
        translate([x, 0, 0])
            cube(size=[outer_diameter_spout + 2 * wall_thickness, outer_diameter_spout + 2 * wall_thickness, wall_thickness]);