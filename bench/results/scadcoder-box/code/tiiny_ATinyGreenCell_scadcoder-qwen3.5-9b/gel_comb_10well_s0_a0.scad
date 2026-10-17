// Agarose gel casting comb - a flat plate with a back bar and a row of rectangular teeth, for
// casting rectangular gel wells. NOVEL general part (a generic comb, not any one labware item).
//

cols   = 10;
teeth_w = 5.0;
teeth_l = 12;
spine_l = 70;
spine_w = 12;
t      = 1.5;
gap    = 1.5;

$fn = 48;

g = teeth_w + gap;
p = spine_w + (cols - 1) * g;
w = min(spine_l, p);          // keep the tooth row inside the spine length
L = w / 2;
y  = (spine_w - teeth_w) / 2;   // center the row in the spine width

difference() {
    linear_extrude(t) rectangle([spine_l, spine_w]);           // base plate
    for (i = [0 : cols - 1])
        translate([-(w / 2 - teeth_w / 2) + i * g, -y, 0]) cube([teeth_w, teeth_l, t]);   // teeth
}