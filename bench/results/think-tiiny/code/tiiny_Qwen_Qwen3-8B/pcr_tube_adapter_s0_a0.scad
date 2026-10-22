$fn = 64;

// Define dimensions
collar_diameter = 13;  // Diameter of the collar
collar_height = 1.5;   // Thickness of the collar (height)
sleeve_outer_diameter = 10.8;  // Outer diameter of the sleeve body
sleeve_height = 20;    // Height of the sleeve body
bore_diameter = 6.2;  // Diameter of the bore
bore_length = 21.5;   // Total length of the bore through the adapter

difference() {
  union() {
    // Collar: a thick cylinder (13mm diameter, 1.5mm height)
    cylinder(d=collar_diameter, h=collar_height, $fn=64);
    
    // Sleeve body: a smaller cylinder (10.8mm diameter) rising from the collar
    translate([0, 0, collar_height]) 
      cylinder(d=sleeve_outer_diameter, h=sleeve_height, $fn=64);
  }
  
  // Bore: a straight cylinder (6.2mm diameter) through the full height
  cylinder(d=bore_diameter, h=bore_length, $fn=64);
}