// Snap-on clip for lab stand rod and tubing.
// Printed flat: 10 mm tall extrusion of a 2-D profile in the XY plane.

$fn = 64;

// Dimensions
rod_id   = 12.7;   // Rod inner diameter
rod_wall = 3;      // Rod ring wall thickness
rod_od   = rod_id + 2 * rod_wall; // Rod outer diameter (18.7)
tube_id  = 6;      // Tubing inner diameter
tube_wall = 2;     // Tubing wall thickness
tube_od  = tube_id + 2 * tube_wall; // Tubing outer diameter (10)
bridge_w = 6;      // Bridge width (Y)
bridge_x1 = 8;     // Bridge start X
bridge_x2 = 12;    // Bridge end X
tube_x   = 15;     // Tubing ring center X
clip_h   = 10;     // Extrusion height (Z)

// Rod ring opening
rod_open_w = 10;   // Opening width
rod_open_y = 5;    // Opening half-height (y from -5 to 5)

// Tubing ring opening
tube_open_w = 4.5; // Opening width
tube_open_y = 2.25; // Opening half-height (y from -2.25 to 2.25)

// Build the 2D profile in the XY plane, then extrude.
difference() {
    // 1. Rod Ring (Outer)
    // Centered at origin. Outer diameter 18.7.
    // We create a full circle and cut the opening.
    translate([0, 0, 0])
    linear_extrude(height = clip_h)
    difference() {
        circle(d = rod_od);
        // Cut opening: x < 0 and -5 < y < 5
        // We use a rectangle that extends slightly past the boundaries to ensure clean cut.
        translate([-rod_open_w / 2, -rod_open_y, 0])
        square([rod_open_w, rod_open_y * 2 + 0.1]);
    }

    // 2. Tubing Ring (Outer)
    // Centered at x = 15, y = 0. Outer diameter 10.
    translate([tube_x, 0, 0])
    linear_extrude(height = clip_h)
    difference() {
        circle(d = tube_od);
        // Cut opening: x > 15 and -2.25 < y < 2.25
        // Rectangle starts at x = 15, extends right.
        translate([tube_x, -tube_open_y, 0])
        square([tube_open_w + 0.1, tube_open_y * 2 + 0.1]);
    }

    // 3. Tubing Ring (Inner Hole)
    // Centered at x = 15, y = 0. Inner diameter 6.
    // Using circle() for 2D operation to avoid warnings.
    translate([tube_x, 0, 0])
    linear_extrude(height = clip_h)
    circle(d = tube_id);

    // 4. Rod Ring (Inner Hole)
    // Centered at origin. Inner diameter 12.7.
    // Using circle() for 2D operation to avoid warnings.
    linear_extrude(height = clip_h)
    circle(d = rod_id);

    // 5. Solid Bridge
    // Joins x=8 to x=12, width 6mm in Y.
    // It must not block the rod hole (y range approx -6.35 to 6.35) or tube hole (y range approx -3 to 3).
    // The bridge is placed at y=0 with width 6, so it spans y=-3 to y=3.
    // This is safe as it is inside the rod hole and inside the tube hole.
    translate([bridge_x1, -bridge_w / 2, 0])
    linear_extrude(height = clip_h)
    square([bridge_x2 - bridge_x1, bridge_w]);
}