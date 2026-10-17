translate([0, 0, $plate_thickness])
                union() {
                    cube([ $lip_outer_x, $lip_outer_y, $lip_thickness + $lip_height ]);
                    // Hole
                    translate([ ... ]) cube([ ... ]);
                }