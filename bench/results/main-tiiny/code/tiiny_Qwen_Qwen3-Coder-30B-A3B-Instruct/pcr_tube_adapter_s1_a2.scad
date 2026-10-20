// PCR tube adapter sleeve for 0.2 mL tube in 1.5 mL rack hole
// Print upside down: collar on bed, sleeve body upward

// Dimensions
collar_diameter = 13;        // Outer diameter of collar
collar_height = 1.5;         // Height of collar
sleeve_outer_diameter = 10.8; // Outer diameter of sleeve body
sleeve_height = 21.5;         // Total height of sleeve (from collar base)
bore_diameter = 6.2;          // Diameter of central bore

// Main body
union() {
  // Collar
  cylinder(h = collar_height, d = collar_diameter, center = false, $fn = 64);
  
  // Sleeve body
  translate([0, 0, collar_height]) 
    cylinder(h = sleeve_height - collar_height, d = sleeve_outer_diameter, center = false, $fn = 64);
  
  // Central bore
  translate([0, 0, -0.01]) 
    cylinder(h = sleeve_height + 0.02, d = bore_diameter, center = false, $fn = 64);
}