// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0

$fn = 128; // High resolution for smooth curves

// --- Dimensions ---
// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8;
spout_length = 20;

// Cone (Funnel)
cone_bottom_diameter = 10; // Matches spout outer diameter
cone_top_diameter = 60;
cone_height = 30; // From z=20 to z=50

// Wall Thickness
wall_thickness = 1.6;

// Derived Inner Cone Dimensions
cone_bottom_inner_diameter = cone_bottom_diameter - (2 * wall_thickness);
cone_top_inner_diameter = cone_top_diameter - (2 * wall_thickness);

// --- Construction ---
// We build the outer shell and subtract the inner void.
// The part sits on the XY plane at z=0.

difference() {
    // --- OUTER SHELL ---
    union() {
        // 1. Spout Outer Cylinder (z=0 to z=20)
        cylinder(
            h = spout_length,
            d = spout_outer_diameter,
            center = false
        );

        // 2. Cone Outer Frustum (z=20 to z=50)
        // We use rotate_extrude to create a solid of revolution.
        // The profile is defined in the XZ plane.
        // We translate the profile so it starts at z=20.
        translate([0, 0, spout_length]) {
            // Profile: Line from (radius_bottom, 0) to (radius_top, height)
            // We use a polygon to close the loop for the extruder, but only the line matters for the surface.
            // Actually, rotate_extrude takes a 2D path. A simple line segment rotated creates a cone.
            // To ensure a solid, we can extrude a filled polygon or just use the line if the tool interprets it as a sweep.
            // Standard practice: Use a polygon that includes the axis to make a solid cone, OR just the line if we trust the tool.
            // However, to be safe and watertight, we define a polygon that goes from -radius to +radius.
            
            linear_extrude(height = cone_height, center = false) {
                polygon(
                    points = [
                        [-cone_bottom_diameter/2, 0],
                        [cone_bottom_diameter/2, 0],
                        [cone_top_diameter/2, cone_height],
                        [-cone_top_diameter/2, cone_height]
                    ],
                    convex = false
                );
            }
        }
    }

    // --- INNER VOID ---
    // Subtract the inner volume to create the bore.
    union() {
        // 1. Inner Cylinder (Spout Bore)
        cylinder(
            h = spout_length,
            d = spout_inner_diameter,
            center = false
        );

        // 2. Inner Cone Frustum
        translate([0, 0, spout_length]) {
            linear_extrude(height = cone_height, center = false) {
                polygon(
                    points = [
                        [-cone_bottom_inner_diameter/2, 0],
                        [cone_bottom_inner_diameter/2, 0],
                        [cone_top_inner_diameter/2, cone_height],
                        [-cone_top_inner_diameter/2, cone_height]
                    ],
                    convex = false
                );
            }
        }
    }
}