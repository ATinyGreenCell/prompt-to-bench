// ---------- Parameters ----------
handle_d = 8;               // handle outer diameter (mm)
handle_r = handle_d/2;      // handle outer radius (mm)
handle_h = 45;               // handle height (mm)

cone_h = 17;                // cone height from z=45 to z=62 (mm)
cone_r_top = 1.5;           // cone top radius (mm) = tip diameter/2

sphere_r = 1.5;             // rounded tip sphere radius (mm)

groove_depth = 1;           // radial depth of each groove (mm)
groove_width_z = 2;         // axial width of each groove (mm)
groove_z = [10,15,20,25];   // Z‑centers of the four grooves (mm)

$fn = 64;                   // resolution for circles/spheres

// ---------- Modules ----------
module handle_body() {
    // Cylindrical handle
    cylinder(r=handle_r, h=handle_h, center=false);
    
    // Tapering cone (from z=handle_h to z=handle_h+cone_h)
    translate([0,0,handle_h])
        cylinder(r1=handle_r, r2=cone_r_top, h=cone_h, center=false);
    
    // Rounded tip sphere (centered at z=handle_h+cone_h)
    translate([0,0,handle_h+cone_h])
        sphere(r=sphere_r);
}

// Groove cutter: a thin cylindrical ring intersected with a Z‑slab
module groove_cutter(z_center) {
    extra = 0.02; // small over‑extension to avoid coplanar faces
    
    // Outer cylinder (full radius + extra)
    outer = cylinder(r=handle_r+extra, h=handle_h+2*extra, center=false);
    // Inner cylinder (radius reduced by groove depth, minus extra)
    inner = cylinder(r=handle_r-groove_depth-extra, h=handle_h+2*extra, center=false);
    // Ring = outer minus inner
    ring = difference() {
        outer;
        inner;
    }
    // Z‑slab that defines the groove's axial position
    slab = translate([0,0,z_center - groove_width_z/2 - extra])
           cube([2*handle_r+2*extra, 2*handle_r+2*extra, groove_width_z + 2*extra], center=false);
    // Intersection of ring and slab gives the groove volume
    intersection() {
        ring;
        slab;
    }
}

// ---------- Assembly ----------
module pestle() {
    difference() {
        handle_body();
        // Subtract the four circumferential grooves
        for (zc = groove_z) {
            groove_cutter(zc);
        }
    }
}

// ---------- Render ----------
pestle();