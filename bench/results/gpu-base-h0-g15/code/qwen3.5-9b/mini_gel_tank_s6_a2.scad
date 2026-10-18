// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
$w_outer = 120; // Width (X)
$d_outer = 70;  // Depth (Y)
$h_outer = 40;  // Height (Z)

// Wall and Floor Thickness
$wall_thick = 3;
$floor_thick = 3;

// Platform Dimensions
$plat_len = 60;   // Length in X
$plat_width = $d_outer - 2*$wall_thick; // Spans full inner width (Y)
$plat_height = 10; // Height above inner floor

// Hole Dimensions
$hole_dia = 2;
$hole_y = 0;
$hole_z = 30;

// Configuration
$fn = 128; // High resolution for smooth curves

// Derived Dimensions
$inner_w = $w_outer - 2*$wall_thick;
$inner_d = $d_outer - 2*$wall_thick;
$inner_h = $h_outer - $floor_thick;
$inner_floor_z = $floor_thick;

// Main assembly
difference() {
    union() {
        // Main Tank Block
        translate([0, 0, 0]) {
            cube([
                $w_outer, 
                $d_outer, 
                $h_outer
            ]);
        }
        
        // Cut Top (Open Tank)
        translate([0, 0, $h_outer - $wall_thick]) {
            cube([
                $w_outer, 
                $d_outer, 
                $wall_thick + 0.1
            ]);
        }
        
        // Cut Floor
        translate([0, 0, 0]) {
            cube([
                $w_outer, 
                $d_outer, 
                $floor_thick + 0.1
            ]);
        }
        
        // Raised Platform
        translate([
            ($w_outer - $plat_len) / 2, 
            0, 
            $inner_floor_z + $plat_height
        ]) {
            cube([
                $plat_len,
                $plat_width,
                $plat_height
            ]);
        }
    }
    
    // Drill Holes
    // Left end wall hole
    translate([
        -$w_outer/2 + $wall_thick/2, 
        $hole_y,
        $hole_z
    ]) {
        cylinder(
            h = $w_outer - 2*$wall_thick + 0.1, 
            r = $hole_dia/2 + 0.1,
            $fn = $fn
        );
    }
    
    // Right end wall hole
    translate([
        $w_outer/2 - $wall_thick/2, 
        $hole_y,
        $hole_z
    ]) {
        cylinder(
            h = $w_outer - 2*$wall_thick + 0.1, 
            r = $hole_dia/2 + 0.1,
            $fn = $fn
        );
    }
}