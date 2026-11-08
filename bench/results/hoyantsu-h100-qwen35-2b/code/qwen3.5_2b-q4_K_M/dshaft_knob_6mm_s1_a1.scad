// Design a replacement knob for a hotplate stirrer.
// Dimensions in millimeters (mm).

// --- Parameters ---
// Shaft diameter: 6 mm
shaft_d = 6.0;
// Knob outer diameter: 30 mm
knob_d = 30.0;
// Knob height: 15 mm
knob_h = 15.0;
// Blind bore depth from bottom face: 12 mm
blind_depth = 12.0;
// Blind bore inner diameter: 6.2 mm
blind_d = 6.2;

// Grip groove width: 2 mm
groove_width = 2.0;
// Number of grip grooves around circumference: 18
num_grooves = 18;
// Pointer groove width: 1.5 mm
pointer_width = 1.5;
// Pointer groove depth: 1 mm
pointer_depth = 1.0;

// --- Geometry Construction ---

// 1. Main Knob Cylinder (Solid)
knob_body = cylinder(d=knob_d, h=knob_h);

// 2. Blind Bore (Hollowed out from bottom face)
// We use a large cylinder to cut the hole and then remove the excess material below it.
blind_cut = cylinder(d=blind_d, h=blind_depth);

// 3. Pointer Groove (Hollowed out from top face)
pointer_cut = cylinder(d=pointer_width, h=pointer_depth);

// 4. Grip Grooves (Vertical slots)
// We create a ring of cylinders around the outer surface.
// Each groove is a half-cylinder centered on the outer surface.
// To make them "slots" or recesses rather than full protrusions, we will use difference() 
// to remove material from the knob body where these grooves are located.

// Create a ring of cylinders for the grooves
groove_cylinders = rotate_extrude(
    angle=360/num_grooves * num_grooves,
    h=knob_h,
    d=knob_d - groove_width*2, // Inner diameter of the groove cylinder
    z=0
);

// Use difference() to remove these cylinders from the knob body.
// Rule 5: Make every cutting shape extend 0.01-1 mm past the faces it cuts.
// We subtract the groove_cylinders from the knob_body.
knob_with_grooves = union(
    knob_body,
    difference(
        knob_body,
        groove_cylinders
    )
);

// 5. Final Assembly (Union of Knob and Bore/Pointer)
final_part = union(
    knob_with_grooves,
    difference(
        knob_with_grooves,
        blind_cut, // Remove the hole from the bottom face
        pointer_cut  // Remove the groove from the top face
    )
);

// --- Rendering ---
// Set view angle to show the side profile clearly (side view)
view_angle = [0, 90]; // Side view: Y is up, X is right, Z is depth
print(final_part);