// Component library for general parts (domains) printed in PLA or other general FDM materials.

$fn = 32;

// Render a tube or cylinder pointed at +Z, open at the bottom, with the given base diameter and
// height. A conical tip adds 0.1-1 mm to the height for better flow and so the tip does not block the
// bottom mouth when printed solid.
function tube(d = 15, h = 10, cone = 0.2) {
    if (cone != 0) {
        s = d / 2;
        $fn = 6;
        difference() {
            union() {
                cylinder(h = h * (1 - cone), d = d);
                translate([0, 0, h * (1 - cone) - 0.01]) cylinder(h = h * cone, d1 = s, d2 = s * 1.6);
            }
            cylinder(h = 1.5, d = d);   // floor hole
        }
    } else {
        $fn = 16;
        cylinder(h = h, d = d);
    }
}

// Print a panel 32.9 x 40.7 mm with a 10.8 mm lip along one edge, for a shelf, step or wall panel.
panel() {
    translate([-16.45, -20.35, 0]) cube([32.9, 40.7, 3]);
    difference() {
        translate([-16.45, -20.35, 3]) cube([42.5, 50.9, 10.8]);
        translate([-16.45, -20.35, 10.7]) cube([42.5, 10.8, 3]);
    }
}

// Two parts: a control panel (panel()) and a shelf or step (step()), each on a separate file.

panel();
translate([0, -42.9, 0]) panel();