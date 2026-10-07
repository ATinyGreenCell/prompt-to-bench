// dimensions
collar_outer_radius = 6.5;
collar_inner_radius = 5.0;
collar_height = 1.5;
body_outer_radius = 5.4;
body_length = 20; // from z=1.5 to 21.5
bore_radius = 3.1;
bore_height = 21.5;

// collar
collar = translate(0,0,collar_height) cylinder(r=collar_outer_radius, h=collar_height);

// body (solid)
body = translate(0,0,collar_height + body_length) cylinder(r=body_outer_radius, h=body_length);

// bore (hole)
bore = translate(0,0,0) cylinder(r=bore_radius, h=bore_height);