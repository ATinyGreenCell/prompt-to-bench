// DIY magnetic stirrer housing (80 mm PC fan)
// Print orientation: upside down. Top plate on bed (z=0..2), walls rise to z=40.
// Outer size 90 x 90 mm.

// --- Dimensions (mm) ---
outer_x = 90;        // outer width in X
outer_y = 90;        // outer depth in Y
top_t   = 2;         // top plate thickness
wall_t  = 2.5;       // wall thickness
height  = 40;        // wall height (open top at z=40)

// M4 screw holes (fan mounting)
hole_d  = 4.5;       // hole diameter
hole_pitch = 71.5;   // square pitch, centred on plate

// Power cable notch
notch_w = 12;        // notch width
notch_depth = 8;     // notch depth from open edge (z=32..40)

// --- Build ---
// Top plate: 90 x 90 x 2, centred in X/Y, z = 0..2
plate = cube([outer_x, outer_y, top_t], center=[0,0,0]);

// Four walls, 2.5 mm thick, rising from z=2 to z=40
// Front wall (Y = -outer_y/2 .. -outer_y/2 + wall_t)
front = cube([outer_x, wall_t, height - top_t], center=[0, -outer_y/2 + wall_t/2, top_t + (height-top_t)/2]);
// Back wall (Y = outer_y/2 - wall_t .. outer_y/2)
back  = cube([outer_x, wall_t, height - top_t], center=[0, outer_y/2 - wall_t/2, top_t + (height-top_t)/2]);
// Left wall (X = -outer_x/2 .. -outer_x/2 + wall_t)
left  = cube([wall_t, outer_y, height - top_t], center=[-outer_x/2 + wall_t/2, 0, top_t + (height-top_t)/2]);
// Right wall (X = outer_x/2 - wall_t .. outer_x/2)
right = cube([wall_t, outer_y, height - top_t], center=[outer_x/2 - wall_t/2, 0, top_t + (height-top_t)/2]);

// M4 screw holes through the top plate, 71.5 mm square pattern, centred
// Holes extend 0.5 mm past the plate in Z to avoid coplanar faces
hole_z_ext = 0.5;
hole_z = top_t + hole_z_ext; // top of cut cylinder
hole_z_bot = -hole_z_ext;    // bottom of cut cylinder (below plate)

// Power cable notch: 12 mm wide, centred along the front wall,
// reaching 8 mm down from the open edge (z=32 to z=40)
notch_z_top = height;
notch_z_bot = height - notch_depth; // 32
notch_x = 0; // centred in X
notch_y = -outer_y/2 + wall_t/2;    // centred in the front wall

// --- Assemble ---
union() {
    // Base: plate + four walls
    union() {
        plate;
        front;
        back;
        left;
        right;
    }

    // Subtract M4 screw holes (4 holes on 71.5 mm square)
    difference() {
        union() {
            plate;
            front;
            back;
            left;
            right;
        }
        for (i = [-1, 1]) {
            for (j = [-1, 1]) {
                $fn = 64;
                cylinder(
                    h = hole_z - hole_z_bot,
                    d = hole_d,
                    center = [i * hole_pitch/2, j * hole_pitch/2, (hole_z + hole_z_bot)/2]
                );
            }
        }
    }

    // Subtract power cable notch from the front wall
    difference() {
        union() {
            plate;
            front;
            back;
            left;
            right;
        }
        // Notch: 12 mm wide (X), full wall thickness (Y), z=32..40
        // Extend 0.5 mm past the open top edge to avoid coplanar faces
        cube(
            [notch_w, wall_t + 1, notch_depth + 0.5],
            center = [notch_x, notch_y, notch_z_bot + (notch_depth + 0.5)/2]
        );
    }
}