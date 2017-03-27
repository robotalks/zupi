$fn = 360;

use <../lib/sg90.scad>;

translate([0, 0, 8]) sg90RudderSuppBall();
translate([8, 8, 0]) cube([0.1, 0.1, 0.1]);
