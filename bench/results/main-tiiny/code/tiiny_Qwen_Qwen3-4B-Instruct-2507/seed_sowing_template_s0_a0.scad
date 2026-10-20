// Sowing template for 90mm Petri dish
// Dimensions in millimeters
disc_diameter = 85;           // Diameter of the flat disc
disc_thickness = 2;          // Thickness of the disc
hole_diameter = 3;           // Diameter of each through-hole
hole_spacing = 9;           // Centre-to-centre spacing of holes
notch_width = 10;           // Width of the notch in X direction
notch_depth = 4;            // Depth of notch in Y direction (from rim)

// Create the base disc
difference() {
    // Base disc
    cube([disc_diameter, disc_diameter, disc_thickness], center = true);
    
    // Cut out the 7x7 grid of holes
    for (i = [0 : 6]) {
        for (j = [0 : 6]) {
            translate([ 
                (i * hole_spacing) - (hole_spacing * 3.5),  // x position
                (j * hole_spacing) - (hole_spacing * 3.5),  // y position
                0 
            ]) {
                cylinder(d = hole_diameter / 2, h = disc_thickness, center = true, $fn = 64);
            }
        }
    }
    
    // Cut the rectangular notch on the +Y side (centered on Y axis)
    // Notch is 10mm wide (X) and 4mm deep (Y), on the +Y side of the rim
    translate([0, -disc_diameter/2, 0]) // move to top edge of disc
    difference() {
        // Notch in the +Y side, centered on Y axis
        translate([0, 0, 0]) // start at rim
        cube([disc_diameter, notch_depth, disc_thickness], center = false);
        
        // Subtract the part that would be outside the disc
        // We are cutting a rectangular notch from the top edge inward
        // This notch is on the +Y side, so we cut from the top edge down
        // The notch is 10mm wide in X, centered on Y axis
        translate([0, -disc_diameter/2, 0])
        cube([notch_width, notch_depth, disc_thickness], center = false);
    }
}