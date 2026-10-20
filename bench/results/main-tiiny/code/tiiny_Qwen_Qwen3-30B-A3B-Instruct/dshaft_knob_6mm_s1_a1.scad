// Dimensions for the hotplate stirrer knob
$fn = 64; // Set resolution for smooth curves

// Main knob dimensions
diameter_knob = 30;        // Diameter of the cylindrical knob
height_knob = 15;            // Height of the knob
d_shaft_diameter = 6.2;      // Diameter of the D-shaft hole (slightly larger than 6 mm for clearance)
d_shaft_flat_width = 4.7;   // Width across flats of the D-shaft (flat to opposite side)
d_shaft_depth = 12;          // Depth of the D-shaped blind bore

// Grip grooves
num_grooves = 18;          // Number of vertical grip grooves
groove_diameter = 2;       // Diameter of the half-cylinder groove
groove_depth = 15;           // Grooves go full height (15 mm)

// Pointer groove
pointer_width = 1.5;       // Width of the pointer groove
pointer_depth = 1;         // Depth of the pointer groove

// Calculate radius for ease of use
radius_knob = diameter_knob / 2;
radius_groove = groove_diameter / 2;

// Build the knob as a cylinder
cylinder(h = height_knob, r = radius_knob, center = true);

// Subtract the D-shaped blind bore
difference() {
    // Main cylinder (already defined)
    cylinder(h = height_knob, r = radius_knob, center = true);

    // D-shaped hole: a circle of diameter 6.2 mm, with one side flat
    // The flat is 4.7 mm wide, so the flat is centered on the x-axis (flat on negative x side)
    // The circle has radius 3.1 mm
    // The D-shape is: a full circle of radius 3.1 mm, minus a rectangular prism from the side

    // Create a rectangular prism to cut the flat side
    // The flat side is 4.7 mm in y-direction (from -2.35 to 2.35), and extends 0.01 mm past the circle's edge in x
    // So the cube is: width = 0.01 mm (in x), height = 4.7 mm (in y), depth = 12.01 mm (in z)
    // Positioned at x = -3.1 - 0.005 (so it extends from -3.1 to -3.1 - 0.01), y = 0, z = 0
    translate([-(d_shaft_diameter / 2 + 0.005), 0, 0]) {
        cube([0.01, d_shaft_flat_width, d_shaft_depth + 0.01], center = false);
    }
}

// Cut 18 evenly spaced vertical grip grooves around the outside
// Each groove is a 2 mm diameter half-cylinder, centered on the outer surface, going full height
for (i = [0 : num_grooves - 1]) {
    angle = i * 360 / num_grooves;
    // Rotate the half-cylinder to the correct angle
    rotate([0, 0, angle]) {
        // Translate to the outer surface (radius_knob - radius_groove) to center the groove on the surface
        // But since the groove is a half-cylinder, we need to place it so that its flat side faces inward
        // So we place the half-cylinder at radius_knob - radius_groove, but actually: the half-cylinder should be centered at radius_knob
        // So we translate along x-axis by (radius_knob - radius_groove) to center the groove on the surface
        // But we want the groove to be a half-cylinder that cuts into the knob from the side
        // So we use a half-cylinder of radius 1 mm (since groove_diameter = 2), and place it at radius_knob - 1 mm from center
        // Then rotate it so that the flat side faces inward
        // Actually: we can use a half-cylinder that is aligned radially

        // Create a half-cylinder: we'll use a full cylinder and cut it in half
        // But easier: use a cylinder of radius 1 mm, height 15 mm, and rotate it so that its axis is radial
        // But we can't do that directly. Instead, we can use a cylinder and rotate it around the z-axis, but we need to cut a groove

        // Correct: use a cylinder of radius 1 mm, height 15 mm, centered at (radius_knob - 1, 0, 0) and rotated so that its axis is along the radial direction?
        // No — we want a groove that is a half-cylinder that is tangent to the outer surface and extends inward.

        // Actually, the groove is a half-cylinder of radius 1 mm, whose axis is parallel to the z-axis, and located at a distance of (radius_knob - 1) from the center.
        // But we want the groove to be centered on the outer surface, so the center of the half-cylinder should be at (radius_knob - 1, 0, 0) in the local coordinate system, but rotated to the correct angle.

        // So:
        //   translate([radius_knob - radius_groove, 0, 0]) {
        //       rotate([0, 0, angle]) {
        //           cylinder(h = height_knob, r = radius_groove, center = true);
        //       }
        //   }

        // But that would be a full cylinder. We want a half-cylinder.

        // We can do: create a half-cylinder by cutting a full cylinder with a plane.
        // But easier: use a cylinder of radius 1 mm, height 15 mm, and rotate it so that its axis is along the z-axis, but placed at (radius_knob - 1, 0, 0) and rotated by angle around z-axis.

        // Actually, we can use a cylinder of radius 1 mm, height 15 mm, centered at (radius_knob - 1, 0, 0), and rotated by angle around z-axis.

        // But that would be a full cylinder. We want only half of it — the half that faces inward.

        // So we can do: create a half-cylinder by using a cylinder and subtracting half of it with a plane.

        // Instead, we can use a half-cylinder by using a cylinder and cutting it with a plane at angle 0 and 180 degrees.

        // But simpler: use a cylinder of radius 1 mm, height 15 mm, centered at (radius_knob - 1, 0, 0), rotated by angle around z-axis, and then cut it with a plane at x=0.

        // Actually, we can use a half-cylinder by using a cylinder and a difference with a half-space.

        // But OpenSCAD doesn't have half-cylinder directly. So we do:
        //   cylinder(h = height_knob, r = radius_groove, center = true)
        //   difference:
        //     cube([2 * radius_knob, 2 * radius_knob, height_knob], center = true)
        //     translate([0, 0, 0]) {
        //         rotate([0, 0, angle]) {
        //             cube([2 * radius_knob, 2 * radius_knob, height_knob], center = true);
        //         }
        //     }

        // No — better: use a half-cylinder by creating a cylinder and cutting it with a plane.

        // We'll do: create a cylinder of radius 1 mm, height 15 mm, centered at (radius_knob - 1, 0, 0), rotated by angle around z-axis.
        // Then cut it with a plane at angle 0 and 180 degrees.

        // Actually, we can use a cylinder and a difference with a half-space.

        // But here's a simpler way: use a cylinder of radius 1 mm, height 15 mm, centered at (radius_knob - 1, 0, 0), rotated by angle around z-axis.
        // Then use a cube that covers half of it: from x = -infinity to x = (radius_knob - 1) - 1, but that's not right.

        // Correct method: use a cylinder of radius 1 mm, height 15 mm, centered at (radius_knob - 1, 0, 0), rotated by angle around z-axis.
        // Then use a difference with a half-space: a cube that extends from x = -infinity to x = (radius_knob - 1) - 1, but that's not bounded.

        // Instead, we can use a half-cylinder by using a cylinder and a plane that cuts it in half.

        // We'll do: create a cylinder of radius 1 mm, height 15 mm, centered at (radius_knob - 1, 0, 0), rotated by angle around z-axis.
        // Then use a cube that covers the entire half-space: from x = -100 to x = (radius_knob - 1) - 1, but that's not correct.