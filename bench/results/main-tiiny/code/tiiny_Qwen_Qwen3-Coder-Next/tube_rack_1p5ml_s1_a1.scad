hole_depth = 25;
...
translate([x_pos, y_pos, -0.1]) 
    cylinder(h = hole_depth + 0.11, d = hole_dia, $fn = 64);