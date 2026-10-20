// Dimensions for 0.2 mL PCR Tube Adapter
// Units: mm

// Outer Diameter of the main sleeve body
sleeve_od = 10.8;
// Diameter of the collar that sits on the bed
collar_od = 13.0;
// Height of the collar (thickness)
collar_height = 1.5;
// Total height of the sleeve body
// Adjusted to 20.0 mm to accommodate the 1.5 mm collar and meet the 21.5 mm total height spec
sleeve_height = 20.0;
// Diameter of the bore (hole) for the tube
bore_diameter = 6.2;
// Wall thickness of the sleeve
wall_thickness = (sleeve_od - bore_diameter) / 2;

// Rendering settings
$fn = 64;

module main() {
    // The part is built on the XY plane (z=0) and grows upwards.
    
    // 1. The Base Collar
    // A flat disc that sits on the bed (bottom at z=0)
    cylinder(d = collar_od, h = collar_height);
    
    // 2. The Main Sleeve Body
    // Extrudes from the top of the collar to the full height
    translate([0, 0, collar_height])
        cylinder(d = sleeve_od, h = sleeve_height);
    
    // 3. The Bore
    // A cylinder cut through the entire part
    // Extends 0.01mm past the top and bottom faces to ensure clean cuts
    cylinder(d = bore_diameter, h = sleeve_height + collar_height + 0.02);
}

// Render the part
main();