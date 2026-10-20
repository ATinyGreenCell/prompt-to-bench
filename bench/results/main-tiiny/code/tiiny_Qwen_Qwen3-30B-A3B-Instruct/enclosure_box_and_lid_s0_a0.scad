// Dimensions for the enclosure parts
$fn = 64;

// Part 1: Box (main enclosure)
box_width = 70;
box_depth = 50;
box_height = 30;
wall_thickness = 2;
floor_thickness = 2;

// Part 2: Lid (printed upside down)
lid_plate_thickness = 2;
lip_thickness = 1.5;
lip_height = 4;
lip_outer_width = 65.6;
lip_outer_depth = 45.6;

// Spacing between parts
gap = 10;

// Center of box on X and Y
box_x_center = 0;
box_y_center = 0;

// Center of lid on X and Y (placed on +X side of box)
lid_x_center = box_width / 2 + gap + lid_plate_thickness / 2;
lid_y_center = 0;

// --- Box (Part 1) ---
// Outer box (solid)
box_outer = [box_width, box_depth, box_height];

// Inner cavity (to be removed from outer box)
box_inner = [
  box_width - 2 * wall_thickness,
  box_depth - 2 * wall_thickness,
  box_height - floor_thickness
];

// Create box with walls and floor
difference() {
  cube(box_outer, center = true);
  // Subtract inner cavity (with slight extension to ensure clean cut)
  translate([0, 0, -box_height / 2 + floor_thickness + 0.01]) {
    cube(box_inner, center = true);
  }
}

// --- Lid (Part 2) ---
// Lid plate (flat base)
translate([lid_x_center, lid_y_center, 0]) {
  // Plate lies on the bed (z = 0), so we place it at z = 0
  cube([box_width, box_depth, lid_plate_thickness], center = false);
}

// Lip (1.5 mm thick, 4 mm tall, centered on the plate)
// Outer lip dimensions (with 0.2 mm clearance on each side)
// So inner lip size is: 65.6 - 0.4 = 65.2 mm x 45.6 - 0.4 = 45.2 mm
// But we define lip as a rectangular wall around the inner area

// We'll create a rectangular wall (extruded from a rectangle) that forms the lip
// The lip is 1.5 mm thick and 4 mm high, sitting on top of the plate

// Define the lip's outer rectangle (65.6 x 45.6 mm) centered on the plate
lip_outer = [lip_outer_width, lip_outer_depth];
lip_inner = [
  lip_outer_width - 2 * lip_thickness,
  lip_outer_depth - 2 * lip_thickness
];

// Create lip as a rectangular wall (using difference between outer and inner rectangles)
// We'll use a 2D polygon for the lip profile and extrude it

translate([lid_x_center, lid_y_center, lid_plate_thickness]) {
  // Create a rectangular frame (lip) with outer size lip_outer, inner hole lip_inner
  difference() {
    // Outer rectangle (top face of lip)
    square(lip_outer, center = true);
    // Inner rectangle (hole to remove)
    translate([0, 0]) {
      square(lip_inner, center = true);
    }
  }
  // Extrude the lip profile upward (4 mm height)
  linear_extrude(lip_height) {
    // The 2D shape is already defined above
  }
}