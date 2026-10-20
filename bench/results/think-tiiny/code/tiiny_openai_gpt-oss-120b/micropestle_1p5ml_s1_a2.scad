//---------------------------
//  Parameters (mm)
//---------------------------
handle_d = 8;                // diameter of cylindrical handle
handle_h = 45;              // height of cylindrical handle (z = 0 → 45)

cone_start_z = handle_h;    // z‑position where cone starts (45 mm)
cone_end_z = 62;            // z‑position where cone ends / tip centre (62 mm)
cone_start_d = handle_d;   // diameter at cone base (8 mm)
cone_end_d = 3;             // diameter at cone tip (3 mm)

tip_d = 3;                  // diameter of spherical tip
tip_center_z = cone_end_z; // z‑position of tip centre (62 mm)

groove_width_z = 2;         // axial width of each groove (mm)
groove_depth = 1;           // radial depth of each groove (mm)
groove_centers = [10,15,20,25]; // z‑positions of groove centres (mm)

over_z = 0.2;   // extra height beyond groove width to avoid coplanar faces
over_r = 0.5;   // extra radial extension beyond cylinder wall (mm)

//---------------------------
//  $fn for smooth curves
//---------------------------
$fn = 64;

//---------------------------
//  Main solid (handle + cone + tip)
//---------------------------
module pestle_solid() {
    // cylindrical handle
    translate([0,0,0])
        cylinder(r=handle_d/2, h=handle_h);
    
    // tapered cone
    translate([0,0,cone_start_z])
        cylinder(r1=handle_d/2, r2=tip_d/2,
                h=cone_end_z - cone_start_z);
    
    // rounded tip
    translate([0,0,tip_center_z])
        sphere(r=tip_d/2);
}

//---------------------------
//  Helper half‑space modules (for a 90° quadrant)
//---------------------------
module half_x() {               // x ≥ 0
    translate([0,-1000,-1000])
        cube([2000,2000,2000]);
}
module half_y() {               // y ≥ 0
    translate([-1000,0,-1000])
        cube([2000,2000,2000]);
}
module quadrant() {            // intersection of half‑spaces → one quadrant
    intersection() {
        half_x();
        half_y();
    }
}

//---------------------------
//  Single groove cutter (a 90° sector of a cylindrical shell)
//---------------------------
module groove_cutter(zc) {
    // centre the cutter at the requested z‑position, add over‑cut in Z
    translate([0,0,zc - (groove_width_z + over_z)/2])
        intersection() {
            // cylindrical shell (outer radius = handle_d/2, inner radius = handle_d/2 - groove_depth)
            difference() {
                cylinder(r=handle_d/2, h=groove_width_z + over_z, $fn=64);
                cylinder(r=handle_d/2 - groove_depth, h=groove_width_z + over_z, $fn=64);
            }
            // keep only one 90° sector
            quadrant();
        }
}

//---------------------------
//  Final part (solid minus grooves)
//---------------------------
difference() {
    pestle_solid();
    // cut the four circumferential grooves at their specified heights
    for (z = groove_centers)
        for (ang = [0,90,180,270])
            rotate([0,0,ang])
                groove_cutter(z);
}