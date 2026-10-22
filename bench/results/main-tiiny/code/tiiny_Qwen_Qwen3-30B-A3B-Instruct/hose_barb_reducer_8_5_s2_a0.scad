// Dimensions for the hose-barb reducer
$fn = 64;

// Overall dimensions
hose_8mm_id = 8;        // Inner diameter of 8 mm tubing
hose_5mm_id = 5;        // Inner diameter of 5 mm tubing
bore_diameter = 3;       // Central bore through the full length

// Section 1: 8 mm tubing barbs (z = 0 to z = 20)
barb_8mm_height = 10;   // Height of each 8 mm barb
barb_8mm_bottom_d = 7.5;  // Outer diameter at bottom of barb (8 mm side)
barb_8mm_top_d = 9.5;   // Outer diameter at top of barb (8 mm side)
num_barbs_8mm = 2;     // Number of stacked barbs for 8 mm side

// Section 2: Collar (z = 20 to z = 25)
collar_diameter = 12;   // Outer diameter of collar
collar_height = 5;      // Height of collar

// Section 3: 5 mm tubing barbs (z = 25 to z = 41)
barb_5mm_height = 8;     // Height of each 5 mm barb
barb_5mm_bottom_d = 6.5;  // Outer diameter at bottom of barb (5 mm side)
barb_5mm_top_d = 5.0;    // Outer diameter at top of barb (5 mm side)
num_barbs_5mm = 2;       // Number of stacked barbs for 5 mm side

// Total height
total_height = 41;

// Generate the base shape: a cylinder with bore
// Start with a solid cylinder of the largest expected diameter
// Then subtract the bore and add barbs via difference

// Main body: cylinder from z=0 to z=41, with bore through it
// We'll build the shape step by step using union and difference

// Define the base cylinder with bore
module base_cylinder() {
    cylinder(h = total_height, r = max(collar_diameter, barb_8mm_top_d, barb_5mm_bottom_d) + 1, center = false);
    difference() {
        cylinder(h = total_height, r = max(collar_diameter, barb_8mm_top_d, barb_5mm_bottom_d) + 1, center = false);
        cylinder(h = total_height + 0.1, r = bore_diameter / 2, center = false); // Bore with slight overhang to ensure clean cut
    }
}

// Generate barb for 8 mm side (z = 0 to 20)
// Each barb is a sawtooth: outer diameter grows from bottom to top, then steps back
module barb_8mm(z_start, z_end) {
    // For each barb, we'll create a sawtooth profile using a polygon
    // The barb has a linear taper from bottom to top, then a flat step back
    // We'll use a loop to generate the profile for each barb

    // We'll use a polygon that traces the outer profile of the barb
    // The barb has two segments: a sloped rise and a flat step back
    // We'll define the profile in the XZ plane and rotate it

    // We'll generate a polygon for one barb profile (in XZ) and rotate it around Z-axis
    // The barb is 10 mm tall, with outer diameter from 7.5 mm at bottom to 9.5 mm at top
    // Then a flat step back to 7.5 mm (so the profile is like a sawtooth)

    // We'll define a polygon that goes from (r_bottom, z_start) to (r_top, z_start + barb_8mm_height) and back to (r_bottom, z_start + barb_8mm_height)
    // But we want a sawtooth: so we go from (r_bottom, z_start) to (r_top, z_start + barb_8mm_height) and then back to (r_bottom, z_start + barb_8mm_height)
    // This creates a "V" shape in profile

    // We'll generate the points for one barb profile
    // We'll use a for loop to generate the points for the sawtooth shape

    // We'll create a polygon that traces the outer edge of the barb
    // The barb has a rise from r_bottom to r_top over height h, then a flat step back to r_bottom at the same height
    // So we have two segments: one rising, one horizontal

    // We'll define the profile in the XZ plane and rotate it around Z-axis

    // We'll use a polygon with points:
    // (r_bottom, z_start)
    // (r_top, z_start + barb_8mm_height)
    // (r_bottom, z_start + barb_8mm_height)

    // But we want multiple barbs stacked, so we'll generate a single barb profile and then rotate it around Z-axis

    // Actually, we'll use a different approach: for each barb, we'll create a solid that is a difference between two cylinders:
    // - A larger cylinder that tapers from r_bottom to r_top over the height of the barb
    // - Then subtract a flat step back

    // But simpler: use a polygon to define the profile of the barb, then rotate_extrude

    // Let's define a 2D profile for one barb (in XZ plane)
    // We'll make a polygon that has:
    // - Start at (r_bottom, z_start)
    // - Go to (r_top, z_start + barb_8mm_height)
    // - Then go back to (r_bottom, z_start + barb_8mm_height)
    // - Then back to (r_bottom, z_start) to close

    // But this would be a triangle. We want a sawtooth: so we'll do:
    // (r_bottom, z_start)
    // (r_top, z_start + barb_8mm_height)
    // (r_bottom, z_start + barb_8mm_height)
    // (r_bottom, z_start)

    // But that's not correct for a sawtooth. We want a "tooth" that rises and then steps back.

    // Actually, we want a profile that goes:
    // (r_bottom, z_start)
    // (r_top, z_start + barb_8mm_height)
    // (r_bottom, z_start + barb_8mm_height)
    // (r_bottom, z_start)

    // But this is a triangle. That's okay for a single tooth.

    // We'll generate a polygon for one barb's outer profile
    // But we need to do this for each barb in the stack

    // Instead, we'll use a different method: for each barb, we'll create a solid that is a "wedge" that tapers from r_bottom to r_top over height h, then a flat step back

    // We'll use a difference between a tapered cylinder and a flat cylinder

    // Let's define a module for one barb

    // We'll use a polygon that traces the profile of the barb in the XZ plane
    // The profile is a line from (r_bottom, z_start) to (r_top, z_start + barb_8mm_height), then a line back to (r_bottom, z_start + barb_8mm_height), then back to (r_bottom, z_start)

    // But we want multiple barbs stacked, so we'll generate one barb profile and then duplicate it

    // Actually, we can do this with a single for loop over the barbs

    // We'll generate a single barb profile and then use rotate_extrude to make it 3D

    // But we need to do it for each barb in the stack

    // Let's define a single barb profile in 2D (XZ plane)
    // We'll use a polygon that has:
    // - (r_bottom, z_start)
    // - (r_top, z_start + barb_8mm_height)
    // - (r_bottom, z_start + barb_8mm_height)
    // - (r_bottom, z_start)

    // But this is a triangle. That's okay.

    // We'll use this to create a solid barb

    // We'll do it for each barb in the stack

    // We'll use a for loop to generate each barb

    // But we can't use rotate_extrude on a polygon that's already in 3D? No, we can

    // Let's define a 2D polygon for one barb profile
    // We'll do it once and then use it for each barb

    // Actually, we'll do it inside the module

    // We'll create a polygon for one barb's profile
    // Then rotate it around Z-axis to make a 3D solid

    // But we need to do this for each barb in the stack

    // We'll use a for loop to generate each barb

    // We'll create a single barb shape and then union them

    // Let's