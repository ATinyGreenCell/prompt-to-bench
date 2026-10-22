// Box and lid enclosure for electronics board
// Units: millimetres
// Box: outer 70x50x30, 2mm walls, 2mm floor, open top
// Lid: plate 70x50x2, lip 1.5mm thick, 4mm tall, outer lip size 65.6x45.6, 0.2mm clearance on each side
// Box centered at origin, lid placed on +X side with 10mm gap

// Dimensions
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
wall_thickness = 2;
floor_thickness = 2;
lid_plate_x = 70;
lid_plate_y = 50;
lid_plate_z = 2;
lip_thickness = 1.5;
lip_height = 4;
lip_outer_x = 65.6;
lip_outer_y = 45.6;
gap = 10;

// Box (centered at origin)
box = 
  union() {
    // Bottom (2mm floor)
    cube([box_outer_x, box_outer_y, floor_thickness]);
    
    // Walls (2mm thick, 28mm tall)
    difference() {
      cube([box_outer_x, box_outer_y, box_outer_z - floor_thickness]);
      translate([wall_thickness, wall_thickness, floor_thickness])
        cube([box_outer_x - 2 * wall_thickness + 0.01, 
              box_outer_y - 2 * wall_thickness + 0.01, 
              box_outer_z - floor_thickness]);
    }
  };

// Lid (centered at (80, 0, 0) for placement)
lid = 
  union() {
    // Plate (70x50x2)
    cube([lid_plate_x, lid_plate_y, lid_plate_z]);
    
    // Lip (1.5mm thick, 4mm tall, centered on plate)
    difference() {
      translate([0, 0, lid_plate_z])
        cube([lip_outer_x, lip_outer_y, lip_height]);
      translate([lip_thickness, lip_thickness, lid_plate_z])
        cube([lip_outer_x - 2 * lip_thickness + 0.01, 
              lip_outer_y - 2 * lip_thickness + 0.01, 
              lip_height]);
    }
  };

// Place box centered at origin (0,0,0)
translate([0, 0, 0]) box;

// Place lid on +X side of box (80,0,0) for 10mm gap
// Box right edge: box_outer_x/2 = 35, gap=10, lid center x: 35+10+lid_plate_x/2 = 35+10+35=80
translate([box_outer_x/2 + gap + lid_plate_x/2, 0, 0]) lid;