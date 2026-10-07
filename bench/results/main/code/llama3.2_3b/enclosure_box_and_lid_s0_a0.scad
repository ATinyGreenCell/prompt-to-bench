// Dimensions in mm
box_width = 70;
box_height = 50;
box_depth = 30;
lid_wall_thickness = 1.5;
lip_outer_size_x = 65.6;
lip_outer_size_y = 45.6;
lip_clearance = 0.2;

// Box
linear_extrude(box_depth)
    union() {
        translate([0, 0, box_height])
            cube([box_width, box_height, lid_wall_thickness]);
        
        translate([-1, -1, box_height + lid_wall_thickness])
            cube([box_width + 2, box_height + 2, lid_wall_thickness]);
    }
    
// Lid
translate([0, 0, -lid_wall_thickness])
    linear_extrude(box_depth)
        union() {
            // Plate
            translate([-lip_outer_size_x/2, -lip_outer_size_y/2, 0])
                cube([lip_outer_size_x, lip_outer_size_y, box_depth]);
            
            // Lip
            translate([-lip_outer_size_x/2, -lip_outer_size_y/2, lid_wall_thickness])
                linear_extrude(box_depth)
                    union() {
                        translate([-lip_outer_size_x/2, -lip_outer_size_y/2, 0])
                            cube([lip_outer_size_x + lip_clearance*2, lip_outer_size_y + lip_clearance*2, box_depth]);
                        
                        translate([-lip_outer_size_x/2, lip_outer_size_y/2, 0])
                            cube([lip_outer_size_x + lip_clearance*2, lip_outer_size_y + lip_clearance*2, box_depth]);
                    };
        }
    
// Gap between parts
translate([box_width/2 - lid_wall_thickness/2, 0, 0])
    linear_extrude(box_depth)
        cube([10, box_height, box_depth], center=true);