// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres

// Outer Dimensions
$w_outer = 120; // Width (X)
$d_outer = 70;  // Depth (Y)
$h_outer = 40;  // Height (Z)

// Wall and Floor Thickness
$w_thick = 3;   // Wall thickness
$f_thick = 3;   // Floor thickness

// Platform Dimensions
$p_len = 60;    // Platform length (X)
$p_w = $d_outer; // Platform width (Y) - spans full inner width
$p_h_rel = 10;  // Platform height relative to inner floor
$p_z_abs = 13;  // Platform top absolute Z (calculated: floor_top + p_h_rel)

// Hole Dimensions
$h_dia = 2;     // Hole diameter
$h_y = 0;       // Hole Y position
$h_z = 30;      // Hole Z position

// Configuration
$fn = 128;      // Facets for smooth curves

// Derived Dimensions
$w_inner = $w_outer - 2*$w_thick;
$d_inner = $d_outer - 2*$w_thick;
$h_floor_top = $f_thick;
$h_inner = $h_outer - $f_thick;

// Main Tank Body
// Constructed as a hollow box with a solid floor
tank_body = translate([0, 0, 0])
    difference()
    {
        // Outer Shell
        cube([
            $w_outer, 
            $d_outer, 
            $h_outer
        ]);
        
        // Inner Void (Hollow part)
        // The void starts at the top of the floor and goes up to the top of the tank
        translate([
            $w_thick, 
            $w_thick, 
            $f_thick
        ])
        cube([
            $w_inner, 
            $d_inner, 
            $h_outer - $f_thick
        ]);
    };

// Raised Platform
// Spans full inner width (Y), centred in X, sits on the floor
platform = translate([
    ($w_outer - $p_len) / 2, // Centre X
    $w_thick,                // Align with inner wall Y
    $f_thick                 // Sit on top of floor
])
    cube([
        $p_len, 
        $p_w, 
        $p_h_rel
    ]);

// Assemble Final Part
final_part = union(
    tank_body,
    platform
);

// Difference to cut holes
result = difference()
{
    final_part;
    
    // Left End Hole
    translate([
        0, 
        $h_y, 
        $h_z
    ])
    cylinder(
        h = $w_outer + 2,
        r = $h_dia / 2,
        $fn = $fn
    );
    
    // Right End Hole
    translate([
        $w_outer, 
        $h_y, 
        $h_z
    ])
    cylinder(
        h = $w_outer + 2,
        r = $h_dia / 2,
        $fn = $fn
    );
};

// Output
result;