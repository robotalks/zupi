$fn = 100;

thick = 2;
pad = 0.2;//4.5;
fix = 16;
l = 30;
d = 32.6;
h = 12.8;
d0 = 23;
t = 2.5;

ay = fix+pad+thick;
offy = ay/2;
offxc = (d+d0)/4;
ty = ay + t + thick;

module servo9g_frame() {
    difference() {
        cube([d+thick*2, ay, h], true);
        translate([0, -thick/2-0.1, 0]) cube([d0, fix+pad+0.2, h+0.2], true);
        translate([-d/2-thick-0.1, -offy+(fix-6.5), h/2-9]) cube([(d-d0)/2+thick*2+0.2, 3.5, 9.1]);
        translate([offxc, -offy-0.1, 0]) rotate([-90, 0, 0]) cylinder(h = ty-ay+2.5, r = 1.25);
        translate([-offxc, -offy-0.1, 0]) rotate([-90, 0, 0]) cylinder(h = ty-ay+2.5, r = 1.25);
        translate([-d0/2+6, ay/2-thick-0.1, 0]) rotate([-90, 0, 0]) cylinder(h = thick+0.2, r = 3);
        translate([offxc, -offy+5, 0]) cube([(d-d0)/2+thick*2+0.2, 5, 6], true);
        translate([-offxc, -offy+5, 0]) cube([(d-d0)/2+thick*2+0.2, 5, 6], true);
    }
}

module servo9g_base() {
    union() {
        translate([0, -(ty-ay)/2, 0]) cube([d+thick*2, ty, thick], true);
        oy = (ty-ay)+(ay-thick)/2;
        oz = (h+thick)/2;
        difference() {
            translate([offxc, -oy, oz]) cube([(d-d0)/2, thick, h], true);
            translate([offxc, -offy-(ty-ay)-0.1, oz]) rotate([-90, 0, 0]) cylinder(h = thick+0.2, r = 1.25);
        }
        difference() {
            translate([-offxc, -oy, oz]) cube([(d-d0)/2, thick, h], true);
            translate([-offxc, -offy-(ty-ay)-0.1, oz]) rotate([-90, 0, 0]) cylinder(h = thick+0.2, r = 1.25);
        }
        ox = offxc+(d-d0)/4+thick/2;
        oy1 = oy-(ty-ay-thick)/2;
        translate([ox, -oy1, oz]) cube([thick, ty-ay, h], true);
        translate([-ox, -oy1, oz]) cube([thick, ty-ay, h], true);
    }
}

module servo9g() {
    difference() {
        union() {
            servo9g_frame();
            translate([0, 0, -(h+thick)/2]) servo9g_base();
        }
        translate([-d/2-thick-0.1, -offy+(fix-6.5), -h/2-thick-0.1]) cube([thick+0.1, 3.5, h+thick+0.2]);
    }
}

module guide() {
    union() {
        cube([d/2-thick, thick*2, thick], true);
        translate([0, thick+thick/2, thick]) cube([d/2-thick, thick, thick*3], true);
        translate([d/4+thick*3, thick/2, -(fix-6.5)/2+thick+thick/2])
            cube([thick, thick*3, fix-6.5+thick*2], true);
        translate([thick+thick/2, thick+thick/2, -(fix-6.5+thick)/2])
            cube([d/2+thick*2, thick, fix-6.5-thick*2], true);
        translate([0, 0, -(fix-6.5)+thick]) cube([d/2-thick, thick*2, thick], true);
    }
}

module tilt_pan() {
    difference() {
        union() {
            servo9g();
            translate([0, (ay-l)/2, -(ay+h)/2]) rotate([90, 0, 0]) servo9g();
            translate([-d/4-thick/2, (ay-l+h)/2+thick*2, -(h+thick)/2-thick-6.5]) guide();
        }
        translate([-d/2-thick-0.1, -offy+(fix-6.5), -h/2-thick-6.6]) cube([thick+0.1, 3.5, h+thick+0.2]);
    }
}

module print_no_supp() {
    union() {
        tilt_pan();
        translate([offxc, (ay-l)/2, -ty-h/2+0.4]) cylinder(h=0.1, r=1.3);
        translate([-offxc, (ay-l)/2, -ty-h/2+0.4]) cylinder(h=0.1, r=1.3);
    }

}

module base() {
    difference() {
        cx = 30;
        cy = 45;
        h = 4;
        dz = 0.5;
        ch = 5;
        dc = 5;

        translate([0, 0, h/2]) cube([cx, cy, h], true);
        translate([0, 0, -dz]) cylinder(h = ch, r = 3.5);
        translate([0, 0, -0.1]) fixture(1.7);

        cr = 1.3;
        ccx = cx/2-dc;
        ccy = cy/2-dc;
        translate([ccx, ccy, -dz]) cylinder(h = ch, r = cr);
        translate([-ccx, ccy, -dz]) cylinder(h = ch, r = cr);
        translate([-ccx, -ccy, -dz]) cylinder(h = ch, r = cr);
        translate([ccx, -ccy, -dz]) cylinder(h = ch, r = cr);
    }
}

module swing(l = 36, a = 30, h = 4) {
    d = 30+4+thick;
    rotate([90, 0, 0]) union() {
        translate([0, 0, d/2-2+thick]) rotate([0, 180, 0]) swing_handle(l, a, h);
        translate([0, 0, -d/2-2]) swing_fix(l, a, h);
    }
}

module swing_handle(l = 36, a = 30, h = 4) {
    difference() {
        swing_side(l, a, h);
        cylinder(h = h+0.1, r = 3.5);
        translate([0, 0, -0.1]) fixture_half(1.7);
    }
}

module swing_fix(l = 36, a = 30, h = 4) {
    union() {
        swing_side(l, a, h);
        cylinder(h = h+thick, r = 4);
        cylinder(h = h+thick+thick/2, r = 2.8);
    }
}

module swing_side(l = 36, a = 30, h = 4) {
    linear_extrude(h) union() {
        r = 6;
        circle(r);
        a = a/2;
        ltan = l * tan(a);
        translate([-ltan, l, 0]) circle(r);
        translate([ltan, l, 0]) circle(r);
        offx = r * cos(a);
        offy = r * sin(a);
        polygon([
            [-offx, -offy],
            [-ltan-offx, l-offy],
            [-ltan, l+r],
            [ltan, l+r],
            [ltan+offx, l-offy],
            [offx, -offy]
        ]);
    }
}

module fixture(h) {
    linear_extrude(h) union() {
        polygon([
            [-4, -2.2],
            [-2.2, -18.8],
            [2.2, -18.8],
            [4, -2.2]
        ]);
        translate([0, -18.8, 0]) circle(2.2);
        square([20, 4.4], true);
        translate([10, 0, 0]) circle(2.2);
        translate([-10, 0, 0]) circle(2.2);
        polygon([
            [-3.4, 2.2],
            [-2.2, 14.9],
            [2.2, 14.9],
            [3.4, 2.2]
        ]);
        translate([0, 14.9, 0]) circle(2.2);
    }
}

module fixture_half(h) {
    linear_extrude(h) union() {
        circle(3.5);
        polygon([
            [-3.5, 0],
            [-3.4, 2.2],
            [-2.2, 14.9],
            [2.2, 14.9],
            [3.4, 2.2],
            [3.5, 0]
        ]);
        translate([0, 14.9, 0]) circle(2.2);
    }
}
