// Lab funnel parameters
$fn = 64;

// Dimensions
spout_outer_diameter = 10;           // mm
spout_length = 20;                     // mm from z=0 to z=20
cone_base_diameter = 10;               // mm at z=20
cone_top_diameter = 60;              // mm at z=50
cone_height = 30;                      // mm from z=20 to z=50
wall_thickness = 1.6;                    // mm everywhere

// Derived dimensions
spout_inner_diameter = spout_outer_diameter - 2 * wall_thickness;
cone_inner_base_diameter = cone_base_diameter - 2 * wall_thickness;
cone_inner_top_diameter = cone_top_diameter - 2 * wall_thickness;

// Center funnel on origin in X and Y
// Spout: from z=0 to z=20, constant outer diameter
// Cone: from z=20 to z=50, tapers from 10mm to 60mm outer diameter

// Main funnel body: union of spout and cone with wall thickness
// Use difference to hollow out the inside

module funnel() {
    // Outer shape: spout + cone
    translate([0, 0, 0]) {
        // Spout: cylinder from z=0 to z=20
        cylinder(h = spout_length, d = spout_outer_diameter, center = false);
        
        // Cone: tapering from z=20 to z=50
        // Use linear_extrude with scale to make it taper
        // We'll use a polygon for the cross-section that scales from base to top
        // But for simplicity, we use a cone shape via rotate_extrude with a scaled polygon
        // Instead, we use a difference of two cones: outer and inner
    }
    
    // We'll build the funnel as a solid outer shape and subtract the inner bore
    // First, create the full outer funnel shape (spout + cone)
    difference() {
        // Outer funnel: spout + cone
        union() {
            // Spout
            cylinder(h = spout_length, d = spout_outer_diameter, center = false);
            
            // Cone: from z=20 to z=50, outer diameter from 10 to 60
            // Use a cone that tapers from base to top
            // We'll use a rotate_extrude of a triangle shape (line from (r,0) to (R, h))
            // But for cleaner code, use a cone with scaled radius
            // Instead, use a cylinder with scale in rotate_extrude
            // We'll use a polygon that defines the profile
            translate([0, 0, spout_length]) {
                // Create a polygon for the cone profile: from (r_base, 0) to (r_top, h_cone)
                // But we need to build it from z=20 to z=50
                // So we define a 2D polygon that goes from (0,0) to (0, cone_height) with x scaling
                // Actually, use a rotate_extrude of a line from (r_base, 0) to (r_top, h)
                // But we can't use rotate_extrude with non-constant radius easily
                // So we use a cone shape via two cylinders and a hull? No.
                // Better: use a single cone with radius changing linearly
                // We can use a polyhedron or use a difference of cones, but let's use a simpler method:
                // Use a cylinder with a scale that increases from base to top
                // But OpenSCAD doesn't support that directly.
                // Alternative: use a rotate_extrude of a line segment from (r_base, 0) to (r_top, h)
                // We'll define a polygon for the profile of the cone
                // The profile is a line from (r_base, 0) to (r_top, h_cone)
                // But we need to offset it to the right for the wall
                // Actually, we can do:
                // - Create a polygon for the outer profile of the cone: from (r_base, 0) to (r_top, h_cone)
                // - Then rotate it around the z-axis
                // But we already have the spout. So we do:
                //   - Create a cone from z=20 to z=50 with outer radius from 5 to 30
                //   - But we can't do that directly. So we use a rotate_extrude of a line.
                // Let's do it properly with rotate_extrude.
                rotate_extrude() {
                    polygon(points = [
                        [cone_base_diameter / 2, 0],
                        [cone_top_diameter / 2, cone_height]
                    ]);
                }
            }
        }
        
        // Inner bore: subtract the inner volume
        // Inner bore: spout + cone with inner diameter
        union() {
            // Inner spout: cylinder from z=0 to z=20
            cylinder(h = spout_length, d = spout_inner_diameter, center = false);
            
            // Inner cone: from z=20 to z=50, inner radius from 5 - 1.6 = 3.4 to 30 - 1.6 = 28.4
            // So inner base radius = cone_base_diameter/2 - wall_thickness = 5 - 1.6 = 3.4
            // Inner top radius = 30 - 1.6 = 28.4
            // Use rotate_extrude of a line from (3.4, 0) to (28.4, 30)
            translate([0, 0, spout_length]) {
                rotate_extrude() {
                    polygon(points = [
                        [cone_inner_base_diameter / 2, 0],
                        [cone_inner_top_diameter / 2, cone_height]
                    ]);
                }
            }
        }
    }
}

// Render the funnel
funnel();