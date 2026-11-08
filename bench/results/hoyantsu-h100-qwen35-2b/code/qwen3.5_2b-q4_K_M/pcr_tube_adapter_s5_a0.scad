// Design an adapter sleeve for a 0.2 mL PCR tube in a rack hole made for 1.5 mL tubes.
// Print it upside down: a collar 13 mm in diameter and 1.5 mm thick lies on the bed (z = 0 to 1.5), 
// and the sleeve body, 10.8 mm in outer diameter, rises from the collar to z = 21.5.
// A straight 6.2 mm diameter bore runs through the full height, open at both ends.

// Dimensions (in millimeters)
d_collar_outer   = 13.0; // Outer diameter of the collar
t_collar         = 1.5;  // Thickness of the collar
z_base           = 0.0;  // Base position on bed (z=0)
h_body           = 21.5; // Height of the body from base
d_bore_outer     = 6.2;  // Outer diameter of the bore
t_bore           = 0.4;  // Thickness of the bore wall

// Create the collar (cylinder with a flat top)
collar = cylinder(d_collar_outer, t_collar);
collar_top = cube(z=t_collar, x=d_collar_outer, y=0);

// Create the body (cylinder with a flat bottom)
body = cylinder(d_bore_outer, h_body);
body_bottom = cube(z=h_body, x=d_bore_outer, y=0);

// Create the bore hole (a hollow cylinder)
bore = cylinder(d_bore_outer, t_bore);

// Assemble parts using union to form a solid part
adapter = union(
    collar_top,
    body_bottom,
    collar,
    body,
    bore
);

// Center the part on the origin (X=0, Y=0)
adapter_centered = translate([0.0, 0.0, 0.0]) adapter;

// Print upside down: rotate around Z axis by 180 degrees
adapter_upside_down = rotate_extrude(180) adapter_centered;

// Set number of turns for the bore to ensure round holes (fn=64 or more)
bore_turns = 20; // Arbitrary high value to ensure perfect circles, though not strictly necessary if using polygon with enough sides
adapter_upside_down_bored = rotate_extrude(bore_turns) adapter_upside_down;

// Final output
print(1);