// Dimensions in mm
spine_length = 70;
spine_width = 12;
tooth_width = 5;
tooth_length = 12;
gap_between_teeth = 1.5;

// Plate dimensions (same as comb width)
plate_width = spine_width + tooth_width * 10 + gap_between_teeth * 9;

// Height of the comb
comb_height = 1.5;

// Build the comb
translate([0, -spine_length/2, 0])
    linear_extrude(comb_height)
        square(spine_width, center=true);

for (i = [0:9])
    translate([(tooth_width + gap_between_teeth * i)/2, spine_length/2, 0])
        linear_extrude(comb_height)
            rectangle([tooth_length, tooth_width], center=true);

// Mirror the comb to create the other side
mirror([0,1,0]) 
translate([0, -spine_length/2, 0])
linear_extrude(comb_height) 
square(spine_width, center=true);
    
for (i = [0:9])
    translate([(tooth_width + gap_between_teeth * i)/2, spine_length/2, 0])
        linear_extrude(comb_height)
            rectangle([tooth_length, tooth_width], center=true);