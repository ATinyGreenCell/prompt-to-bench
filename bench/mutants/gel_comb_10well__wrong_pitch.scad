// 10 teeth 5 mm wide but 0.5 mm gaps (wells on the wrong pitch), spine 70 x 12
translate([-35,0,0]) cube([70,12,1.5]);
for (i=[0:9]) translate([-27.25 + i*5.5 - 2.5 + 2.5, -12, 0]) translate([-2.5+2.5,0,0]) cube([5,12.01,1.5]);
