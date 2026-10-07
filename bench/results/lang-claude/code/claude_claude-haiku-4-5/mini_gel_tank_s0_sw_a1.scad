// Dimensions (mm)
ext_x = 120;      // External X dimension
ext_y = 70;       // External Y dimension
ext_z = 40;       // External Z dimension
wall = 3;         // Wall thickness
floor = 3;        // Floor thickness

// Platform parameters
plat_x = 60;      // Platform length in X (centered)
plat_z_top = 13;  // Platform top at Z=13 (10mm above inner floor at z=3)

// Electrode hole parameters
hole_d = 2;       // Hole diameter
hole_z = 30;      // Hole Z position (10mm from top)
hole_y = 0;       // Hole Y position (center)

// Resolution for circular features
$fn = 64;

// Calculated dimensions
inner_x = ext_x - 2 * wall;
inner_y = ext_y - 2 * wall;

// Build the complete part
difference() {
    union() {
        // Tank: hollow box with floor, open at top
        difference() {
            translate([-ext_x/2, -ext_y/2, 0])
                cube([ext_x, ext_y, ext_z]);
            translate([-inner_x/2, -inner_y/2, floor])
                cube([inner_x, inner_y, ext_z]);
        }
        
        // Platform: spans full inner Y width, raised 10mm above floor
        translate([-plat_x/2, -inner_y/2, floor])
            cube([plat_x, inner_y, plat_z_top - floor]);
    }
    
    // Left electrode hole through left wall
    translate([-ext_x/2 - 0.5, hole_y, hole_z])
        rotate([0, 90, 0])
        cylinder(r=hole_d/2, h=wall + 1);
    
    // Right electrode hole through right wall
    translate([ext_x/2 - wall - 0.5, hole_y, hole_z])
        rotate([0, 90, 0])
        cylinder(r=hole_d/2, h=wall + 1);
}