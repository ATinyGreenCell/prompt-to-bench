$fn = 64;

// Dimensions (in millimetres)
knob_diameter = 30;      // outer diameter
knob_height = 15;        // height
bore_depth = 12;         // D-bore depth from bottom
bore_diameter = 6.2;     // D-bore circle diameter
flat_offset = 1.6;       // distance from bore center to flat side
grip_grooves = 18;       // number of grip grooves
groove_radius = 1;       // half of groove diameter (2 mm)
pointer_width = 1.5;     // pointer groove width
pointer_depth = 1;       // pointer groove depth

// Calculated dimensions for D-bore flat cut
bore_flat_y_center = -(bore_diameter/2 + flat_offset) / 2;
bore_flat_y_size = bore_diameter/2 - flat_offset + 0.1;

difference() {
  // Main knob cylinder
  cylinder(d=knob_diameter, h=knob_height);
  
  // D-shaped bore
  // 1. Circular part
  cylinder(d=bore_diameter, h=bore_depth+0.1);
  
  // 2. Flat cutting plane to create D-shape
  translate([0, bore_flat_y_center, bore_depth/2]) {
    cube([bore_diameter+0.1, bore_flat_y_size, bore_depth+0.1], center=true);
  }
  
  // Grip grooves - 18 evenly spaced half-cylinders
  for (i = [0:grip_grooves-1]) {
    angle = 360 * i / grip_grooves;
    rotate([0, 0, angle]) {
      translate([15, 0, 0]) {
        // Full cylinder for groove
        cylinder(r=groove_radius, h=knob_height);
        
        // Box to remove outer half, leaving inward-facing half
        translate([groove_radius+0.1, 0, knob_height/2]) {
          cube([2*groove_radius+0.2, 2*groove_radius+0.2, knob_height+0.1], center=true);
        }
      }
    }
  }
  
  // Pointer groove on top face (on negative Y side)
  translate([0, -knob_diameter/4, knob_height-pointer_depth/2]) {
    cube([pointer_width, knob_diameter/2, pointer_depth+0.1], center=true);
  }
}