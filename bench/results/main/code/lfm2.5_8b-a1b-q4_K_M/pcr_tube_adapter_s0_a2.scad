// collar
collar = translate(0,0,collar_height) cylinder(r=collar_outer, h=collar_height);

// body (solid)
body = translate(0,0,collar_height + body_length) cylinder(r=body_outer, h=body_length);

// bore (hole)
bore = translate(0,0,0) cylinder(r=bore_radius, h=bore_height);