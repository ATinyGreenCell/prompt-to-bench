// Define dimensions
$fn = 64; // Number of facets for rounded edges

// Outer diameter of the reducer
outer_diameter_8mm = 9.5;
outer_diameter_5mm = 6.5;

// Inner diameter of the reducer
inner_diameter = 7.0;

// Height of each barb
barb_height = 10;

// Length of the reducer
length = 41;

// Create the outer shell of the reducer
difference() {
    // Outer surface of the reducer
    union() {
        for (z=[0:20]) {
            polygon([
                [outer_diameter_8mm, barb_height],
                [inner_diameter, barb_height],
                [inner_diameter, 0]
            ], center=true);
        }
        for (z=[25:41]) {
            polygon([
                [outer_diameter_5mm, barb_height],
                [inner_diameter, barb_height],
                [inner_diameter, 0]
            ], center=true);
        }
    }

    // Inner surface of the reducer
    translate([0, 0, -inner_diameter/2]) {
        cube([outer_diameter_8mm, outer_diameter_5mm, inner_diameter], center=true);
    }
}

// Create the cylindrical collar
translate([0, 0, length-inner_diameter/2]) {
    cylinder(r=12, h=length-inner_diameter, center=true);
}