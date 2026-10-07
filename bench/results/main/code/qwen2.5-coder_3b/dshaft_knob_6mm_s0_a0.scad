// Define dimensions
$fn = 64;
diameter = 30; // Diameter of the knob in mm
height = 15; // Height of the knob in mm
d_shaft_diameter = 6; // Diameter of the D-shaft in mm
bore_depth = 12; // Depth of the blind bore in mm
groove_width = 2; // Width of each grip groove in mm
pointer_groove_width = 1.5; // Width of the pointer groove in mm
pointer_groove_depth = 1; // Depth of the pointer groove in mm

// Create the knob
knob = cylinder(d=diameter/2, h=height);

// Create the D-shaped blind bore
bore = translate([0, 0, height - bore_depth]) * rotate_extrude(angle=90) *
        circle(r=d_shaft_diameter/2);

// Create the grip grooves
groove_offset = diameter / (2 * $fn);
for (i=[0:17]) {
    groove = translate([diameter/2 + i * groove_width, 0, height - bore_depth]) *
            rotate_extrude(angle=90) *
            circle(r=groove_width/2);
    knob -= groove;
}

// Create the pointer groove
pointer_groove = translate([diameter/2, 0, height - pointer_groove_depth]) *
                linear_extrude(height=pointer_groove_width) *
                polygon(points=[
                    [0, 0],
                    [pointer_groove_width, 0],
                    [pointer_groove_width, pointer_groove_depth],
                    [0, pointer_groove_depth]
                ]);

// Combine all parts
final_knob = knob - bore - pointer_groove;

// Output the final model
view(final_knob);