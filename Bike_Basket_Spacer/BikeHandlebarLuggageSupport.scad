// Parameterised model for a bicycle front handlebar mounted accessory support
// RAE 29/10/25

// Main Variables - all in millimeters or degrees
// Example Values used are to suit a Halfords Carrera Crossfire 2 Women's Hybrid Bike (Medium) with a Halfords basket
stemDiameter = 34;           //Diameter of tube that support will attach to
stemSupportHeight = 28;      //Height of semicircular support which rests against stem.  Maximum is obviously length of stem at above diameter.
stemSupportThickness = 5;    //Thickness of support that rests against stem
supportThickness = 17;       //Support extension and 'bar' assumed to be square
overallSupportLength = 90-supportThickness+(stemDiameter/2) ; //Assumed to be from centre of Stem to edge of support
luggageSupportWidth = 150;   //Width of the luggage buffer, rounded ends currently added on
headTubeAngle = 69;          //Assumed that support extension is horizontal and therefore at same angle as headtube
velcroSlotWidth = 3;         //Wide enough to fit velcro strip or cable tie through
velcroSlotHeight = 12;       //Tall enough to fit velcro strip or cable tie through

$fn = $preview ? 32 : 64;


difference() { //Remove stem
    union() { //Combine pieces
        
    // Support T piece
    translate([stemDiameter/2 + stemSupportThickness,0,0]) rotate(a=[0,90-headTubeAngle,0]) translate([-stemDiameter/2 - stemSupportThickness,0,0])
        difference() {
            union() {
                //Spine
                translate ([overallSupportLength/2,0,0]) cube(size=[overallSupportLength,supportThickness,supportThickness], center = true);
                //Buffer
                translate ([overallSupportLength + (supportThickness/2),0,0]) cube(size=[supportThickness,luggageSupportWidth,supportThickness], center = true);
                //Rounded ends
                translate ([overallSupportLength+supportThickness/2,luggageSupportWidth/2,0]) cylinder(h = supportThickness,r = supportThickness/2, center = true);
                translate ([overallSupportLength+supportThickness/2,-luggageSupportWidth/2,0]) cylinder(h = supportThickness,r = supportThickness/2, center = true);
            };
        lattice();
    }

    // Stem anchor
    union() {
        difference() {
            cylinder(h = stemSupportHeight, d = stemDiameter + 2*stemSupportThickness, center = true);
            translate([-(stemDiameter+stemSupportThickness+1),0,0]) cube(size=2*(stemDiameter+stemSupportThickness+1), center = true);
        }
        translate([0,stemDiameter/2 + stemSupportThickness/2,0]) cylinder(h = stemSupportHeight,d = stemSupportThickness, center = true);
        translate([0,-(stemDiameter/2 + stemSupportThickness/2),0]) cylinder(h = stemSupportHeight,d = stemSupportThickness, center = true);
    }

    }
//Stem cutout
cylinder(h = 2*stemSupportHeight, d = stemDiameter, center = true);
//Velcro loop cutout
translate([stemDiameter/2 + stemSupportThickness,0,0]) cube([velcroSlotWidth,supportThickness*2,velcroSlotHeight], center = true);
//Flatten Top to allow easier upside printing
translate([stemDiameter/2 + stemSupportThickness,0,0]) rotate(a=[0,90-headTubeAngle,0]) translate([0,0,supportThickness]) cube([stemDiameter*2,stemDiameter*2,supportThickness], center=true);
}

module lattice()
{
color("red")
intersection() {
    union() {
//        translate ([overallSupportLength/2,0,0]) cube(size=[overallSupportLength,supportThickness-5,2*supportThickness], center = true);
        translate ([(overallSupportLength/2)+((stemDiameter/2 + stemSupportThickness+velcroSlotWidth*2)/2),0,0]) cube(size=[overallSupportLength-(stemDiameter/2 + stemSupportThickness + 6),supportThickness-5,2*supportThickness], center = true);
        translate ([overallSupportLength + (supportThickness/2),0,0]) cube(size=[supportThickness-5,luggageSupportWidth-5,2*supportThickness], center = true);
    }
    //lattice cutout
    rotate([0,0,45]) translate([-overallSupportLength,-luggageSupportWidth,0]) make_latice_cutout(dimension = 2*max(overallSupportLength,luggageSupportWidth))
        cube([3,3,100], center = true);
    }
}

module make_latice_cutout(dimension)
{
    for (x = [0 : 5 : dimension - 1 ]) {
        for (y = [0 : 5 : dimension - 1 ]) {
                translate([x, y, 0])
                    children();
        }   
    }
}


