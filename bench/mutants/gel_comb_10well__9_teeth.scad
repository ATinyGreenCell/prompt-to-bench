// only 9 teeth, 5.55 mm wide each, 1.5 mm gaps
translate([-35,0,0]) cube([70,12,1.5]);
for (i=[0:8]) translate([-31.725 + i*7.05, -12, 0]) cube([5.55,12.01,1.5]);
