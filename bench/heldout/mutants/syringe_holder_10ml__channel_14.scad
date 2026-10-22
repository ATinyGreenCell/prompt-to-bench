// KNOWN-WRONG PART (must fail): the barrel channel is 14 mm wide (too narrow for the barrel)
// Wall-mounted holder for a 10 mL syringe hanging upright, tip down (gravity-feed reservoir)
// Category: hardware. A block with a vertical U-shaped barrel channel open at the front, a
// horizontal slot that takes the finger flange, and two M4 wall-screw holes from front to back.
// Print: PETG or PLA, standing on its bottom face; the flange slot roof bridges 34 mm.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Holder] */
block = [50, 30, 40];     // X (width), Y (depth), Z (height) [mm]; back face at y = +15
channel_w = 14;           // 16 mm barrel + clearance; half-circle back end centred at (0, 0)
slot = [34, 2.6];         // flange slot width (X) and height (Z)
slot_z = 30;              // slot from z = 30 to 32.6
slot_back_y = 11;         // the slot reaches from the front face back to y = 11
screw_d = 4.5;            // M4 clearance
screw_x = 19;
screw_z = 15;

/* [Hidden] */
eps = 0.01;

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    // barrel channel, open toward -Y (the front)
    translate([0, 0, -1]) linear_extrude(block.z + 2) {
        circle(d = channel_w, $fn = 96);
        translate([-channel_w / 2, -block.y / 2 - 1]) square([channel_w, block.y / 2 + 1]);
    }
    // flange slot, cut in from the front face
    translate([-slot.x / 2, -block.y / 2 - 1, slot_z]) cube([slot.x, slot_back_y + block.y / 2 + 1, slot.y]);
    // wall-screw holes, front to back
    for (s = [-1, 1])
        translate([s * screw_x, 0, screw_z]) rotate([90, 0, 0])
            cylinder(d = screw_d, h = block.y + 2, center = true, $fn = 48);
}
