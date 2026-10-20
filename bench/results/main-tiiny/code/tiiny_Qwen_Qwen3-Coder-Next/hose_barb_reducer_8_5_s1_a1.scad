// Hose-barb reducer for 8mm to 5mm silicone tubing
// Print orientation: upright along Z axis

// Parameters
bore_diameter = 3;              // Internal bore diameter (mm)
collar_diameter = 12;           // Collar outer diameter (mm)
collar_height = 5;              // Collar height (mm) - from z=20 to z=25

// 8 mm side barb parameters (2 barbs, each 10mm tall)
barb8_height = 10;              // Height of each 8mm barb (mm)
barb8_bottom_diameter = 7.5;    // Bottom diameter of 8mm barb (mm)
barb8_top_diameter = 9.5;       // Top diameter of 8mm barb (mm)
num_barb8 = 2;                  // Number of 8mm barbs

// 5 mm side barb parameters (2 barbs, each 8mm tall)
barb5_height = 8;               // Height of each 5mm barb (mm)
barb5_bottom_diameter = 6.5;    // Bottom diameter of 5mm barb (mm)
barb5_top_diameter = 5.0;       // Top diameter of 5mm barb (mm)
num_barb5 = 2;                  // Number of 5mm barbs

// Total heights
z8_start = 0;
z8_end = z8_start + num_barb8 * barb8_height;  // 20
z_collar_start = z8_end;                        // 20
z_collar_end = z_collar_start + collar_height; // 25
z5_start = z_collar_end;                        // 25
z5_end = z5_start + num_barb5 * barb5_height;  // 41

// Resolution
$fn = 64;

module barb_section_with_step(start_z, height, bottom_d, top_d, num_barbs) {
    total_height = num_barbs * height;
    
    // Base cylinder with bore
    difference() {
        // Outer shape with sawtooth profile
        union() {
            for (i = [0 : num_barbs - 1]) {
                z_barb_start = start_z + i * height;
                // Create the sawtooth profile: linear up then step back
                // First part: linear taper from bottom to top
                translate([0, 0, z_barb_start]) {
                    linear_extrude(height = height/2, scale = top_d / bottom_d) {
                        circle(d = bottom_d);
                    }
                }
                // Second part: step back to bottom diameter
                translate([0, 0, z_barb_start + height/2]) {
                    linear_extrude(height = height/2, scale = bottom_d / top_d) {
                        circle(d = top_d);
                    }
                }
            }
        }
        
        // Bore through entire section
        translate([0, 0, -0.01]) {
            cylinder(h = total_height + 0.02, d = bore_diameter);
        }
    }
}

module collar_section(z_start, z_end, outer_d, inner_d) {
    total_height = z_end - z_start;
    difference() {
        cylinder(h = total_height, d = outer_d);
        translate([0, 0, -0.01]) {
            cylinder(h = total_height + 0.02, d = inner_d);
        }
    }
}

// Build the complete reducer
module reducer() {
    // 8 mm barbs section (z = 0 to 20)
    barb_section_with_step(z8_start, barb8_height, barb8_bottom_diameter, barb8_top_diameter, num_barb8);
    
    // Collar section (z = 20 to 25)
    collar_section(z_collar_start, z_collar_end, collar_diameter, bore_diameter);
    
    // 5 mm barbs section (z = 25 to 41)
    barb_section_with_step(z5_start, barb5_height, barb5_bottom_diameter, barb5_top_diameter, num_barb5);
}

// Render the reducer
reducer();