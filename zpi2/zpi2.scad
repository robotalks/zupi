$fn = 360;

use <../lib/camera.scad>;
use <../lib/sg90.scad>;
use <pantilt.scad>;

function forSub(v) = v + 0.2;

thick = 2;

neckBottomH = 6;
neckBottomR = 5;

module neckTop() {
    difference() {
        union() {
            translate([0,0,-0.1]) cylinder(h=2,r=3.25);
            translate([0,0,1.8]) cylinder(h=3.5,r=3.85); // 1.95
        }
        translate([0,0,-0.3]) cylinder(h=6,r=2.2);
        translate([0,0,3.75]) {
            union() {
                translate([-4,1.3,0]) cube([8,3,2]);
                translate([-4,-4.3,0]) cube([8,3,2]);
            }
        }
    }
}

module neckBottom() {
    difference() {
        cylinder(h = neckBottomH,r = neckBottomR);
        translate([0,0,20]) cylinder(h=4.1,r=2.2);
    }
}

module neck() {
    union() {
        translate([0,0,neckBottomH]) neckTop();
        neckBottom();
    }
}

boardThick = 3.2;
holeM2 = 2;
holeM2R = holeM2/2;
holeM3 = 3;
holeM3R = holeM3/2;
holeScrewCap = 4.5;
holeScrewCapR = holeScrewCap/2;

ext0CX = 75;
ext0CY = 66;
ext0HoleFDist = 50;
ext0HoleFOff = 6;
ext0HoleRDist = 55;
ext0HoleFRDist = 63;

module extBoard0() {
    ox = ext0CX/2-ext0HoleFOff;
    oy = -ext0HoleFDist/2;
    difference() {
        union() {
            cube([ext0CX, ext0CY, boardThick], true);
            // servo connector shelf
            translate([ox-20-12.8, oy-11+16, -(2+4.5)/2])
                cube([44, 26, 2+4.5], true);
        }
        // front holes
        translate([ox, -oy, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        translate([ox, oy, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        // rear holes
        translate([ox-ext0HoleFRDist, ext0HoleRDist/2, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        translate([ox-ext0HoleFRDist, -ext0HoleRDist/2, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        // up board hole
        translate([ox+3.3, oy-2.8, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        // servo board hole
        translate([ox+1, oy+31, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        translate([ox+1, oy+12, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        translate([ox+1-56, oy+31, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        translate([ox+1-56, oy+12, 0])
            cylinder(h = forSub(boardThick), d = holeM2, center = true);
        // servo board capacitor hole
        translate([ox-6-2, oy+6+24, 0])
            cube([12, 12, forSub(boardThick)], true);
        // pcb connector hole
        translate([ox-30-2, oy-3.5+42.6, 0])
            cube([60, 7, forSub(boardThick)], true);
        // servo ctl connector slot
        translate([ox-2.5-54.5, oy-7.6+29, 0])
            cube([5, 15.2, forSub(boardThick)], true);
        // servo connector space
        translate([ox-20-12.8, oy-13+16, 0])
            cube([40, 26, 9], true);
        // space for level shift
        translate([ox-17-22.8, oy-7+20, -4.5-boardThick/2])
            cube([34, 14, 9], true);
    }
}

module extBoard0ForSupp() {
    difference() {
        cube([ext0CX+10, ext0CY+10, 0.2], true);
        cube([ext0CX+8, ext0CY+8, 0.4], true);
    }
    translate([0, 0, 8]) extBoard0();
}

swingL = 36;
swingD = 36;

module camBase() {
    union() {
        rotate([0, 0, 90]) neck();
        cube([16, swingD, 4], true);
        //difference() {
        //    cylinder(h = 10, d = 15);
        //    cylinder(h = 10.1, d = 11);
        //}
    }
}

module camTilt() {
    swing(32);
    translate([0, 0, swingL]) camBase();
}

module cam32Tilt() {
    translate([0, -0.6, 0]) swing(28, 15);
    translate([0, 0, 28+8]) mirror([0, 0, 1]) cam32Supp();
}

module cam32TiltRack() {
    translate([0, sg90RudderLongR()/2+2.6, (sg90OuterSize()[0])/2+0.8]) 
    rotate([0, 90, 0]) mirror([0, 0, 1]) translate(-sg90CenterOff()) sg90Rack();
    mirror([0, 0, -1]) sg90RudderTopLong(ball = false, rudder = false);
}

frontEmitBoardSp = 2.2;
frontEmitBottomL = 8.4;
frontEmitBottomM = 3;
frontEmitTopL = 4;
frontEmitSuppCY = 58;
frontEmitH = 8;
frontRcvSuppH = 18;
frontRcvSuppCX = 3;
frontSuppThick = 1.2;
frontAnchorCX = 6.8;
frontAnchorCY = 8.5;
frontAnchorDist = 41.6;
frontAnchorHoleOff = 3.8;
baseSuppH = 11.6;
baseSuppOff = 52;
baseSuppL = 3.5;
baseSuppCY = 5;
baseSuppDist = 49;
baseSuppOffRsv = frontAnchorCX;
baseSuppExtCX = 11;
baseSuppExtSCX = 4;

module frontAnchorHoles() {
    translate([-frontAnchorHoleOff, frontAnchorDist/2+frontAnchorCY/2, 0])
        cylinder(h = baseSuppH*3, d = 4.6, center = true);
    translate([-frontAnchorHoleOff, -frontAnchorDist/2-frontAnchorCY/2, 0])
        cylinder(h = baseSuppH*3, d = 4.6, center = true);
}

module frontBumpEmitSupp() {
    difference() {
        union() {
            d = (frontEmitBottomL - frontEmitTopL) * frontEmitH / (frontEmitH+thick+frontSuppThick);
            translate([0, frontEmitSuppCY/2, 0])
            rotate([90, 0, 0])
            linear_extrude(height = frontEmitSuppCY) polygon([
                [frontEmitBottomM, 0], [frontEmitBottomL+thick*2, 0],
                [frontEmitTopL+thick, frontEmitH+thick+frontSuppThick],
                [0, frontEmitH+thick+frontSuppThick], [0, frontEmitH+frontSuppThick],
                [frontEmitTopL, frontEmitH+frontSuppThick], [frontEmitBottomL, frontSuppThick],
                [frontEmitBottomM, frontSuppThick]
            ]);
            //translate([-frontAnchorCX/2, frontAnchorDist/2+frontAnchorCY/2, frontSuppThick/2])
            //    cube([frontAnchorCX, frontAnchorCY, frontSuppThick], true);
            //translate([-frontAnchorCX/2, -frontAnchorDist/2-frontAnchorCY/2, frontSuppThick/2])
            //    cube([frontAnchorCX, frontAnchorCY, frontSuppThick], true);
            translate([frontEmitBottomL+frontRcvSuppCX/2, 0, -frontRcvSuppH/2])
                cube([frontRcvSuppCX, frontEmitSuppCY, frontRcvSuppH], true);
        }
        // for emitters
        translate([frontEmitBottomL/2+thick*2-0.1, frontEmitSuppCY/2-4.9, frontEmitH+frontSuppThick])
            cube([frontEmitBottomL+thick*4+0.2, 10, frontEmitH*2], true);
        translate([frontEmitBottomL/2+thick*2-0.1, -frontEmitSuppCY/2+4.9, frontEmitH+frontSuppThick])
            cube([frontEmitBottomL+thick*4+0.2, 10, frontEmitH*2], true);
        //frontAnchorHoles();

        // save materials
        h = frontRcvSuppH - thick * 4;
        cy = frontEmitSuppCY/4 - thick * 4;
        d = frontEmitSuppCY/4;
        for (i = [0:3]) {
            translate([frontEmitBottomL+frontRcvSuppCX/2, (i-2)*d+d/2, -frontRcvSuppH/2])
                difference() {
                    cube([frontRcvSuppCX+0.2, cy, h], true);
                    /*
                    translate([0, -cy/4, 0])
                        union() {
                            rotate([0, 0, 45]) cube([frontRcvSuppCX, 0.2, h+0.2], true);
                            rotate([0, 0, -45]) cube([frontRcvSuppCX, 0.2, h+0.2], true);
                        }
                    translate([0, cy/4, 0])
                        union() {
                            rotate([0, 0, 45]) cube([frontRcvSuppCX, 0.2, h+0.2], true);
                            rotate([0, 0, -45]) cube([frontRcvSuppCX, 0.2, h+0.2], true);
                        }
                    */
                }
        }
    }
}

module baseSuppBar(side) {
    cx = baseSuppOff + baseSuppL;
    difference() {
        translate([-cx/2, 0, baseSuppH/2])
            cube([cx, baseSuppCY, baseSuppH], true);
        translate([-baseSuppOff/2, 0, baseSuppH/2-baseSuppH*3/4])
            cube([baseSuppOff, forSub(baseSuppCY), baseSuppH], true);

        translate([-baseSuppOff/2+baseSuppL*2-baseSuppOffRsv+0.1, (baseSuppCY-thick)*side, baseSuppH/2])
            cube([baseSuppOff-baseSuppL*4, baseSuppCY, forSub(baseSuppH)], true);

        translate([-baseSuppOff/2+baseSuppL*2-baseSuppOffRsv+0.1, 0, 0])
            cube([baseSuppOff-baseSuppL*4, forSub(baseSuppCY), forSub(baseSuppH)], true);

        translate([-baseSuppOffRsv/2+0.1, 0, forSub(baseSuppH)/2])
            cube([baseSuppOffRsv+0.2, forSub(baseSuppCY), forSub(baseSuppH)], true);
    }
}

module baseSupp() {
    difference() {
        union() {
            frontBumpEmitSupp();
            translate([0, (baseSuppDist+baseSuppCY)/2, 0]) baseSuppBar(1);
            translate([0, -(baseSuppDist+baseSuppCY)/2, 0]) baseSuppBar(-1);
            // connect base supp bars with frontBumpEmitSupp();
            translate([-baseSuppExtCX/2-baseSuppExtSCX, 0, baseSuppH/4+baseSuppH/2])
                cube([baseSuppExtCX, baseSuppDist, baseSuppH/2], true);
            translate([-baseSuppExtSCX/2, 0, frontEmitH+frontSuppThick+thick/2+0.2])
                cube([baseSuppExtSCX, baseSuppDist, thick+0.4], true);
        }
        // re-apply anchor holes
        frontAnchorHoles();
        translate([-thick*3, 0, frontEmitH/2])
            cube([thick*2, baseSuppDist/2, frontEmitH*4], true);
    }
}

module baseSuppForPrint() {
    h = frontEmitH+thick+frontSuppThick;
    rotate([180, 0, 0])
    union() {
        baseSupp();
        /*
        translate([0, -(frontEmitSuppCY-20)/2, h])
            cube([frontEmitBottomL+thick*2, frontEmitSuppCY-20, 0.2]);
        translate([frontEmitBottomL, -(frontEmitSuppCY-20)/2, h/2]) cube([0.2, frontEmitSuppCY-20, h/2]);
        translate([frontEmitBottomL+thick, -(frontEmitSuppCY-20)/2, 0]) cube([0.2, frontEmitSuppCY-20, h]);
        */
    }
    translate([-baseSuppOff, 0, -h-4]) cube([1, 1, 0.1], true);
}

topSuppThick = 4;
topSuppCY = 66;
topSuppCX = 88;
topAnchorDistY = 42;
topAnchorDistX = 63;
topAnchorLOffY = 18;
topAnchorROffY = topAnchorDistY - topAnchorLOffY;
topAnchorFOffX = topSuppCX/2-4;
topAnchorROffX = topAnchorDistX - topAnchorFOffX;
topCamOff = 6.5;
topCamDX = topAnchorFOffX-topCamOff-topAnchorDistX/2;
topSuppSideH = 21;
topSuppHoleMargin = 6;
topSuppHoleH = topSuppSideH - topSuppHoleMargin * 2;
topSuppSideHoleW = 10;
topSuppFrontHoleW = 6;
topSuppFrontLowDist = 33;
topSuppFrontLowCY = topAnchorROffY*2;
topSuppFrontLowH = topSuppFrontLowDist - topSuppSideH;
topSuppFrontLowHoleH = 4;

topSuppSlotW = 8;
topSuppSlotCY = 35;
topSuppSlotCX = 50;
topSuppSlotRW = 12;
topSuppSlotOffF = 3+topSuppSlotW/2;
topSuppSlotOffR = 3+topSuppSlotRW/2;
topSuppSlotSideOffYS = 10+topSuppSlotW/2;
topSuppSlotSideOffY = 24+topSuppSlotW/2;

module topSuppHoleY() {
    difference() {
        //step = topSuppSlotCY/4;
        cube([topSuppSlotW, topSuppSlotCY, forSub(topSuppThick)], true);
        /*
        for (i = [0:2]) {
            translate([0, -topSuppSlotCY/2+step*i+step-0.2, 0])
                cube([topSuppSlotW, 0.4, forSub(forSub(topSuppThick))], true);
        }*/
    }
}

module topSuppHoleXS() {
    cube([topSuppSlotCX/2, topSuppSlotW, forSub(topSuppThick)], true);
}

module topSuppHoleX() {
    cube([topSuppSlotCX, topSuppSlotW, forSub(topSuppThick)], true);
}

module topSuppHoleR() {
    cube([topSuppSlotRW, topSuppSlotW, forSub(topSuppThick)], true);
}

hookL = 2;
hookW = 2;
hookS = 0.8;

module topSuppHoleHook(l = 2, rsv = 0.2) {
    translate([0, -hookW, 0])
    rotate([0, 90, 0])
    linear_extrude(height = l, center = true)
    polygon([
        [0, 0],
        [topSuppThick+hookL, 0],
        [topSuppThick+hookL, hookW],
        [topSuppThick+rsv, hookW+hookS],
        [topSuppThick+rsv, hookW],
        [0, hookW]
    ]);
}

module topSuppHoleHookPair(l = 2, rsv = 0.2) {
    translate([0, -topSuppSlotW/4, 0]) union() {
        translate([0, hookW+topSuppSlotW/2-rsv/2, 0]) topSuppHoleHook(l, rsv);
        translate([0, hookW-topSuppSlotW/2+rsv/2, 0]) mirror([0, -1, 0]) topSuppHoleHook(l, rsv);
    }
}

module topSuppTop() {
    difference() {
        translate([0, 0, topSuppThick/2]) cube([topSuppCX, topSuppCY, topSuppThick], true);
        translate([topCamDX+19.2-(hookW+0.4)/2, 0, topSuppThick/2]) cube([hookW+0.4, 8.4, forSub(topSuppThick)], true);
        translate([topCamDX-8.2+(hookW+0.4)/2, 0, topSuppThick/2]) cube([hookW+0.4, 8.4, forSub(topSuppThick)], true);

        translate([topAnchorFOffX, topAnchorLOffY, -0.1]) cylinder(h = forSub(topSuppThick), r = holeM3R);
        translate([topAnchorFOffX, -topAnchorROffY, -0.1]) cylinder(h = forSub(topSuppThick), r = holeM3R);
        translate([-topAnchorROffX, topAnchorLOffY, -0.1]) cylinder(h = forSub(topSuppThick), r = holeM3R);
        translate([-topAnchorROffX, -topAnchorROffY, -0.1]) cylinder(h = forSub(topSuppThick), r = holeM3R);
        translate([topAnchorFOffX, topAnchorLOffY, topSuppThick/2]) cylinder(h = topSuppThick/2+0.1, r = holeScrewCapR);
        translate([topAnchorFOffX, -topAnchorROffY, topSuppThick/2]) cylinder(h = topSuppThick/2+0.1, r = holeScrewCapR);
        translate([-topAnchorROffX, topAnchorLOffY, topSuppThick/2]) cylinder(h = topSuppThick/2+0.1, r = holeScrewCapR);
        translate([-topAnchorROffX, -topAnchorROffY, topSuppThick/2]) cylinder(h = topSuppThick/2+0.1, r = holeScrewCapR);

        translate([topAnchorFOffX-topSuppSlotOffF, 0, topSuppThick/2]) topSuppHoleY();
        translate([-topAnchorROffX+topSuppSlotOffF, 0, topSuppThick/2]) topSuppHoleY();
        translate([-topAnchorROffX-topSuppSlotOffF-topSuppSlotRW+topSuppSlotW, 0, topSuppThick/2]) topSuppHoleY();
        translate([topAnchorFOffX-topSuppSlotCX/2-topSuppSlotOffF, -topSuppSlotSideOffY, topSuppThick/2]) topSuppHoleX();
        translate([topAnchorFOffX-topSuppSlotCX/2-topSuppSlotOffF, topSuppSlotSideOffY, topSuppThick/2]) topSuppHoleX();
        translate([topAnchorFOffX-topAnchorDistX/2, -topSuppSlotSideOffYS, topSuppThick/2]) topSuppHoleXS();
        translate([topAnchorFOffX-topAnchorDistX/2, topSuppSlotSideOffYS, topSuppThick/2]) topSuppHoleXS();
        translate([-topAnchorROffX-topSuppSlotOffR, -topSuppSlotSideOffY, topSuppThick/2]) topSuppHoleR();
        translate([-topAnchorROffX-topSuppSlotOffR, topSuppSlotSideOffY, topSuppThick/2]) topSuppHoleR();
    }
}

module topSuppSide() {
    translate([0, 0, -(topSuppSideH-topSuppThick)/2])
    difference() {
        cube([topSuppCX, topSuppThick, topSuppSideH+topSuppThick], true);
        step = topSuppCX / 5;
        for (i = [0:4]) {
            translate([-topSuppCX/2+i*step+step/2, 0, -topSuppThick/2])
            difference() {
                cube([topSuppSideHoleW, forSub(topSuppThick), topSuppHoleH], true);
                //cube([forSub(topSuppSideHoleW), forSub(forSub(topSuppThick)), 0.4], true);
            }
        }
    }
}

module topSuppFront() {
    translate([(topSuppCX+topSuppThick)/2, 0, -(topSuppSideH-topSuppThick)/2])
    difference() {
        cube([topSuppThick, topSuppCY+topSuppThick*2, topSuppSideH+topSuppThick], true);
        step = topSuppCY / 5;
        for (i = [0:4]) {
            translate([0, -topSuppCY/2+i*step+step/2, -topSuppThick/2])
            difference() {
                cube([forSub(topSuppThick), topSuppFrontHoleW, topSuppHoleH], true);
            }
        }
    }
}

module topSuppFrontLow() {
    translate([(topSuppCX+topSuppThick)/2, 0, -(topSuppFrontLowH+topSuppThick)/2-topSuppSideH])
    difference() {
        union() {
            cube([topSuppThick, topSuppFrontLowCY, topSuppFrontLowH+topSuppThick], true);
            cx = 10+topSuppThick;
            translate([-cx/2, 0, -topSuppFrontLowH/2])
                cube([cx, topSuppFrontLowCY, topSuppThick], true);
        }

        step = topSuppFrontLowCY / 4;
        for (i = [0:3]) {
            translate([0, -topSuppFrontLowCY/2+i*step+step/2, topSuppThick/2])
                cube([forSub(topSuppThick), topSuppFrontHoleW, topSuppFrontLowHoleH], true);
        }
        translate([-10.1, -topSuppFrontLowCY/2+15+5, -topSuppFrontLowH/2])
            cube([10.2, 30, forSub(topSuppThick)], true);
        translate([-10.1, topSuppFrontLowCY/2+0.1-4.1, -topSuppFrontLowH/2])
            cube([10.2, 8.2, forSub(topSuppThick)], true);
    }
}

module topSupp() {
    translate([-topSuppCX/2, 0, 0]) union() {
        topSuppTop();
        offy = (topSuppCY+topSuppThick)/2;
        translate([0, offy, 0]) topSuppSide();
        translate([0, -offy, 0]) topSuppSide();
        topSuppFront();
        topSuppFrontLow();
    }
}

module topSuppForPrint() {
    topSupp();
    // supports
    translate([topSuppThick/2, 0, -(topSuppFrontLowH+topSuppThick)/2-topSuppSideH]) {
        for (i = [0, 12, 24, 36, topSuppFrontLowCY-0.6]) {
            union() {
                translate([-4, -24+i, -topSuppFrontLowH/2]) cube([2, 0.6, 3]);
                translate([-1.9, -23.7+i, -topSuppFrontLowH/2+4.5]) rotate([0, 45, 0]) cube([0.8, 0.6, 8], true);
            }
        }
        translate([-8.4, -24, -topSuppFrontLowH/2]) cube([0.8, 5, topSuppFrontLowH+topSuppThick+topSuppSideH]);
        translate([-8.4, 11, -topSuppFrontLowH/2]) cube([0.8, 4.9, topSuppFrontLowH+topSuppThick+topSuppSideH]);
        translate([-14, -24, -(topSuppFrontLowH-topSuppThick)/2]) rotate([0, 15, 0]) cube([0.8, 5, topSuppFrontLowH+9.8]);
        translate([-14, 11, -(topSuppFrontLowH-topSuppThick)/2]) rotate([0, 15, 0]) cube([0.8, 4.9, topSuppFrontLowH+9.8]);
    }
    //translate([topSuppThick*2, 0, -topSuppFrontLowDist-topSuppThick-4]) cube([1, 1, 0.2], true);
}

module placeTopSupp() {
    placeZ = 53;
    translate([0, 0, placeZ]) topSupp();
}

module tiltServoSlot() {
    difference() {
        union() {
            translate([5.5, 2.25, 8.4+topSuppThick-thick]) servo9g();
            translate([5.5, 0, topSuppThick/2]) cube([36.6, 22.7, topSuppThick], true);
        }
        translate([0, 0, -0.5]) cylinder(h = 5, r = 3.5);
        translate([0, 0, topSuppThick+0.2]) rotate([180, 0, 90]) fixture_half(2);
        //translate([-14.8, 4.4, topSuppThick/2]) cube([8, 3.5, forSub(topSuppThick)], true);
    }
}

module panServoSlot() {
    union() {
        difference() {
            translate([5.5, 0, 9.1-thick]) rotate([-90, 0, 0]) servo9g();
            translate([0, 0, -thick/2-0.1]) cube([60, 60, thick+0.2], true);
        }
        translate([-8, 0, 0]) rotate([0, 0, 90]) topSuppHoleHook(8);
        translate([19, 0, 0]) rotate([0, 0, -90]) topSuppHoleHook(8);
    }
}

module armServoSlotR() {
    translate([2, 0, 8.4]) rotate([90, 0, 0]) panServoSlot();
}

module armServoSlotL() {
    mirror([0, 1, 0]) armServoSlotR();
}

armServoBoardCX = 46;
armServoBoardCY = topSuppSlotSideOffYS*2 + topSuppSlotW + 5;
armServoBoardHoleCX = 38;
armServoBoardHoleCY = 18;

module armServoBoard() {
    union() {
        difference() {
            translate([topCamOff+2, 0, topSuppThick/2]) cube([armServoBoardCX, armServoBoardCY, topSuppThick], true);
            translate([topCamOff+1, 0, topSuppThick/2]) cube([armServoBoardHoleCX, armServoBoardHoleCY, forSub(topSuppThick)], true);
        }
        translate([topCamOff+topSuppSlotCX/4-0.2, topSuppSlotSideOffYS, 0]) topSuppHoleHookPair(4);
        translate([topCamOff-topSuppSlotCX/4+4.2, topSuppSlotSideOffYS, 0]) topSuppHoleHookPair(4);
        translate([topCamOff+topSuppSlotCX/4+0.2, -topSuppSlotSideOffYS, 0]) topSuppHoleHookPair(4);
        translate([topCamOff-topSuppSlotCX/4+4.2, -topSuppSlotSideOffYS, 0]) topSuppHoleHookPair(4);
        translate([topCamOff+armServoBoardCX/2-0.3, -topSuppSlotCY/2+2.2, 0]) rotate([0, 0, 90]) topSuppHoleHook(4);
        translate([topCamOff+armServoBoardCX/2-0.3, topSuppSlotCY/2-2.2, 0]) rotate([0, 0, 90]) topSuppHoleHook(4);
        translate([topCamOff-armServoBoardCX/2+4.2, -topSuppSlotCY/2+2.2, 0]) rotate([0, 0, -90]) topSuppHoleHook(4);
        translate([topCamOff-armServoBoardCX/2+4.2, topSuppSlotCY/2-2.2, 0]) rotate([0, 0, -90]) topSuppHoleHook(4);

        d = 18;
        translate([0, -d/2, topSuppThick-thick]) armServoSlotR();
        translate([0, d/2, topSuppThick-thick]) armServoSlotL();
    }
}

usbShellT = 2;

usbMInW = 4.8;
usbMInH = 12.2;
usbMDepth = 5.5;
usbMOutW = usbMInW + usbShellT * 2;
usbMOutH = usbMInH + usbShellT * 2;

module usbMaleShell() {
    difference() {
        cube([usbMDepth, usbMOutW, usbMOutH], true);
        cube([forSub(usbMDepth), usbMInW, usbMInH], true);
    }
}

usbFInW = 7.5;
usbFInH = 14;
usbFDepth = 9;
usbFOutW = usbFInW + usbShellT * 2;
usbFOutH = usbFInH + usbShellT * 2;
usbFExt = 2.5;
usbFExtH = 12.5;
usbFExtS = 5;

module usbFemaleShell() {
    difference() {
        union() {
            cube([usbFDepth, usbFOutW, usbFOutH], true);
            translate([-(usbFExt+usbFDepth)/2, -(usbShellT+usbFInW)/2, 0])
                cube([usbFExt, usbShellT, usbFExtH], true);
        }
        cube([forSub(usbFDepth), usbFInW, usbFInH], true);
    }
}

usbFMountH = 9;
usbFMountInD = 4.8;
usbFMountD = 6.8;

module usbFemaleMount() {
    difference() {
        dx = (usbFDepth-usbFMountD)/2;
        union() {
            usbFemaleShell();
            mCY = usbFMountD+usbFInW;
            translate([-dx, -mCY/2+usbFInW/2, usbFMountH/2+usbFInH/2])
                cube([usbFMountD, mCY, usbFMountH], true);
            translate([-(usbFExtS+usbFDepth)/2, usbShellT/2, (usbFOutH-usbShellT)/2])
                cube([usbFExtS, usbFOutW-usbShellT, usbShellT], true);
            translate([-(usbFExtS+usbFDepth)/2, (usbFOutW-usbShellT)/2, 0])
                cube([usbFExtS, usbShellT, usbFInH], true);
        }
        holeH = forSub(usbFMountH+usbFOutH)*2;
        sp = 0.4;
        translate([-dx, -usbFMountInD/2-usbFInW/2-sp, 0])
            cylinder(h = holeH, d = usbFMountInD, center = true);
        // remove the bottom
        translate([0, 0, -(usbFOutH-usbShellT)/2-0.09])
            cube([forSub(usbFDepth), forSub(usbFOutW), forSub(usbShellT)], true);
    }
}

usbMFDist = 15.2;
usbMFNetDist = usbMFDist - usbShellT * 2;
usbMFDepth = usbMDepth;
usbMFH = usbMOutH;

module usbMFConn() {
    union() {
        translate([0, -(usbMFNetDist+usbMOutW)/2, 0]) usbMaleShell();
        translate([0, (usbMFNetDist+usbFOutW)/2, 0]) usbFemaleShell();
        cube([usbMFDepth, usbMFNetDist, usbMFH], true);
    }
}

//extBoard0ForSupp();
//neck();
//swing();
//camTilt();
//cam32Tilt();
cam32TiltRack();
//camBase();
//rotate([0, 180, 0]) swing_handle();
//swing_fix();

/*
translate([0, 0, 15]) rotate([0, 90, 0]) frontBumpEmitSupp();
difference() {
    translate([16, 0, 0]) cube([2, 2, 0.2], true);
}
*/

//frontBumpEmitSupp();
//baseSuppForPrint();

//topSuppFrontLow();
//topSuppForPrint();
//topSuppTop();

//panServoSlot();

//baseSupp();
//placeTopSupp();
//tiltServoSlot();
//translate([topCamDX, 0, 4]) panServoSlot();
//topSuppTop();
//translate([0, 0, topSuppThick]) armServoBoard();
