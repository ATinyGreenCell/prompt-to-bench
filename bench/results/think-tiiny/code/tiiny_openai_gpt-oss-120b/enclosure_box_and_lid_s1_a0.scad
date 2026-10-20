// ---------- Parameters ----------
$fn = 64;                         // resolution for curved shapes

// Box (Part 1)
box_outer_x = 70;                 // outer size X (mm)  // measured
box_outer_y = 50;                 // outer size Y (mm)  // measured
box_outer_z = 30;                 // outer size Z (mm)  // measured
wall_thick = 2;                  // wall thickness (mm)
floor_thick = 2;                 // floor thickness (mm)

// Lid (Part 2)
lid_outer_x = 70;                 // plate size X (mm)
lid_outer_y = 50;                 // plate size Y (mm)
lid_plate_thick = 2;              // plate thickness (mm)
lid_lip_outer_x = 65.6;           // lip outer size X (mm)
lid_lip_outer_y = 45.6;           // lip outer size Y (mm)
lid_wall_thick = 1.5;             // lip wall thickness (mm)
lid_lip_height = 4;               // lip height (mm)

// Layout
gap = 10;                         // gap between box and lid (mm)

// Cutting tolerance (extend cuts beyond faces)
cut_extend = 0.5;                 // (mm) 0.01‑1 mm as per rules

// ---------- Modules ----------
module box_part() {
    // outer solid (centered at origin)
    outer = cube([box_outer_x, box_outer_y, box_outer_z], center = true);
    
    // inner cavity (slightly larger than interior to avoid coplanar faces)
    inner_dim_x = box_outer_x - 2*wall_thick + 2*cut_extend;
    inner_dim_y = box_outer_y - 2*wall_thick + 2*cut_extend;
    inner_dim_z = box_outer_z - floor_thick + 2*cut_extend;
    // cavity is centered at Z = floor_thick/2 (so floor stays 2 mm thick)
    inner = translate([0, 0, floor_thick/2])
            cube([inner_dim_x, inner_dim_y, inner_dim_z], center = true);
    
    difference() {
        outer;
        inner;
    }
}

module lid_part() {
    // plate (bottom of lid)
    plate = translate([0, 0, lid_plate_thick/2])
            cube([lid_outer_x, lid_outer_y, lid_plate_thick], center = true);
    
    // lip outer block
    lip_outer = translate([0, 0, lid_plate_thick + lid_lip_height/2])
                cube([lid_lip_outer_x, lid_lip_outer_y, lid_lip_height], center = true);
    
    // lip inner cavity (extended a little in Z to cut cleanly)
    lip_inner = translate([0, 0, lid_plate_thick + lid_lip_height/2])
                cube([lid_lip_outer_x - 2*lid_wall_thick,
                      lid_lip_outer_y - 2*lid_wall_thick,
                      lid_lip_height + 2*cut_extend],
                     center = true);
    
    // combine plate and lip wall
    union() {
        plate;
        difference() {
            lip_outer;
            lip_inner;
        }
    }
}

// ---------- Assembly ----------
box_part();                                   // box stays at origin

// place lid on the +X side with a 10 mm gap
translate([box_outer_x/2 + gap + lid_outer_x/2, 0, 0])
    lid_part();