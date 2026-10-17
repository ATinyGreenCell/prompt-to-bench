// Drying rack for microscope slides - a solid base block with a row of parallel slots cut into
// the top face so slides stand upright on their long edge. NOVEL general part (not a part I have
// designed before).
//

slides_per_row = 10;
slide_l = 75;
slide_w = 25;
slide_t = 1;
base_l = 90;
base_w = 45;
base_h = 20;
slot_l = 77;
slot_w = 1.6;
slot_d = 10;
slot_pitch = 3.5;

$fn = 48;

row_w = slide_w + slot_pitch;
rows = ceil(base_w / row_w);
fit   = base_l >= slide_l + 2;          // leave 1 mm clearance at each end in X
fit_y = base_w >= rows * row_w;         // room for the rows in Y

difference() {
    translate([-base_l / 2, -base_w / 2, 0]) cube([base_l, base_w, base_h]);
    for (r = [0 : rows - 1])
        for (c = [0 : slides_per_row - 1])
            translate([
                -base_l / 2 + slide_l / 2 + 1 + c * slot_pitch,
                -base_w / 2 + r * row_w + slide_w / 2 + 0.8,
                base_h - slot_d - 0.01
            ]) cube([slot_l, slot_w, slot_d]);
}