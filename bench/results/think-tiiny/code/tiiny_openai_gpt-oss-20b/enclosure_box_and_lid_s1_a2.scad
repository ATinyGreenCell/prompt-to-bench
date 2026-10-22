$fn = 64; // smooth curves

// ---------------------------
//  Box (electronics enclosure)
// ---------------------------
box_outer      = [70, 50, 30]; // X, Y, Z
box_wall       = 2;            // wall thickness
box_floor      = 2;            // floor thickness

module box() {
    // Outer solid
    outer = cube(box_outer, center=true);

    // Inner cavity dimensions
    cavity_inner = [
        box_outer[0] - 2*box_wall,   // X
        box_outer[1] - 2*box_wall,   // Y
        box_outer[2] - box_floor     // Z
    ];

    // Extend cavity a little past the box walls/floor
    cavity_inner = [
        cavity_inner[0] + 0.01,
        cavity_inner[1] + 0.01,
        cavity_inner[2] + 0.01
    ];

    // Cavity centre (Z) – 2 mm above the bottom of the box
    cavity_center_z = -box_outer[2]/2 + box_floor + cavity_inner[2]/2;

    cavity = translate([0, 0, cavity_center_z]) cube(cavity_inner, center=true);

    difference() {
        outer;
        cavity;
    }
}

// ---------------------------
//  Lid (printed upside‑down)
// ---------------------------
lid_plate      = [70, 50, 2];          // X, Y, Z
lid_lip_outer  = [65.6, 45.6, 4];      // X, Y, Z
lid_lip_thick = 1.5;                   // wall thickness
lid_lip_clear = 0.2;                   // clearance (not used directly)

module lid() {
    // Plate – sits on the bed (z = 0)
    plate = translate([0, 0, lid_plate[2]/2]) cube(lid_plate, center=true);

    // Lip outer shell
    lip_outer = cube(lid_lip_outer, center=true);

    // Lip inner cavity – extend a little beyond the lip walls
    lip_inner = cube(
        [lid_lip_outer[0] - 2*lid_lip_thick - 0.01,
         lid_lip_outer[1] - 2*lid_lip_thick - 0.01,
         lid_lip_outer[2] - 0.01],
        center=true
    );

    lip = difference() {
        lip_outer;
        lip_inner;
    };

    // Position the lip so its bottom is 0.01 mm below the plate top
    lip_center_z = lid_plate[2] + lid_lip_outer[2]/2 - 0.01;
    lip = translate([0, 0, lip_center_z]) lip;

    union() {
        plate;
        lip;
    }
}

// ---------------------------
//  Assemble both parts
// ---------------------------
gap = 10; // mm between box and lid

module assembly() {
    // Box is centred on the origin
    box();

    // Place the lid on the +X side of the box with the required gap
    translate([gap + box_outer[0]/2 + lid_plate[0]/2, 0, 0]) lid();
}

assembly();