// Adapter sleeve - a collar with a tube sleeve, for adapting a smaller tube to a rack
// made for a larger tube (e.g. a 0.2 mL PCR tube in a 1.5 mL tube rack). NOVEL part.
//

top     = 13;
clearance = 1.5;
sleeve_h = 21.5;
bore     = 6.2;

$fn = 72;

t = 1.5;

difference() {
    union() {
        cylinder(h = t, d = top);                 // collar (contact the rack surface)
        translate([0, 0, t]) cylinder(h = sleeve_h, d = outer(d = bore, clear = clearance));   // sleeve below the collar
    }
    translate([0, 0, -1]) cylinder(h = t + sleeve_h + 2, d = bore);                     // through-bore
}