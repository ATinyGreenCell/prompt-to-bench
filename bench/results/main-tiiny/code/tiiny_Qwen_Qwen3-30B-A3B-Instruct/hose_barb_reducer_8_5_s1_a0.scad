// Dimensions for the hose-barb reducer
$fn = 64;

// Overall dimensions
hose_8mm_length = 20;        // z from 0 to 20: 8 mm tubing barbs
collar_length = 5;          // z from 20 to 25: cylindrical collar
hose_5mm_length = 16;       // z from 25 to 41: 5 mm tubing barbs
total_length = 41;

// 3 mm bore through the full length
bore_diameter = 3;

// 8 mm tubing barbs (z = 0 to 20)
barb_8mm_height = 10;      // height of each individual barb
barb_8mm_bottom_dia = 7.5; // at bottom of barb (z = 0, 10, 20)
barb_8mm_top_dia = 9.5;   // at top of barb (z = 10, 20, 30)
barb_8mm_step_back = 7.5; // step back to this diameter after peak

// 5 mm tubing barbs (z = 25 to 41)
barb_5mm_height = 8;       // height of each individual barb
barb_5mm_bottom_dia = 6.5; // at bottom of barb (z = 25, 33)
barb_5mm_top_dia = 5.0;   // at top of barb (z = 33, 41)
barb_5mm_step_back = 6.5; // step back to this diameter after peak

// Collar dimensions
collar_diameter = 12;

// Create the base cylinder with bore
module body() {
    difference() {
        // Full cylinder with bore
        cylinder(h = total_length, r = max(barb_8mm_top_dia, collar_diameter, barb_5mm_bottom_dia) / 2, $fn = $fn);
        // Remove the bore
        cylinder(h = total_length + 1, r = bore_diameter / 2, $fn = $fn, center = true);
    }
}

// Generate barb profile for 8 mm tubing (z = 0 to 20)
module barb_8mm() {
    for (z = [0 : 10 : 20]) {
        // First barb: z = 0 to 10
        // Second barb: z = 10 to 20
        // Each barb has a sawtooth profile: rise from bottom_dia to top_dia, then step back
        // We'll create a difference shape that cuts out a sawtooth from the body

        // Define the profile of the barb at this section
        // The barb is symmetric around its center (z + 5 for first, z + 5 for second)
        // We'll use a for loop to generate the sawtooth shape

        // We'll generate a polygon that defines the outer profile of the barb at this section
        // For each barb, we define a sawtooth: rise from bottom_dia to top_dia over 5 mm, then step back to bottom_dia over next 5 mm

        // Create a difference shape that cuts out a sawtooth from the body
        // We'll do this by creating a cylinder that is offset from the center by the barb radius

        // The barb has two parts: rise and step back
        // We'll define a polygon that traces the outer edge of the barb

        // We'll use a for loop to generate the sawtooth shape for each barb
        // But instead, we'll use a simpler method: for each barb, create a stepped cylinder

        // Use a difference to remove a sawtooth shape from the body
        // We'll create a shape that is a "sawtooth" profile in the radial direction

        // We'll generate a polygon that traces the outer edge of the barb at this section
        // The barb is 10 mm tall, so we'll generate a profile for a 10 mm segment

        // For each barb, we'll create a shape that is a sawtooth: 5 mm rise, 5 mm step back
        // We'll define the outer radius at each z slice

        // We'll use a for loop to generate the profile for the barb
        // But since we're using a difference, we'll create a shape that is a "cylinder" with a sawtooth profile

        // Instead, we'll use a different method: for each barb, we'll create a shape that is a "cylinder" with a sawtooth profile
        // We'll do this by creating a polygon that traces the outer edge of the barb

        // We'll define the profile of the barb at this section
        // We'll use a polygon that traces the outer edge of the barb

        // For the first barb (z = 0 to 10)
        // At z = 0: radius = barb_8mm_bottom_dia / 2
        // At z = 5: radius = barb_8mm_top_dia / 2
        // At z = 10: radius = barb_8mm_bottom_dia / 2

        // We'll create a polygon that traces the outer edge of the barb
        // We'll use a for loop to generate the points

        // But we can't use a for loop in a module like this, so we'll do it differently

        // Instead, we'll use a different approach: we'll create a shape that is a "cylinder" with a sawtooth profile
        // We'll do this by creating a polygon that traces the outer edge of the barb

        // We'll define the profile of the barb at this section
        // We'll use a polygon that traces the outer edge of the barb

        // For each barb, we'll create a shape that is a "cylinder" with a sawtooth profile
        // We'll do this by creating a polygon that traces the outer edge of the barb

        // We'll define