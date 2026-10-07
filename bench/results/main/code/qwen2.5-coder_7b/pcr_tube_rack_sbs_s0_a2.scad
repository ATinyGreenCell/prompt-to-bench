// Dimensions in millimeters
$fn = 64;

// Rack dimensions
rack_length = 127.76;
rack_width = 85.48;
rack_height = 20;

// Hole dimensions and spacing
hole_diameter = 6.2;
hole_spacing = 9.0;

// Chamfer dimensions
chamfer_angle = 45;
chamfer_leg_length = 5;

// Calculate the position of the first hole (A1)
first_hole_x = 14.38;
first_hole_y = 11.24;

// Create the rack block
rack = cube([rack_length, rack_width, rack_height]);

// Create the through-holes
holes = for (x=[0:11]) 
          for (y=[0:7])
            translate([first_hole_x + x * hole_spacing, first_hole_y + y * hole_spacing, 0])
              cylinder(d=hole_diameter, h=rack_height, center=true);

// Create the chamfer at the A1 corner
chamfer = translate([first_hole_x - chamfer_leg_length / sin(chamfer_angle), first_hole_y - chamfer_leg_length / sin(chamfer_angle), 0])
            rotate_extrude(angle=360, convexity=10)
              polygon(points=[[0, 0], [chamfer_leg_length, 0], [chamfer_leg_length, chamfer_leg_length], [0, chamfer_leg_length]]);

// Combine the rack and holes
result = difference() {
  union() {
    rack;
    holes;
  }
  chamfer;
};

// Render the result
render(result);