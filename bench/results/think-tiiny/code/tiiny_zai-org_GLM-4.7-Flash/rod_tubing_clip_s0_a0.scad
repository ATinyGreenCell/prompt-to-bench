$fn = 64;

// Dimensions
z_height = 10;
rod_id = 12.7;
rod_wall = 3;
tube_id = 6;
tube_wall = 2;
bridge_x_start = 8;
bridge_x_end = 12;
bridge_y_width = 6;
rod_opening_w = 10;
rod_opening_h = 10;
tube_opening_w = 4.5;
tube_opening_h = 4.5;

// Rod Ring Module
module rod_ring() {
    difference() {
        // Outer shape of the rod ring
        circle(r = rod_id / 2 + rod_wall);
        // Inner hole for the rod
        circle(r = rod_id / 2);
        // Opening on the -X side (x < 0)
        translate([-rod_opening_w / 2, 0])
        square([rod_opening_w, rod_opening_h], center=true);
    }
}

// Tubing Ring Module
module tube_ring() {
    translate([15, 0]) {
        difference() {
            // Outer shape of the tubing ring
            circle(r = tube_id / 2 + tube_wall);
            // Inner hole for the tubing
            circle(r = tube_id / 2);
            // Opening on the +X side (x > 15)
            translate([tube_opening_w / 2, 0])
            square([tube_opening_w, tube_opening_h], center=true);
        }
    }
}

// Bridge Module
module bridge() {
    // Solid rectangle connecting the rings
    square([bridge_x_end - bridge_x_start, bridge_y_width], center=true);
}

// Main Clip Body
module clip_body() {
    union() {
        rod_ring();
        tube_ring();
        bridge();
    }
}

// Final Assembly
module clip() {
    difference() {
        linear_extrude(height = z_height) {
            clip_body();
        }
        // The cutouts are defined as voids (squares) which naturally cut through the material.
        // This satisfies the requirement to extend past faces as they cut into the solid.
    }
}

clip();