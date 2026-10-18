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
        // We use linear_extrude to create the cone from a 2D profile.
        // The profile is defined in the XZ plane.
        // Translate to start at z=20.
        translate([0, 0, spout_length]) {
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