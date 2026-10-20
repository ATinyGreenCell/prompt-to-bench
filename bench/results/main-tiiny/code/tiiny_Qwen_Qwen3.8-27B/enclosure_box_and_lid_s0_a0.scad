// Two-part enclosure for a small electronics board (Arduino temperature logger)
// Part 1: Box (open top, 2 mm walls, 2 mm floor)
// Part 2: Lid (printed upside down, plate + rectangular lip)
// Both parts print side-by-side with a 10 mm gap.

$fn = 64;

// ===================== BOX DIMENSIONS =====================
box_outer_x = 70;   // outer X size
box_outer_y = 50;   // outer Y size
box_outer_z = 30;   // outer Z height
wall_t = 2;         // wall thickness
floor_t = 2;        // floor thickness

// ===================== LID DIMENSIONS =====================
lid_plate_x = 70;   // plate X size
lid_plate_y = 50;   // plate Y size
lid_plate_t = 2;    // plate thickness (lies on bed)
lip_wall_t = 1.5;   // lip wall thickness
lip_h = 4;          // lip height (extends upward from plate in print orientation)
lip_outer_x = 65.6; // lip outer X size
lip_outer_y = 45.6; // lip outer Y size

// ===================== LAYOUT =====================
gap = 10;           // gap between box and lid

// Box is centred on origin in X and Y
// Box occupies X: -35 to +35, Y: -25 to +25, Z: 0 to 30

// Lid is on the +X side of the box
// Lid plate centred at X = 35 + gap + 35 = 80, Y = 0
// Lid occupies X: 80-35=45 to 80+35=115, Y: -25 to 25, Z: 0 to 2 (plate) + 4 (lip) = 6

// ===================== PART 1: BOX =====================
// Box: outer 70x50x30, 2mm walls, 2mm floor, open top
// Build as outer box minus inner cavity (open top)

module box_part() {
    // Outer solid
    outer = cube([box_outer_x, box_outer_y, box_outer_z], center = true);
    
    // Inner cavity: starts at z = floor_t, goes up past the top (open top)
    // Cavity dimensions: (box_outer_x - 2*wall_t) x (box_outer_y - 2*wall_t) x (box_outer_z - floor_t + 1)
    // The +1 ensures the cut extends past the top face
    cavity_x = box_outer_x - 2 * wall_t;
    cavity_y = box_outer_y - 2 * wall_t;
    cavity_z = box_outer_z - floor_t + 1;  // extend 1mm past top to ensure clean cut
    
    // Cavity is centred in X and Y, starts at z = floor_t
    // So translate to: x=0, y=0, z = floor_t + cavity_z/2
    // But we want the cavity bottom at z = floor_t, so centre z = floor_t + cavity_z/2
    
    difference() {
        translate([0, 0, 0]) outer;
        translate([0, 0, floor_t + cavity_z / 2]) 
            cube([cavity_x, cavity_y, cavity_z], center = true);
    }
}

// ===================== PART 2: LID (printed upside down) =====================
// Lid plate: 70 x 50 x 2, lying on bed (z=0 to z=2)
// Lip: 1.5mm thick wall, 4mm tall, outer 65.6 x 45.6, centred on plate
// Lip sits on top of plate: z=2 to z=6
// The lip is a rectangular ring (hollow rectangle)

module lid_part() {
    // Plate
    plate = cube([lid_plate_x, lid_plate_y, lid_plate_t], center = true);
    
    // Lip: outer rectangle minus inner rectangle
    // Outer: lip_outer_x x lip_outer_y x lip_h
    // Inner: (lip_outer_x - 2*lip_wall_t) x (lip_outer_y - 2*lip_wall_t) x (lip_h + 1)
    // The +1 in Z ensures the inner cut extends past the top of the lip
    
    lip_outer = cube([lip_outer_x, lip_outer_y, lip_h], center = true);
    
    lip_inner_x = lip_outer_x - 2 * lip_wall_t;
    lip_inner_y = lip_outer_y - 2 * lip_wall_t;
    lip_inner_z = lip_h + 1;  // extend 1mm past top
    
    // Lip is centred on the plate, sitting on top of it
    // Plate top is at z = lid_plate_t
    // Lip bottom is at z = lid_plate_t, lip top is at z = lid_plate_t + lip_h
    // So lip centre z = lid_plate_t + lip_h / 2
    
    lip = difference() {
        translate([0, 0, lid_plate_t + lip_h / 2]) lip_outer;
        translate([0, 0, lid_plate_t + lip_inner_z / 2]) 
            cube([lip_inner_x, lip_inner_y, lip_inner_z], center = true);
    };
    
    union() {
        translate([0, 0, lid_plate_t / 2]) plate;
        lip;
    }
}

// ===================== PLACE PARTS ON BED =====================
// Box centred at origin
translate([0, 0, 0]) box_part();

// Lid on +X side, with 10mm gap
// Box right edge at x = 35
// Lid left edge should be at x = 35 + 10 = 45
// Lid is 70mm wide, so lid centre x = 45 + 35 = 80
translate([80, 0, 0]) lid_part();