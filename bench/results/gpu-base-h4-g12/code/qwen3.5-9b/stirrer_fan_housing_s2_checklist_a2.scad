// DIY Magnetic Stirrer Housing - built upside down on the print bed.
// Top plate (z=0 to 2) with M4 screw holes, four walls rising to z=40.
// Outer size: 90x90mm. Fan size: 80x80mm.

$fn = 64;

// Dimensions
outer_w = 90;
outer_h = 90;
top_t   = 2;
wall_t  = 2.5;
box_h   = 40; // Total height from bed to open top
fan_w   = 80; // Inner clear width for the fan

// Screw holes
screw_d = 4.5;
screw_p = 71.5; // Pattern size (distance between centers)

// Cable notch
notch_w = 12;
notch_h = 8; // Depth from open edge (z=40) down to z=32

// Derived positions
// Hole positions: 71.5mm square pattern centered on origin.
// Distance from center to hole = 71.5 / 2 = 35.75.
hole_offset = screw_p / 2;

// Generate the four screw hole coordinates using a list comprehension.
// We want the pattern: (-,-), (+,-), (+,+), (-,+)
// i=0 -> (-,-), i=1 -> (+,-), i=2 -> (+,+), i=3 -> (-,+)
// Logic: X is positive for i=1,2. Y is positive for i=2,3.
screw_coords = [for (i = [0 : 3]) let(
    x = (i >= 1 && i <= 2) ? hole_offset : -hole_offset,
    y = (i >= 2 && i <= 3) ? hole_offset : -hole_offset
) [x, y]];

module build_housing() {
    difference() {
        // 1. The solid outer block
        translate([0, 0, 0]) 
            cube([outer_w, outer_h, box_h]);

        // 2. Cut the internal void (the fan space)
        // The void is centered, has size fan_w x fan_w, and goes from z=0 to z=box_h.
        // We extend the cut slightly past the top and bottom to ensure clean faces.
        translate([0, 0, -1]) 
            cube([fan_w, fan_w, box_h + 2]);

        // 3. Cut the four screw holes through the top plate
        // Holes are at z=0 to z=top_t.
        for (pos = screw_coords) {
            translate(pos)
                cylinder(h = top_t + 1, d = screw_d); // +1 to cut slightly past top
        }

        // 4. Cut the cable notch in one wall
        // Placed in the wall at X = -outer_w/2 + wall_t/2 (Left wall).
        // Notch width: notch_w.
        // Notch depth: notch_h (from open edge z=box_h down to z=box_h-notch_h).
        // Position: Centered along the wall (Y=0).
        
        wall_x_pos = -outer_w / 2 + wall_t / 2;
        
        translate([wall_x_pos, 0, box_h - notch_h])
            cube([notch_w, wall_t, notch_h]);
    }
}

build_housing();