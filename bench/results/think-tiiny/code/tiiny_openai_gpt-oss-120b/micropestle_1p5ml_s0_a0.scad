// Parameters (mm)
handle_diameter = 8;               // cylindrical handle outer diameter
handle_radius   = handle_diameter/2;
handle_height   = 45;              // handle height

cone_top_diameter = 3;            // cone top diameter
cone_top_radius   = cone_top_diameter/2;
cone_height       = 62 - handle_height; // cone height (45 → 62)

sphere_diameter = 3;               // tip sphere diameter
sphere_radius   = sphere_diameter/2;

groove_width_z = 2;                // groove thickness in Z direction
groove_depth   = 1;                // groove radial depth
groove_centers = [10,15,20,25];    // Z‑positions of groove centres

$fn = 64; // smooth circles

// ---------- Main solid (handle + cone + tip) ----------
module body() {
    union() {
        // cylindrical handle
        cylinder(h = handle_height, r = handle_radius);
        // tapered cone
        translate([0,0,handle_height])
            cylinder(h = cone_height, r1 = handle_radius, r2 = cone_top_radius);
        // rounded tip
        translate([0,0,handle_height + cone_height])
            sphere(r = sphere_radius);
    }
}

// ---------- Groove cut (a circumferential ring) ----------
module groove(z_center) {
    // Groove is a cylindrical ring 1 mm deep, 2 mm tall
    // placed so its centre is at the given z_center
    translate([0,0, z_center - groove_width_z/2])
        difference() {
            // outer cylinder (extends slightly beyond the outer surface)
            cylinder(h = groove_width_z + 0.02, r = handle_radius + 0.01);
            // inner cylinder (slightly smaller than the desired inner radius)
            cylinder(h = groove_width_z + 0.04,
                     r = handle_radius - groove_depth - 0.01);
        }
}

// ---------- Final part with grooves ----------
module pestle_with_grooves() {
    difference() {
        body();                         // solid to be printed
        union() {                       // all groove cuts together
            for (z = groove_centers) groove(z);
        }
    }
}

// ---------- Render ----------
pestle_with_grooves();