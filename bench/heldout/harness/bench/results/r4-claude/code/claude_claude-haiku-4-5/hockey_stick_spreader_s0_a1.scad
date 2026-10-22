// Handle dimensions (mm)
handle_length = 150;
handle_width = 6;
handle_thickness = 4;

// Spreading foot dimensions (mm)
foot_length = 40;
foot_width = 5;
foot_thickness = 2.5;

// Boss dimensions (mm)
boss_diameter = 6;
boss_height = 4;

// Hole dimensions (mm)
hole_diameter = 4;
hole_x = 143;

// Foot angle (degrees, counter-clockwise from +X axis)
foot_angle = 120;

$fn = 64;

// Main body - union of handle, foot, and boss
difference() {
  union() {
    // Handle: x = 0 to 150, y = -3 to 3, z = 0 to 4
    translate([0, -handle_width/2, 0]) {
      cube([handle_length, handle_width, handle_thickness]);
    }
    
    // Spreading foot: 40 mm long, 5 mm wide, 2.5 mm thick, at 120 degrees
    // Rotate first, then translate - so centerline passes through origin at 120°
    rotate([0, 0, foot_angle]) {
      translate([0, -foot_width/2, 0]) {
        cube([foot_length, foot_width, foot_thickness]);
      }
    }
    
    // Round boss at origin: 6 mm diameter, 4 mm tall
    cylinder(d=boss_diameter, h=boss_height);
  }
  
  // Subtract hanging hole at x = 143, y = 0
  translate([hole_x, 0, -0.5]) {
    cylinder(d=hole_diameter, h=handle_thickness + 1);
  }
}