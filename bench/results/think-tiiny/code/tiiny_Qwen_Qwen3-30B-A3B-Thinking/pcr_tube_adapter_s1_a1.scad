// Define dimensions for the adapter sleeve
collar_outer_d = 13.0;   // Outer diameter of the collar (base) in mm
collar_height = 1.5;        // Height of the collar (z=0 to 1.5) in mm
body_outer_d = 10.8;      // Outer diameter of the sleeve body in mm
body_height = 20.0;     // Height of the sleeve body (z=1.5 to 21.5) in mm
total_height = 21.5;    // Total height of the part (z=0 to 21.5) in mm
hole_d = 6.2;               // Diameter of the central bore (through entire height) in mm
hole_extension = 0.02;        // Extension beyond top/bottom for hole (0.01 on each end)

$fn = 64; // Set for smooth curved surfaces

// Collar: base that rests on the bed (z=0 to 1.5)
collar = cylinder(h = collar_height, d = collar_outer_d, center = false);

// Sleeve body: rises from collar to z=21.5 (z=1.5 to 21.5)
body = translate([0, 0, collar_height]) cylinder(h = body_height, d = body_outer_d, center = false);

// Hole: runs through entire height with 0.01mm extension below and above
hole = translate([0, 0, -0.01]) cylinder(h = total_height + hole_extension, d = hole_d, center = false);

// Assemble the part: collar + body, minus the hole
difference() {
  union() {
    collar;
    body;
  }
  hole;
}