// Dimensions in mm
inner_diameter_8mm = 8;
outer_diameter_8mm_start = 7.5;
outer_diameter_8mm_end = 9.5;
barb_height_8mm = 10;
total_length_barbs_8mm = 20;

inner_diameter_5mm = 5;
outer_diameter_5mm_start = 6.5;
outer_diameter_5mm_end = 5.0;
barb_height_5mm = 8;
total_length_barbs_5mm = 16;

collar_diameter = 12;

// Print orientation
translate([0, 0, -10]) {
    // Reducer body
    translate([0, 0, 0])
        linear_extrude(41)
            union() {
                // Inner hole
                cylinder(h=41, d=inner_diameter_8mm, $fn=64);
                
                // Outer wall
                circle(d=outer_diameter_8mm_start, h=barb_height_8mm, $fn=64);
                translate([0, 0, barb_height_8mm])
                    circle(d=outer_diameter_8mm_end, h=barb_height_8mm, $fn=64);
                translate([0, 0, 2*barb_height_8mm])
                    circle(d=outer_diameter_8mm_start, h=barb_height_8mm, $fn=64);
                
                // Sawtooth profile
                for (x = [0, outer_diameter_8mm_end - outer_diameter_8mm_start]) {
                    translate([x, 0])
                        circle(d=x, h=barb_height_8mm/2, $fn=64); // Changed to half height
                }
            }
            
    // Barbs for 8 mm tubing
    for (z = [0, total_length_barbs_8mm]) {
        if (z == 0) {
            translate([0, 0, z])
                rotate_extrude([90, 0, 0], angle=180)
                    polygon(points=[[0, 0], [outer_diameter_8mm_start, 0], [outer_diameter_8mm_end, barb_height_8mm/2], [0, barb_height_8mm/2]]);
        } else {
            translate([0, 0, z])
                rotate_extrude([90, 0, 0], angle=180)
                    polygon(points=[[0, 0], [outer_diameter_8mm_start + (z - total_length_barbs_8mm) * (outer_diameter_8mm_end - outer_diameter_8mm_start)/(barb_height_8mm/2), 0], [outer_diameter_8mm_end, barb_height_8mm/2], [0, barb_height_8mm/2]]);
        }
    }
    
    // Collar
    translate([0, 0, total_length_barbs_8mm])
        cylinder(h=collar_diameter/2, d=collar_diameter, $fn=64);
}

// Barbs for 5 mm tubing
for (z = [20, total_length_barbs_5mm + 25]) {
    if (z == 20) {
        translate([0, 0, z])
            rotate_extrude([90, 0, 0], angle=180)
                polygon(points=[[0, 0], [outer_diameter_5mm_start, 0], [outer_diameter_5mm_end, barb_height_5mm/2], [0, barb_height_5mm/2]]);
    } else {
        translate([0, 0, z])
            rotate_extrude([90, 0, 0], angle=180)
                polygon(points=[[0, 0], [outer_diameter_5mm_start + (z - total_length_barbs_5mm) * (outer_diameter_5mm_end - outer_diameter_5mm_start)/(barb_height_5mm/2), 0], [outer_diameter_5mm_end, barb_height_5mm/2], [0, barb_height_5mm/2]]);
    }
}

// Barbs for 5 mm tubing (second set)
for (z = [25, total_length_barbs_5mm]) {
    if (z == 25) {
        translate([0, 0, z])
            rotate_extrude([90, 0, 0], angle=180)
                polygon(points=[[0, 0], [outer_diameter_5mm_start, 0], [outer_diameter_5mm_end, barb_height_5mm/2], [0, barb_height_5mm/2]]);
    } else {
        translate([0, 0, z])
            rotate_extrude([90, 0, 0], angle=180)
                polygon(points=[[0, 0], [outer_diameter_5mm_start + (z - total_length_barbs_5mm) * (outer_diameter_5mm_end - outer_diameter_5mm_start)/(barb_height_5mm/2), 0], [outer_diameter_5mm_end, barb_height_5mm/2], [0, barb_height_5mm/2]]);
    }
}