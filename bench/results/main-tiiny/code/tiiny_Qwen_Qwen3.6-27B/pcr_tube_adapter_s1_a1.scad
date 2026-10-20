// Adapter sleeve: 0.2 mL PCR tube to 1.5 mL rack hole
// Dimensions measured with calipers

// Collar (base) dimensions
collar_diameter = 13;
collar_thickness = 1.5;

// Sleeve body dimensions
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5;

// Bore (inner hole) dimensions
bore_diameter = 6.2;

// Total height of part
total_height = collar_thickness + sleeve_height;

// Resolution for curved shapes
$fn = 64;

// Correct structure: difference with solid then bore
difference() {
    // Solid part
    union() {
        // Collar: rests on bed from z=0 to z=1.5
        translate([0, 0, 0])
            cylinder(h = collar_thickness, r = collar_diameter / 2, center = false);
        
        // Sleeve body: rises from collar to z=21.5
        translate([0, 0, collar_thickness])
            cylinder(h = sleeve_height, r = sleeve_outer_diameter / 2, center = false);
    }
    
    // Bore hole: extends 1 mm below z=0 and 1 mm above z=total_height
    translate([0, 0, -1])
        cylinder(h = total_height + 2, r = bore_diameter / 2, center = false);
}