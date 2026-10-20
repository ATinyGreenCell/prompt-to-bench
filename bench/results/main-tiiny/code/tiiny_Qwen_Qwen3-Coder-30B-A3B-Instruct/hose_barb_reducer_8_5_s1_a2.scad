// Hose-barb reducer
// 8mm ID to 5mm ID
// Print upright along Z axis

// Dimensions
barb_height_8mm = 10; // height of barbs for 8mm tubing
barb_top_diameter_8mm = 9.5; // top diameter of 8mm barbs
barb_bottom_diameter_8mm = 7.5; // bottom diameter of 8mm barbs
barb_step_diameter_8mm = 7.5; // step back diameter of 8mm barbs

barb_height_5mm = 8; // height of barbs for 5mm tubing
barb_top_diameter_5mm = 5.0; // top diameter of 5mm barbs
barb_bottom_diameter_5mm = 6.5; // bottom diameter of 5mm barbs
barb_step_diameter_5mm = 6.5; // step back diameter of 5mm barbs

collar_diameter = 12; // diameter of collar
collar_height = 5; // height of collar

inner_diameter = 3; // bore diameter

// Main body
union() {
  // 8mm barbs
  for (i = [0, 1]) {
    translate([0, 0, i * barb_height_8mm])
    cylinder(h = barb_height_8mm, r = barb_top_diameter_8mm / 2, $fn = 64);
    
    translate([0, 0, i * barb_height_8mm + barb_height_8mm])
    cylinder(h = 0.1, r = barb_step_diameter_8mm / 2, $fn = 64);
  }
  
  // Collar
  translate([0, 0, 20])
  cylinder(h = collar_height, r = collar_diameter / 2, $fn = 64);
  
  // 5mm barbs
  for (i = [0, 1]) {
    translate([0, 0, 25 + i * barb_height_5mm])
    cylinder(h = barb_height_5mm, r = barb_top_diameter_5mm / 2, $fn = 64);
    
    translate([0, 0, 25 + i * barb_height_5mm + barb_height_5mm])
    cylinder(h = 0.1, r = barb_step_diameter_5mm / 2, $fn = 64);
  }
  
  // Central bore
  cylinder(h = 41, r = inner_diameter / 2, $fn = 64);
}