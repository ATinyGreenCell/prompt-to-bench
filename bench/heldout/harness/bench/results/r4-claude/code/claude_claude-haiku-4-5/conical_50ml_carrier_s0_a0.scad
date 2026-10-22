// Dimensions
base_x = 90;         // X dimension of base
base_y = 90;         // Y dimension of base
base_z = 35;         // Z dimension (height) of base
post_thickness_x = 10;  // X thickness of posts
post_width_y = 16;   // Y width of posts
post_height_z = 160; // Z height of posts
seat_diameter = 30.5; // Diameter of conical tube seats
seat_depth = 30;     // Depth of blind seats
seat_x1 = -21;       // X position of first two seats
seat_x2 = 21;        // X position of second two seats
seat_y1 = -24;       // Y position of first pair of seats
seat_y2 = 24;        // Y position of second pair of seats
hole_size = 10.4;    // Size of square holes through posts
hole_z_center = 150; // Z center of holes through posts
handle_x = 100;      // X length of handle bar
handle_y = 10;       // Y width of handle bar
handle_z = 10;       // Z height of handle bar
handle_y_pos = 60;   // Y position of handle bar center

// Part 1: Base block with posts
difference() {
  union() {
    // Base block: 90 x 90 x 35 mm, centered at origin
    cube([base_x, base_y, base_z], center=true);
    
    // Left post: 10 x 16 x 160 mm at left end
    translate([-45, -8, 0]) cube([post_thickness_x, post_width_y, post_height_z]);
    
    // Right post: 10 x 16 x 160 mm at right end
    translate([35, -8, 0]) cube([post_thickness_x, post_width_y, post_height_z]);
  }
  
  // Blind seats for conical tubes: 30.5 mm diameter, 30 mm deep
  for (x = [seat_x1, seat_x2]) {
    for (y = [seat_y1, seat_y2]) {
      translate([x, y, 5]) {
        cylinder(h=seat_depth+0.1, d=seat_diameter, $fn=64);
      }
    }
  }
  
  // Holes through posts: 10.4 x 10.4 mm square, straight through along X
  // Left post hole
  translate([-46, -5.2, hole_z_center - hole_size/2 - 0.1]) {
    cube([12, hole_size, hole_size + 0.2]);
  }
  
  // Right post hole
  translate([34, -5.2, hole_z_center - hole_size/2 - 0.1]) {
    cube([12, hole_size, hole_size + 0.2]);
  }
}

// Part 2: Handle bar: 10 x 10 mm square, 100 mm long, lying on bed
translate([0, handle_y_pos, 5]) {
  cube([handle_x, handle_y, handle_z], center=true);
}