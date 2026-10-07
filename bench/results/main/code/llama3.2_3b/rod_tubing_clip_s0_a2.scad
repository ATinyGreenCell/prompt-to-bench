// Dimensions in mm
inner_diameter_ring1 = 18.7;
wall_thickness_ring1 = 3;
width_opening_ring1 = 10;
height_extrusion = 10;

inner_diameter_ring2 = 6;
wall_thickness_ring2 = 2;
width_opening_ring2 = 4.5;
x_center_ring2 = 15;
y_range_tubing = array([ -2.25, 2.25 ]);

// Rod ring
rod_ring = translate([0, 0, height_extrusion/2])
    difference()
        union()
            cylinder(h=height_extrusion, d=inner_diameter_ring1+wall_thickness_ring1)
                mirror([0, 0, 1])
            cylinder(h=height_extrusion, d=inner_diameter_ring1-wall_thickness_ring1);
        
        translate([-width_opening_ring1/2, -5, height_extrusion/2])
            polygon(points=[[-width_opening_ring1/2, -5], [0, -5], [width_opening_ring1/2, -5]]);
    
    translate([0, 0, -height_extrusion/2])
        difference()
            union()
                cylinder(h=height_extrusion, d=inner_diameter_ring1+wall_thickness_ring1)
                    mirror([0, 0, 1])
                cylinder(h=height_extrusion, d=inner_diameter_ring1-wall_thickness_ring1);
            
    translate([-width_opening_ring1/2, -5, -height_extrusion/2])
        polygon(points=[[-width_opening_ring1/2, -5], [0, -5], [width_opening_ring1/2, -5]]);
    
    translate([0, 0, height_extrusion/2])
        difference()
            union()
                cylinder(h=height_extrusion, d=inner_diameter_ring1+wall_thickness_ring1)
                    mirror([0, 0, -1])
                cylinder(h=height_extrusion, d=inner_diameter_ring1-wall_thickness_ring1);
            
    translate([width_opening_ring1/2, -5, height_extrusion/2])
        polygon(points=[[width_opening_ring1/2, -5], [0, -5], [-width_opening_ring1/2, -5]]);
    
rod_ring = union(rod_ring);

// Tubing ring
tubing_ring = translate([x_center_ring2, 0, height_extrusion/2])
    difference()
        union()
            cylinder(h=height_extrusion, d=inner_diameter_ring2+wall_thickness_ring2)
                mirror([0, 0, 1])
            cylinder(h=height_extrusion, d=inner_diameter_ring2-wall_thickness_ring2);
        
        translate([width_opening_ring2/2, -y_range_tubing[1], height_extrusion/2])
            polygon(points=[[width_opening_ring2/2, -y_range_tubing[1]], [0, -y_range_tubing[1]], [-width_opening_ring2/2, -y_range_tubing[1]]]);
    
    translate([x_center_ring2-width_opening_ring2/2, 0, height_extrusion/2])
        polygon(points=[[x_center_ring2-width_opening_ring2/2, 0], [x_center_ring2, 0], [x_center_ring2+width_opening_ring2/2, 0]]);
    
    translate([x_center_ring2+width_opening_ring2/2, 0, height_extrusion/2])
        polygon(points=[[x_center_ring2+width_opening_ring2/2, 0], [x_center_ring2, 0], [x_center_ring2-width_opening_ring2/2, 0]]);
    
tubing_ring = union(tubing_ring);

// Bridge
bridge = translate([8, 0, height_extrusion/2])
    linear_extrude(height=height_extrusion)
        square(size=6);
    
// Combine the parts
clip = union()
    rod_ring
    tubing_ring
    bridge;