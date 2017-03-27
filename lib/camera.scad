$fn = 100;

use <common.scad>;

// 32*32mm camera board

cam32BoardSz = 32;                      // the inner board size
cam32BoardT = 1.8;                      // board thickness, slightly thicker (1.62 actual)
cam32ScrewHoleD = 2.5;                  // screw hole dia on four corners
cam32ScrewHoleR = cam32ScrewHoleD/2;
cam32ScrewHoleEdgeDist = 1.1;           // distance from inner board edge to hole edge
cam32ScrewHoleCenterEdgeDist = cam32ScrewHoleEdgeDist + cam32ScrewHoleR; // distance from hole center to inner board edge
cam32ScrewHoleDist = 28;                // distance between centers of two holes
cam32ScrewHoleSuppSz = 1.2;             // extended support size outside of hole
cam32BackSuppSp = 2;                    // space between back support and board
cam32BackSuppH = 3;                     // default back support height, without space
cam32SuppH = cam32BackSuppH + cam32BackSuppSp;

module cam32ScrewHoleSupp(h = cam32SuppH) {
    outSz = cam32ScrewHoleD + (cam32ScrewHoleSuppSz+cam32ScrewHoleEdgeDist) * 2;
    inSz = cam32ScrewHoleD + cam32ScrewHoleEdgeDist * 2;
    translate([0, 0, (h - cam32BoardT)/2]) {
        difference() {
            cube([outSz, outSz, h + cam32BoardT], true);
            translate([-cam32ScrewHoleSuppSz, -cam32ScrewHoleSuppSz, -h/2-0.1])
                cube([outSz, outSz, cam32BoardT+0.2], true);
            translate([0, 0, (h+cam32BoardT)/2+0.1])
                    mirror([0, 0, 1]) 
            hexNutScrewM25(h = h+cam32BoardT+0.2, nutH = 2.3);
            
            // one edge will conflict with connector, shrink it
            translate([0, -inSz/2-(outSz-inSz)/4-0.5, 0])
            cube([outSz+0.2, (outSz-inSz)/2+0.2, h+cam32BoardT+0.2], true);
        }

    }
}

module cam32Supp(h = cam32SuppH) {
    outSz = cam32ScrewHoleD + (cam32ScrewHoleSuppSz+cam32ScrewHoleEdgeDist) * 2;
    inSz = cam32ScrewHoleD + cam32ScrewHoleEdgeDist * 2;
    off = cam32ScrewHoleDist/2;
    suppH = h - cam32BackSuppSp;
    connL = cam32ScrewHoleDist-outSz;
    difference() {
        union() {
            translate([off, off, 0]) cam32ScrewHoleSupp(h);
            translate([off, -off, 0]) mirror([0, -1, 0]) cam32ScrewHoleSupp(h);
            translate([-off, off, 0]) mirror([-1, 0, 0]) cam32ScrewHoleSupp(h);
            translate([-off, -off, 0]) mirror([-1, 0, 0]) mirror([0, -1, 0]) cam32ScrewHoleSupp(h);
            translate([0, off+(outSz-inSz)/4-0.2, suppH/2+cam32BackSuppSp]) cube([connL, (outSz+inSz)/2+0.4, suppH], true);
            translate([0, -off-(outSz-inSz)/4+0.2, suppH/2+cam32BackSuppSp]) cube([connL, (outSz+inSz)/2+0.4, suppH], true);
            translate([0, 0, suppH/2+cam32BackSuppSp]) cube([off, off*2, suppH], true);
        }
        translate([0, 0, cam32BackSuppSp-0.1]) {
            hexNutScrewM25(h = suppH + 0.2, nutH = 1.8);
            translate([0, -cam32ScrewHoleDist/3, 0])
                hexNutScrewM25(h = suppH + 0.2, nutH = 1.8);
            translate([0, cam32ScrewHoleDist/3, 0])
                hexNutScrewM25(h = suppH + 0.2, nutH = 1.8);            
        }
    }
}

cam32WireInD = 6;   // Inner dia of wire guide
cam32WireOutD = 10; // Outer dia of wire guide
cam32HookD = 4;
cam32HookL = 4;
cam32HookSzH = 0.6;
cam32HookSzD = 0.6;
cam32HookSp = 0.2;

module cam32WireGuide(h = cam32SuppH) {
    l = cam32ScrewHoleDist/2 + cam32HookD*2;
    cy = cam32WireInD + cam32HookL*2;
    hk = makeHook(
        baseH = h - cam32BackSuppSp + cam32HookSp, 
        baseL = cam32HookL,
        baseD = cam32HookD-cam32HookSp,
        sizeH = cam32HookSzH,
        sizeD = cam32HookSzD);
    translate([0, 0, cam32WireInD/2]) union() {
        difference() {
            union() {
                rotate([0, 90, 0]) cylinder(h = l, d = cam32WireOutD, center = true);
                translate([0, 0, -cam32WireInD/4]) cube([l, cy, cam32WireInD/2], true);
            }
            // erase everything below base
            translate([0, 0, -cam32WireOutD/2-cam32WireInD/2]) cube([l, cy, cam32WireOutD], true);
            // erase insider of guide
            rotate([0, 90, 0]) cylinder(h = l+0.2, d = cam32WireInD, center = true);
            translate([0, 0, -cam32WireInD/2]) cube([l+0.2, cam32WireInD, cam32WireInD], true);
            // make space in the upper middle for wiring out
            translate([cam32WireInD/2, 0, 0]) cylinder(h = cam32WireOutD+0.2, d = cam32WireInD, center = true);
            translate([l/2+cam32WireInD/2, 0, cam32WireOutD/2]) cube([l, cam32WireInD, cam32WireOutD], true);
            
        }
        // add hooks
        offx = cam32ScrewHoleDist/4+cam32HookSp;
        translate([0, 0, -cam32WireInD/2]) {
            translate([-offx, -cy/2, 0]+hookLocL(hk)+hookLocTop(hk)) hook(hk);
            translate([-offx, cy/2, 0]+hookLocR(hk)+hookLocTop(hk)) hook(hk);
            translate([offx, -cy/2, 0]+hookLocL(hk)+hookLocTop(hk)) mirror([1, 0, 0]) hook(hk);
            translate([offx, cy/2, 0]+hookLocR(hk)+hookLocTop(hk)) mirror([1, 0, 0]) hook(hk);
        }
    }
}

module cam32WireGuideFlat(h = cam32SuppH) {
    l = cam32ScrewHoleDist/2;
    cy = cam32ScrewHoleDist;
    hAll = cam32WireInD+cam32BackSuppSp;
    difference() {
        translate([0, 0, hAll/2]) cube([l, cy, hAll], true);
        translate([0, 0, cam32WireInD/2-0.1]) cube([l+0.2, cam32WireOutD, cam32WireInD+0.2], true);
        translate([cam32WireInD/2, 0, 0]) cylinder(h = hAll+0.1, d = cam32WireInD);
        translate([l/2+cam32WireInD/2, 0, hAll/2+0.1]) cube([l, cam32WireInD, hAll+0.2], true);
        // nut holes
        translate([0, 0, hAll+0.1]) {
            translate([0, -cam32ScrewHoleDist/3, 0])
                mirror([0, 0, 1]) hexNutScrewM25(h = hAll+0.2);
            translate([0, cam32ScrewHoleDist/3, 0])
                mirror([0, 0, 1]) hexNutScrewM25(h = hAll+0.2);            
        }
    }
}
    
cam32Supp();
translate([0, 0, cam32SuppH]) cam32WireGuide();