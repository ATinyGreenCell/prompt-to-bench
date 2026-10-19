// ==============================================================================
// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Units: Millimetres
// Orientation: Rests on XY plane at Z=0 (Side facing hotplate is down).
// ==============================================================================

$fn = 128 // High resolution for smooth curves and accurate hole sizes

// --- Dimensions from User Request ---
D_KNOB_OUTER_DIAMETER = 30;       // Outer diameter of the knob cylinder
H_KNOB_TOTAL_HEIGHT    = 15;      // Total height of the knob
R_SHAFT_DIA             = 6.2;     // Diameter of the D-shaft bore (circle part)
D_BORE_FLAT_WIDTH       = 4.7;     // Width of the flat side of the D-bore

H_BLIND_BORE_DEPTH      = 12;      // Depth of the blind shaft hole from bottom up
R_SHAFT_HOLE_RADIUS     = R_SHAFT_DIA / 2; 

N_GROOVES               = 18;      // Number of vertical grip grooves
D_GROOVE_DIAMETER       = 4;       // Diameter of the groove cylinder (before cutting half)
H_GROOVE_DEPTH          = D_GROOVE_DIAMETER / 2; // Depth from outer surface

W_POINTER               = 1.5;     // Width of top pointer groove
D_PTR_RADIUS            = W_POINTER / 2; 
DEPTH_PTR               = 1;       // Depth of the pointer groove (from center outwards)

// --- Derived Geometry for D-Bore Flat Side ---
R_SHAFT_HOLE_FLAT_WIDTH_HALF = D_BORE_FLAT_WIDTH / 2; 

difference() {
  
  // --- Step A: Create Base Solid ---
  translate([0, 0, -D_GROOVE_DIAMETER/2]) { 
    cylinder(
      h = H_KNOB_TOTAL_HEIGHT + (D_GROOVE_DIAMETER), 
      r   = D_KNOB_OUTER_DIAMETER / 2,
      $fn = $fn
    );
  }

  
  // --- Step B: Cut Blind Shaft Hole (D-Shape) ---
  translate([0, 0, -H_BLIND_BORE_DEPTH]) { 
    cylinder(
      h = H_KNOB_TOTAL_HEIGHT + D_GROOVE_DIAMETER,
      r   = R_SHAFT_HOLE_RADIUS,
      $fn = $fn
    );
    
    // Cut the flat side of the D-shape.
    // We remove a rectangular prism from one side (e.g., -Y direction) to create the flat face.
    translate([0, -(R_SHAFT_HOLE_RADIUS + R_SHAFT_HOLE_FLAT_WIDTH_HALF), 0]) { 
      cube(
        [D_BORE_FLAT_WIDTH, H_KNOB_TOTAL_HEIGHT + D_GROOVE_DIAMETER * 2, $fn], // Z dimension large enough to cut through
        center = false
      );
    }
    
    // Ensure the flat side is exactly coplanar with the cylinder edge by extending slightly past.
    translate([0, -(R_SHAFT_HOLE_RADIUS + R_SHAFT_HOLE_FLAT_WIDTH_HALF) - 1, H_BLIND_BORE_DEPTH]) { 
       cube(
         [D_KNOB_OUTER_DIAMETER * 2, D_GROOVE_DIAMETER * 3, $fn], // Large enough to cover the hole depth
         center = false
       );
    }

  }


  
  // --- Step C: Cut Vertical Grip Grooves ---
  for (i = [0 : N_GROOVES - 1]) {
    
    angle_deg = i * (360 / N_GROOVES);
    translate([0, 0, -(H_KNOB_TOTAL_HEIGHT/2)]) { // Center Z relative to body height? No.
      rotate([angle_deg, 0, 0]) {
        cylinder(
          h = H_KNOB_TOTAL_HEIGHT + D_GROOVE_DIAMETER * 3, 
          r   = D_GROOVE_DIAMETER / 2, // Radius of the groove cutter
          $fn = $fn
        );
      }
    }
    
    // Offset Z to align with top face for pointer? No, grooves are full height.
    // The cylinder above is centered at its own origin. We need it relative to our main body (Z=0 bottom).
    translate([0, 0, -H_BLIND_BORE_DEPTH]) { 
       rotate(angle_deg) {
         cylinder(
           h = H_KNOB_TOTAL_HEIGHT + D_GROOVE_DIAMETER * 3, // Extend past top and bottom to ensure full cut
           r   = D_GROOVE_DIAMETER / 2,
           $fn = $fn
         );
       }
    }

  }


  
  // --- Step D: Cut Pointer Groove on Top Face ---
  translate([0, 0, H_KNOB_TOTAL_HEIGHT - (D_GROOVE_DIAMETER/2)]) { 
    rotate(90) { // Rotate to make the slot run along X axis for easier definition? Or just use polygon.
      difference() {
        cube([H_KNOB_OUTER_DIAMETER, D_PTR_RADIUS * 3 + W_POINTER, H_GROOVE_DEPTH], center = false); 
        translate([-W_POINTER/2 - (D_KNOB_OUTER_DIAMETER/4), -(R_SHAFT_HOLE_FLAT_WIDTH_HALF) - R_SHAFT_HOLE_RADIUS]) {
           cube([H_KNOB_OUTER_DIAMETER, D_PTR_RADIUS * 3 + W_POINTER, H_GROOVE_DEPTH], center = false); 
        }
      }
    }
    
    // Simpler approach for pointer: Cut a slot from Center to Edge on the flat side of the D-bore.
    // The flat side is at Y = -(R_SHAFT_HOLE_RADIUS + R_SHAFT_HOLE_FLAT_WIDTH_HALF).
    translate([0, 0, H_KNOB_TOTAL_HEIGHT - (D_GROOVE_DIAMETER/2)]) { 
      difference() {
        cylinder(h=H_KNOB_TOTAL_HEIGHT+1, r=D_KNOB_OUTER_DIAMETER/2); // Just a placeholder to ensure we are in the right Z plane logic
        
        translate([0, -(R_SHAFT_HOLE_RADIUS + R_SHAFT_HOLE_FLAT_WIDTH_HALF), 0]) {
          cube(
            [W_POINTER * 3, D_PTR_RADIUS * 4, H_GROOVE_DEPTH], 
            center = false // Not centered. Let's define position explicitly.
          );
        }
      }
    }

    // Correct Pointer Logic:
    translate([0, -(R_SHAFT_HOLE_RADIUS + R_SHAFT_HOLE_FLAT_WIDTH_HALF), 0]) {
       difference() {
         cylinder(h=H_KNOB_TOTAL_HEIGHT+1, r=D_KNOB_OUTER_DIAMETER/2); // Placeholder
        
         cube(
           [W_POINTER * 3, D_PTR_RADIUS * 4 + R_SHAFT_HOLE_FLAT_WIDTH_HALF, H_GROOVE_DEPTH], 
           center = false
         );
       }
    }

  }


  
}