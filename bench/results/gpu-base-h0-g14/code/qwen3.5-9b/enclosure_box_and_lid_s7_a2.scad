// Cut out the inner void of the lip
        translate([ $lip_wall_thickness, $lip_wall_thickness, $lip_wall_thickness ]) {
            cube([ $lip_inner_x, $lip_inner_y, $lip_height - $lip_wall_thickness ]);
        }