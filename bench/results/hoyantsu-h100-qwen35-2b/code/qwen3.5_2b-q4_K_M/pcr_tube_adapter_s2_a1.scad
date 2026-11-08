// Design an adapter sleeve for a 0.2 mL PCR tube in a rack hole made for 1.5 mL tubes.
// Print it upside down: a collar 13 mm OD and 1.5 mm thick lies on the bed (z=0 to z=1.5),
// and the sleeve body, 10.8 mm OD, rises from the collar to z = 21.5.
// A straight 6.2 mm diameter bore runs through the full height, open at both ends.

// Dimensions in millimeters (measured with calipers)
collar_outer_diameter = 13.0; // mm
collar_thickness = 1.5;       // mm
total_height = 21.5;          // mm (z=0 to z=21.5)
bore_diameter = 6.2;           // mm

// Define geometry for the collar (bottom part)
// Height is calculated as Total Height - Bore Diameter because the bore runs through the full height
collar_height = total_height - bore_diameter; 

// Create the collar body with a flat bottom and rounded top to prevent sticking on the bed
collar_body = cylinder(
    outer_radius=collar_outer_diameter / 2,
    inner_radius=(collar_outer_diameter - collar_thickness) / 2, // Inner radius for wall thickness
    height=collar_height,
    wall_thickness=collar_thickness/2
);

// Define the hole (bore) geometry
hole_radius = bore_diameter / 2;
hole_body = cylinder(
    outer_radius=hole_radius,
    inner_radius=0, // Open at both ends
    height=total_height
);

// Create the final assembly using union to join collar and body
adapter_sleeve = union([collar_body, hole_body]);

// Print orientation: upside down (z-axis points up)
print_adapter_sleeve = rotate_extrude(
    adapter_sleeve,
    angle=180, // Rotate 180 degrees around Z axis to flip it upside down relative to standard orientation
    direction=[0, 0, -1] // Extrude in negative Z direction (upwards)
);

// Render the part
print_adapter_sleeve;