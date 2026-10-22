// Hose-barb reducer for 8mm to 5mm silicone tubing
// Units: millimetres, rotationally symmetric about Z-axis (z=0 at base)
// 3mm bore through entire length (diameter 3.0)
// Barbs for 8mm tubing (z=0 to 20): two stacked barbs (10mm each), outer diameter 7.5mm at bottom, 9.5mm at top of taper, step to 7.5mm at very top
// Collar (z=20 to 25): cylindrical, 12mm diameter
// Barbs for 5mm tubing (z=25 to 41): two stacked barbs (8mm each), outer diameter 6.5mm at bottom, 5.0mm at top of taper, step to 6.5mm at very top

// Define all dimensions as variables
$fn = 64; // Ensure smooth curves

// Dimensions for 8mm tubing barbs (z=0 to 20)
barb8_bottom_d = 7.5;   // Outer diameter at bottom of barb (7.5mm)
barb8_top_d = 9.5;       // Outer diameter at top of taper (9.5mm)
barb8_height = 10.0;     // Height of each barb (10mm)
barb8_step_d = 7.5;      // Step diameter (back to 7.5mm at very top)

// Collar dimensions (z=20 to 25)
collar_d = 12.0;         // Outer diameter of collar (12mm)
collar_height = 5.0;       // Height of collar (5mm)

// Dimensions for 5mm tubing barbs (z=25 to 41)
barb5_bottom_d = 6.5;        // Outer diameter at bottom of barb (6.5mm)
barb5_top_d = 5.0;          // Outer diameter at top of taper (5.0mm)
barb5_height = 8.0;          // Height of each barb (8mm)
barb5_step_d = 6.5;        // Step diameter (back to 6.5mm at very top)

// Bore dimensions (through entire length)
bore_d = 3.0;              // Inner diameter of bore (3.0mm)
total_height = 41.0;         // Total height of part (z=0 to 41)

// Build outer profile (rotationally symmetric)
outer_profile = 
    union() {
        // Barbs for 8mm tubing (z=0 to 20)
        // First barb: z=0 to 10
        rotate_extrude() {
            polygon(points = [[barb8_bottom_d/2, 0], [barb8_top_d/2, barb8_height]]);
        }
        // Second barb: z=10 to 20 (starts at step diameter 7.5mm)
        translate([0, 0, barb8_height]) {
            rotate_extrude() {
                polygon(points = [[barb8_step_d/2, 0], [barb8_top_d/2, barb8_height]]);
            }
        }
        
        // Collar: z=20 to 25 (diameter 12mm)
        translate([0, 0, barb8_height * 2]) {
            cylinder(h = collar_height, r = collar_d/2, center = false);
        }
        
        // Barbs for 5mm tubing (z=25 to 41)
        // Third barb: z=25 to 33 (25 = 20 + 5 = collar height)
        translate([0, 0, barb8_height * 2 + collar_height]) {
            rotate_extrude() {
                polygon(points = [[barb5_bottom_d/2, 0], [barb5_top_d/2, barb5_height]]);
            }
        }
        // Fourth barb: z=33 to 41 (33 = 25 + 8)
        translate([0, 0, barb8_height * 2 + collar_height + barb5_height]) {
            rotate_extrude() {
                polygon(points = [[barb5_step_d/2, 0], [barb5_top_d/2, barb5_height]]);
            }
        }
    };

// Build bore (3mm diameter through entire length)
bore = 
    cylinder(h = total_height, r = bore_d/2, center = false);

// Final part: outer profile minus bore (with 0.01mm clearance for subtraction)
difference() {
    outer_profile;
    translate([0, 0, -0.01]) 
        bore;
}