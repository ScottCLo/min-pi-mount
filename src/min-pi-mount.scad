$fn = 128;

TOLERANCE = 0.05;

PI_WIDTH = 56;
PI_LENGTH = 85;
PI_MOUNT_WIDTH = 49;
PI_MOUNT_LENGTH = 58;
PI_MOUNT_HOLE_DIAMITER = 2.75;
PI_MOUNT_HOLE_RADIUS = PI_MOUNT_HOLE_DIAMITER / 2;
PI_MOUNT_PAD_DIAMITER = 6;
PI_MOUNT_PAD_RADIUS = PI_MOUNT_PAD_DIAMITER / 2;
PI_MOUNT_HOLE_INSET = 3.5;
PI_PCB_THICKNESS = 1.4;

MOUNT_HOLE_RADIUS = 2.25;
MOUNT_HOLE_SPACEING = 10;
SCREW_HEAD_DEPTH = 4;
SCREW_HEAD_RADIUS = 5.5;

MOUNT_PAD_HEIGHT = 3;

MOUNT_CLIP_WIDTH = 3.6;
MOUNT_CLIP_THICKNESS = 1.6;
MOUNT_CLIP_OVERHANG = 0.4;

BRACKET_THICKNESS = 6;

module screw_hole(){
    union(){
        translate([0,0,-1])
        cylinder(
            h = BRACKET_THICKNESS + 1,
            r = MOUNT_HOLE_RADIUS
        );
        
        translate([0,0,BRACKET_THICKNESS - SCREW_HEAD_DEPTH])
        cylinder(
            h = SCREW_HEAD_DEPTH + 1,
            r = SCREW_HEAD_RADIUS
        );
    }
}

module mounting_holes(){
    translate([MOUNT_HOLE_SPACEING,MOUNT_HOLE_SPACEING,0])
        screw_hole();
    translate([-MOUNT_HOLE_SPACEING,-MOUNT_HOLE_SPACEING,0])
        screw_hole();
}


module mounting_pad(){
    union(){
        cylinder(
            h = MOUNT_PAD_HEIGHT,
            r = PI_MOUNT_PAD_RADIUS,
            center = false
        );
        translate([0,0,MOUNT_PAD_HEIGHT]){
            sphere( PI_MOUNT_HOLE_RADIUS - TOLERANCE/2);
        }
    }
}

module mounting_clip(){
    translate([ PI_MOUNT_HOLE_INSET + TOLERANCE, -MOUNT_CLIP_WIDTH/2,0])
    union(){
        cube([
            MOUNT_CLIP_THICKNESS,
            MOUNT_CLIP_WIDTH, 
            MOUNT_PAD_HEIGHT + PI_PCB_THICKNESS,
        ]);
        
        translate([
            MOUNT_CLIP_THICKNESS/2,
            MOUNT_CLIP_WIDTH,
            MOUNT_PAD_HEIGHT + PI_PCB_THICKNESS - MOUNT_CLIP_THICKNESS/2
        ])
        rotate([0,-45,180])
        cube([
            MOUNT_CLIP_THICKNESS/2 * sqrt(2) + MOUNT_CLIP_OVERHANG * sqrt(2),
            MOUNT_CLIP_WIDTH,
            MOUNT_CLIP_THICKNESS/2 * sqrt(2),
            //MOUNT_CLIP_OVERHANG/ sqrt(2) * 2,
        ]);
        
        translate([MOUNT_CLIP_THICKNESS/2,MOUNT_CLIP_WIDTH/2,0])
        rotate([0,45,0])
        cube([
            2.5,
            MOUNT_CLIP_WIDTH,
            2.5,
        ], center = true);
    }
}

module mount(){
    union(){
        translate([0,0,BRACKET_THICKNESS]){
            mounting_pad();
            mounting_clip();
        }
        cylinder(
            h = BRACKET_THICKNESS,
            r = PI_MOUNT_PAD_RADIUS + PI_MOUNT_HOLE_INSET
        );
    }
}

module braket(){
    union(){
        rotate([0,0,180])
            mount();
        translate([0,PI_MOUNT_LENGTH,0])
        rotate([0,0,180])
            mount();
        translate([PI_MOUNT_WIDTH,0,0])
            mount();
        translate([PI_MOUNT_WIDTH,PI_MOUNT_LENGTH,0])
            mount();
        
        cube([
            PI_MOUNT_WIDTH,
            PI_MOUNT_LENGTH,
            BRACKET_THICKNESS,
        ]);
    }
}

difference(){
    braket();
    translate([PI_MOUNT_WIDTH/2,PI_MOUNT_LENGTH/2,0])
        mounting_holes();
}
