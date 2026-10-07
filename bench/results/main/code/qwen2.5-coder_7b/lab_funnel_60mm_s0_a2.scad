// Dimensions in millimeters
$fn = 64;

outer_diameter_spout = 10;
inner_diameter_spout = outer_diameter_spout - 2 * 1.6;
height_spout = 20;
outer_diameter_cone = 60;
inner_diameter_cone = outer_diameter_cone - 2 * 1.6;
height_cone = 50;

// Spout
spout = cylinder(r=outer_diameter_spout/2, h=height_spout, center=true) -
        cylinder(r=inner_diameter_spout/2, h=height_spout + 1, center=true);

// Cone
cone = rotate_extrude() 
       polygon(points=[[-outer_diameter_cone/2, 0],
                      [-inner_diameter_cone/2, height_cone],
                      [inner_diameter_cone/2, height_cone],
                      [outer_diameter_cone/2, 0]]);

// Combine spout and cone
funnel = union() {
    translate([0, 0, -1]) { // Offset to ensure no coplanar faces
        spout;
    }
    translate([0, 0, height_spout]) {
        cone;
    }
};

// Final model
funnel;