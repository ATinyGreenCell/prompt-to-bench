// Dimensions in millimeters
$fn = 64;

// Define variables for dimensions
outer_diameter_spout = 10; // outer diameter of spout, mm
wall_thickness = 1.6; // wall thickness, mm

// Calculate inner diameters and heights
inner_diameter_spout = outer_diameter_spout - wall_thickness;
height_cone_top = 20; // height from z=0 to cone top, mm
radius_cone_top = outer_diameter_spout / 2; // radius at the top of the cone

// Define variables for coordinates and extrusion
z_start = 0; // start point in Z direction
z_end = 50; // end point in Z direction
x_center = 0; // center point in X direction
y_center = 0; // center point in Y direction
radius_spout = outer_diameter_spout / 2; // radius of the spout

// Define variables for extrusion and rotation angles
extrude_height = z_end - z_start;
rotation_angle = 360 / (10 * $fn); // angle per hole, based on number of holes

// Create the funnel as a union of two parts: the cone and the spout
union() {
    // Cone part
    sphere(inner_diameter_spout, radius_cone_top);
    
    for (i = [0 : 10 * $fn]) {
        translate([x_center, y_center, z_start + i * extrude_height])
            rotate([0, rotation_angle * i, 0])
                cylinder(r=radius_spout, h=height_cone_top - radius_cone_top);
    }
    
    // Spout part
    sphere(inner_diameter_spout, radius_spout);
}

// Print orientation: open at the top and bottom, upright
translate([x_center, y_center, 0])
    rotate([90, 0, 0])
        cube([2 * outer_diameter_spout, 1.6, extrude_height + wall_thickness]);