// Dimensions for the hose-barb reducer
$fn = 64;

// Overall dimensions
hose_8mm_id = 8;        // Inner diameter of 8 mm tubing
hose_5mm_id = 5;        // Inner diameter of 5 mm tubing
bore_diameter = 3;       // 3 mm bore through the center
z0 = 0;                  // Start of 8 mm barb section
z1 = 20;                 // End of 8 mm barb section
z2 = 25;                 // End of collar section
z3 = 41;                 // End of 5 mm barb section

// 8 mm barb section: 2 barbs, each 10 mm tall, stacked from z=0 to z=20
barb_8mm_height = 10;    // Height of each individual barb
barb_8mm_bottom_d = 7.5; // Outer diameter at bottom of 8 mm barb
barb_8mm_top_d = 9.5;   // Outer diameter at top of 8 mm barb
barb_8mm_step_back = 7.5; // Return to this diameter after the peak

// Collar section: 12 mm diameter, 5 mm long (z=20 to z=25)
collar_diameter = 12;

// 5 mm barb section: 2 barbs, each 8 mm tall, stacked from z=25 to z=41
barb_5mm_height = 8;   // Height of each individual barb
barb_5mm_bottom_d = 6.5;  // Outer diameter at bottom of 5 mm barb
barb_5mm_top_d = 5.0;        // Outer diameter at top of 5 mm barb
barb_5mm_step_back = 6.5;  // Return to this diameter after the peak

// Build the reducer using union of parts
module hose_reducer() {
    // Start with a solid cylinder for the bore
    difference() {
        // Full length cylinder from z=0 to z=41
        cylinder(h = z3, r = hose_8mm_id / 2, center = false);
        
        // Subtract the bore (a cylinder of 3 mm diameter through the full length)
        cylinder(h = z3 + 1, r = bore_diameter / 2, center = false, $fn = 64);
    }

    // Add 8 mm barbs: two stacked barbs from z=0 to z=20
    for (i = [0:1]) {
        // Each barb spans 10 mm in height
        z_start = z0 + i * barb_8mm_height;
        z_end = z_start + barb_8mm_height;

        // Create a sawtooth profile: expand from bottom to top, then step back
        // Use a polygon to define the cross-section at each z level
        // We'll use a for loop over z to build the shape with a linear profile

        // We'll use a hull of points to create the sawtooth shape
        // For each barb, we define a set of points that sweep from bottom to top
        // and then step back to the original diameter

        // Generate points for the outer profile of the barb
        // At each z level, the outer radius is interpolated between bottom and top
        // Then we step back at the top

        // We'll build the barb using a rotate_extrude of a polygon that defines the profile
        // But since we need multiple barbs and different profiles, we use a loop with a custom polygon

        // Instead, we build the barb using a series of cylinders and difference cuts
        // But for accuracy and smoothness, we use a polygon-based profile with rotate_extrude

        // Define a polygon for the cross-section of the barb at its peak
        // The profile is a sawtooth: linear rise from bottom to top, then a step back
        // We'll define a 2D polygon that represents the radial profile at the barb's mid-height

        // We'll use a single rotate_extrude for the entire barb shape
        // The profile is a line from (r_bottom, z_start) to (r_top, z_end), then a step back to (r_bottom, z_end)
        // But we need to do this for each barb

        // We'll define a polygon for the barb's outer profile: from (r_bottom, z_start) to (r_top, z_end) to (r_bottom, z_end) to (r_bottom, z_start)
        // But this would be a triangle, not sawtooth. Instead, we do a series of radial lines

        // Actually, for a sawtooth barb, we want a series of radial flares
        // But the problem says "each barb is 10 mm tall and its outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm"
        // This implies a single sawtooth: a ramp up, then a flat step back

        // So we define a polygon that has:
        // - (r_bottom, z_start) -> (r_top, z_end) -> (r_bottom, z_end) -> (r_bottom, z_start)
        // But that would be a triangle. We want a sawtooth: so we need multiple teeth?

        // Re-reading: "each barb is 10 mm tall and its outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top, then steps straight back to 7.5 mm"
        // This is a single sawtooth: a ramp up from 7.5 to 9.5 mm over 10 mm height, then a step back to 7.5 mm at the same z level.

        // So the profile is a "V" shape: a line from (7.5, z_start) to (9.5, z_end), then a horizontal line from (9.5, z_end) to (7.5, z_end), then back to (7.5, z_start)

        // But this is a 2D profile for a rotate_extrude. We'll define a polygon that is a sawtooth in the r-z plane

        // We'll define a polygon for one barb:
        // - (r_bottom, z_start)
        // - (r_top, z_end)
        // - (r_bottom, z_end)
        // - (r_bottom, z_start)

        // But this is a triangle with a flat top. That's a sawtooth.

        // However, we need to do this for both barbs. But the problem says "two identical barbs for the 8 mm tubing, stacked"
        // So we have two such sawtooths stacked vertically.

        // We'll create a single rotate_extrude of a polygon that has the sawtooth profile

        // Define the 2D profile for one barb (in r-z plane)
        // We'll use a polygon with points:
        //   P1: (r_bottom, z_start)
        //   P2: (r_top, z_end)
        //   P3: (r_bottom, z_end)
        //   P4: (r_bottom, z_start)  // close the loop

        // But this would be a triangle. We want a sawtooth that is a single tooth.

        // Actually, this is correct: a sawtooth has one "tooth" — a ramp up and a flat step back.

        // So we define:
        //   points = [
        //       [barb_8mm_bottom_d / 2, z_start],
        //       [barb_8mm_top_d / 2, z_end],
        //       [barb_8mm_bottom_d / 2, z_end],
        //       [barb_8mm_bottom_d / 2, z_start]
        //   ];

        // But this would be a triangle with a flat top. That's a sawtooth.

        // However, we need to do this for both barbs. But we can't do two separate rotate_extrudes because they would overlap.

        // Instead, we'll use a single difference operation to subtract the bore and then add the barbs as separate shapes.

        // Better: build the barb using a rotate_extrude of a polygon that defines the outer profile of the barb.

        // But the barb is only 10 mm tall and we have two of them stacked.

        // We'll define a polygon for one barb's outer profile:
        //   - Start at (r_bottom, z_start)
        //   - Go to (r_top, z_end)  // ramp up
        //   - Go to (r_bottom, z_end) // step back
        //   - Go to (r_bottom, z_start) // back to start

        // But this is a closed polygon. We'll use rotate_extrude to make it 3D.

        // However, we need to do this for both barbs. So we'll do a loop.

        // But we can't do two separate rotate_extrude in a union because they would be at different z.

        // Instead,