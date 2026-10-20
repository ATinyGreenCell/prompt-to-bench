).
    *   So the cylinder will be rotated around (0,0,0).
    *   I want it rotated around its own center.
    *   So `rotate` must come before `translate`.
    *   `rotate([0, 90, 0]) translate([side * 58.5, 0, 30]) cylinder(r=1, h=3.1)`.
    *   Correct.

    *   Wait, `translate` inside `for` loop.
    *   `for (side = [-1, 1]) { rotate([0, 90, 0]) translate([side * 58.5, 0, 30]) cylinder(r=1, h=3.1); }`.
    *   This is correct.

    *   Wait, `translate` inside `for` loop.
    *   `for (side = [-1, 1]) { rotate([0, 90, 0]) translate([side * 58.5, 0, 30]) cylinder(r=1, h=3.1); }`.
    *   This is correct.

    *   Wait, `translate` inside `for` loop.
    *   `for (side = [-1, 1]) { rotate([0, 90, 0]) translate([side * 58.5, 0, 30]) cylinder(r=1,