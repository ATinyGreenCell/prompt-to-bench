// Define variables for dimensions
$fn = 64; // For curved shapes

// Create the knob body
knob_body = cylinder(d=30, h=15);

// Create the blind bore
blind_bore = translate([0, 0, 12]) * cylinder(d=6.2, h=1);

// Create the grip grooves
grip_grooves = for (i=[0:17]) {
    translate([0, 0, i*2]) * cylinder(d=2, h=1);
};

// Create the pointer groove
pointer_groove = translate([0, 0, 18]) * cylinder(d=1.5, h=1);

// Combine all parts to form the knob
knob = union([
    knob_body,
    blind_bore,
    grip_grooves,
    pointer_groove
]);

// Center the knob on the origin
knob_centered = translate([0, 0, -knob_body.h/2]) * knob;

// Render the knob
render(knob_centered);