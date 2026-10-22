// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, stacked linear_extrude()s, the collar by scale
$fn=128;
difference(){ union(){ linear_extrude(32) circle(d=25); translate([0,0,26]) linear_extrude(4, scale=33/25) circle(d=25); translate([0,0,30]) linear_extrude(2) circle(d=33); }
 translate([0,0,1.2]) linear_extrude(31) circle(d=22.6);
 for(i=[-5:5],j=[-5:5]) if(i*i+j*j<=25) translate([2*i,2*j,-1]) cylinder(d=1,h=3,$fn=12);
 for(s=[-1,1]) translate([s>0?12.5:-17.5,-1.5,25]) cube([5,3,8]); }
