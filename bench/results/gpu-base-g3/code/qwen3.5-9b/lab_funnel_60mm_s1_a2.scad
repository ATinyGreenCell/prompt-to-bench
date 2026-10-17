// Lab Funnel Design - Corrected
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0

$fn = 128; // High resolution for smooth curves

// Spout (Tube)
spout_outer_diameter = 10;
spout_inner_diameter = 6.8;
spout_length = 20;
spout_wall_thickness = 1.6;

// Cone (Funnel)
cone_bottom_diameter = 10; // Matches spout outer diameter
cone_top_diameter = 60;
cone_height = 30; // From z=20 to z=50

// Wall Thickness
wall_thickness = 1.6;

// Derived Cone Dimensions
cone_bottom_inner_diameter = cone_bottom_diameter - 2 * wall_thickness;
cone_top_inner_diameter = cone_top_diameter - 2 * wall_thickness;

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
        // Translate to start at z=20
        translate([0, 0, spout_length]) {
            // Profile: Line from (radius_bottom, 0) to (radius_top, cone_height)
            // rotate_extrude rotates around the Z axis.
            // The profile must be defined in the XZ plane (y=0).
            // Points are [x, z].
            rotate_extrude($fn = $fn) {
                polygon([
                    [cone_bottom_diameter/2, 0],
                    [cone_top_diameter/2, cone_height]
                ]);
            }
        }
    }

    // --- INNER VOID ---
    union() {
        // 1. Inner Cylinder Void (z=0 to z=20)
        cylinder(
            h = spout_length,
            d = spout_inner_diameter,
            center = false
        );

        // 2. Inner Cone Void (z=20 to z=50)
        translate([0, 0, spout_length]) {
            rotate_extrude($fn = $fn) {
                // Profile for inner cone
                // Start at bottom inner radius, go up to top inner radius
                polygon([
                    [cone_bottom_inner_diameter/2, 0],
                    [cone_top_inner_diameter/2, cone_height]
                ]);
            }
        }
    }
}