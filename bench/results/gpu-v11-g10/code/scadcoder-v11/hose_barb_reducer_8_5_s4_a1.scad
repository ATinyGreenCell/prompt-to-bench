// Hose-barb reducer: 8 mm tubing (barbs) -> 5 mm tubing (barbs)
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 64;

// ---- Dimensions (mm) ----
small_id      = 8;    // inner diameter of larger tubing
large_id      = 5;    // inner diameter of smaller tubing
bore          = 3;    // through-bore diameter
barb_count    = 2;    // number of barbs per section (stacked)
base_z        = 0;    // start of first barbs
collar_z      = 20;   // start of collar
collar_top_z  = 25;   // end of collar
small_barb_z  = 25;   // start of small tubing barbs
small_barb_h  = 8;    // height of each small barb
eps           = 0.5;  // overcut for clean differences

// ---- Derived ----
collar_h = collar_top_z - collar_z;
x0 = bore / 2;  // bore radius
// Stack offset so barbs touch end-to-end along Z
pitch = (small_barb_h + eps) * barb_count;

// Outer diamences (tube + wall); wall thickened at steps for strength
od = function(d) {
    w = 1.5;                          // wall
    return d + 2 * w + abs(d - 5) * 0.5;  // 8 mm gets +1.5, 5 mm gets +0
};

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs
        for (i = [0 : barb_count - 1])
            translate([0, 0, base_z + i * pitch])
                linear_extrude(height = small_barb_h + (i < barb_count - 1 ? eps : 0))
                    polygon([
                        [x0, 0],
                        [od(8) / 2, 0],
                        [od(8) / 2, small_barb_h],
                        [7.5 / 2, small_barb_h]
                    ]);

        // Collar
        translate([0, 0, collar_z])
            cylinder(h = collar_h, d = 12);

        // 5 mm tubing barbs
        for (i = [0 : barb_count - 1])
            translate([0, 0, small_barb_z + i * pitch])
                linear_extrude(height = small_barb_h + (i < barb_count - 1 ? eps : 0))
                    polygon([
                        [x0, 0],
                        [od(5) / 2, 0],
                        [od(5) / 2, small_barb_h - eps],
                        [6.5 / 2, small_barb_h - eps]
                    ]);
    }

    // Through bore
    translate([0, 0, -eps])
        cylinder(h = small_barb_z + 2 * eps + collar_h + 2 * eps + small_barb_h + 2 * eps, d = bore);
}