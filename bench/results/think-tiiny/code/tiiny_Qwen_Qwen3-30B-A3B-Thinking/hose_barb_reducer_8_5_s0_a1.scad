// Hose-barb reducer for 8mm to 5mm silicone tubing, printed upright along Z-axis.
// Central bore: 3mm diameter, runs through full length.
// Units: millimeters.

// Define all dimensions as variables with comments.
$fn = 64; // Ensure smooth curves for holes

// Central bore diameter (throughout)
central_bore_dia = 3.0;

// 8mm tubing section barb dimensions (z=0 to z=20)
barb8_bottom_dia = 7.5;   // Bottom of barb (outer diameter)
barb8_top_cone_dia = 9.5; // Top of conical section (outer diameter)
barb8_step_dia = 7.5;     // Step back to this diameter at very top
barb8_height = 10.0;     // Height of one barb (conical section + step)
barb8_step_extension = 0.01; // Extension for subtraction (0.01mm below top face)

// 5mm tubing section barb dimensions (z=25 to z=41)
barb5_bottom_dia = 6.5;  // Bottom of barb (outer diameter)
barb5_top_cone_dia = 5.0; // Top of conical section (outer diameter)
barb5_step_dia = 6.5;    // Step back to this diameter at very top
barb5_height = 8.0;       // Height of one barb (conical section + step)
barb5_step_extension = 0.01; // Extension for subtraction (0.01mm below top face)

// Collar dimensions (z=20 to z=25)
collar_dia = 12.0;      // Diameter of the cylindrical collar
collar_height = 5.0;    // Height of the collar (z=20 to z=25)

// Total part height
total_height = 41.0;      // From z=0 to z=41

// Build the body without the central hole (outer structure)
body = 
  union() {
    // 8mm tubing section: first barb (z=0 to z=10)
    difference() {
      cylinder(r1 = barb8_bottom_dia / 2, r2 = barb8_top_cone_dia / 2, h = barb8_height, center = false);
      translate([0, 0, barb8_height - barb8_step_extension])
        cylinder(r = barb8_step_dia / 2, h = barb8_step_extension, center = false);
    }
    
    // 8mm tubing section: second barb (z=10 to z=20)
    difference() {
      cylinder(r1 = barb8_bottom_dia / 2, r2 = barb8_top_cone_dia / 2, h = barb8_height, center = false)
        translate([0, 0, barb8_height]);
      translate([0, 0, barb8_height + barb8_height - barb8_step_extension])
        cylinder(r = barb8_step_dia / 2, h = barb8_step_extension, center = false);
    }
    
    // Collar (z=20 to z=25)
    cylinder(r = collar_dia / 2, h = collar_height, center = false)
      translate([0, 0, 20]);
    
    // 5mm tubing section: first barb (z=25 to z=33)
    difference() {
      cylinder(r1 = barb5_bottom_dia / 2, r2 = barb5_top_cone_dia / 2, h = barb5_height, center = false)
        translate([0, 0, 25]);
      translate([0, 0, 25 + barb5_height - barb5_step_extension])
        cylinder(r = barb5_step_dia / 2, h = barb5_step_extension, center = false);
    }
    
    // 5mm tubing section: second barb (z=33 to z=41)
    difference() {
      cylinder(r1 = barb5_bottom_dia / 2, r2 = barb5_top_cone_dia / 2, h = barb5_height, center = false)
        translate([0, 0, 25 + barb5_height]);
      translate([0, 0, 25 + barb5_height + barb5_height - barb5_step_extension])
        cylinder(r = barb5_step_dia / 2, h = barb5_step_extension, center = false);
    }
  };

// Subtract the central hole (3mm diameter, from z=0 to z=41)
final_part = difference() {
  body;
  cylinder(r = central_bore_dia / 2, h = total_height, center = false);
};

// Output the final part
final_part;