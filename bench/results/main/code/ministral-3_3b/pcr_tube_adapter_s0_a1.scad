// Dimensions (mm)
$fn = 64;
D_collar = 13;      // Collar outer diameter
H_collar = 1.5;     // Collar thickness (height)
D_body = 10.8;      // Sleeve body outer diameter
H_sleeve = 21.5 - H_collar; // Total sleeve height minus collar
D_bore = 6.2;       // Bore diameter

// Define the collar (upside-down: lies on bed)
collar = difference(
    rotate([0, 0, 90], cylinder(h=H_collar, d1=D_collar + 0.5)),
    translate([0, 0, -0.25]) circle(r=(D_collar / 2) - 0.3)
);

// Define the body (rising from collar)
body = rotate_extrude(angle=90, axis=[0, 1, 0], $fn=$fn) (
    difference(
        translate([0, 0, H_collar/2]) circle(r=(D_body / 2)),
        union(
            translate([0, 0, -H_collar/2]) circle(r=(D_body / 2 + 1.0)),
            translate([0, 0, H_collar/2 + (H_sleeve/2)]) circle(r=(D_bore / 2))
        )
    )
);

// Combine collar and body
adapter = union(
    rotate([0, 0, -90], mirror(collar, [1, 0, 0])),
    translate([0, 0, H_collar/2]) body
);

// Bore through the full height (open at both ends)
bore_hole = cylinder(h=H_sleeve + H_collar, d1=D_bore);

adapter = difference(adapter, rotate([0, 0, -90], bore_hole));
module adapter() {
    return union(
        rotate([0, 0, -90], mirror(collar, [1, 0, 0])),
        translate([0, 0, H_collar/2]) body
    );
}
adapter = difference(adapter(), rotate([0, 0, -90], bore_hole));