//
// Brian Benchoff at HackADay, noted there was no Hack A Day logo to play with the new makerbot Customizer tool in a post at: 
//   http://www.hackaday.com/2013/02/16/custom-3d-printed-designs-with-makerbots-customizer
//
// I built this to play around. Currently DXF import is unsupported by http://customizer.makerbot.com
// 
// Here is the highlevel of how I did it and the tools used:
//
// Downloaded Hack a Day logo from http://hackaday.com
// Imported into Inkscape, traced, cleaned up, set stroke and fill to black, set path name, set Doc Defaults to mm, scaled to ~50mm.
// Exported to OpenScad Format with Inkscape to OpenSCAD converter v2 from:
//   http://www.thingiverse.com/thing:25036
// Hand edited the OpenScad output to add Variables and make nice for Customizer!
//
// -- BoorT


// Module names are of the form poly_<inkscape-path-id>().  As a result,
// you can associate a polygon in this OpenSCAD program with the corresponding
// SVG element in the Inkscape document by looking for the XML element with
// the attribute id="inkscape-path-id".

// preview[view:south, tilt:top]

// How Wide to make the Logo?   Default is 1 which is about 50mm square. Choose 2 for twice as wide.
LogoScaleX=1; //

// How High to make the Logo?   Default is 1 which is about 50mm square. Choose 2 for twice as high.
LogoScaleY=1; //

// How tall to make the Logo?   Default is 5mm 
ExtrudeHeight = 5; // [.5:50]

// What color would you like: Default is Green. See http://en.wikipedia.org/wiki/Web_colors for valid options.
LogoColor = "green"; 

// The fudge value is used to ensure that subtracted solids are a tad taller in the z dimension than the polygon being  subtracted from.  This helps keep the resulting .stl file manifold. Defualt of 0.1mm should work for most uses.
fudge = 0.1; // [0.1:1]

module poly_HackADayLogo(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    linear_extrude(height=h)
      polygon([[-34.245637,-29.433885],[-26.261107,-37.418335],[-35.596937,-46.002585],[-40.128276,-50.474831],[-43.199657,-54.332354],[-45.103423,-58.018425],[-46.131917,-61.976315],[-47.021502,-65.557463],[-48.459276,-68.908636],[-50.389209,-71.974442],[-52.755268,-74.699486],[-55.501423,-77.028375],[-58.571640,-78.905716],[-61.909889,-80.276114],[-65.460137,-81.084175],[-72.912299,-82.125795],[-65.730667,-75.243785],[-58.549047,-68.361755],[-65.524687,-60.468455],[-74.007293,-50.896895],[-75.057492,-50.624528],[-76.793965,-51.150160],[-78.993311,-52.374462],[-81.432125,-54.198105],[-86.046363,-57.714861],[-88.830039,-59.177585],[-89.712158,-58.740916],[-89.997226,-57.544865],[-89.751947,-55.760365],[-89.043023,-53.558351],[-86.501051,-48.585515],[-84.801409,-46.156559],[-82.904932,-43.993825],[-79.831674,-41.280832],[-76.863311,-39.565664],[-73.556015,-38.663194],[-69.465957,-38.388295],[-65.086361,-38.049234],[-61.305237,-36.807219],[-57.278391,-34.251652],[-52.161627,-29.971935],[-42.479837,-21.521895],[-34.245637,-29.433885]]);
    linear_extrude(height=h)
      polygon([[50.325821,-28.828675],[55.957113,-33.450676],[60.299203,-36.279533],[64.076488,-37.693810],[68.013361,-38.072075],[71.378186,-38.342122],[74.631190,-39.145109],[77.712163,-40.437796],[80.560892,-42.176943],[83.117167,-44.319306],[85.320776,-46.821647],[87.111507,-49.640724],[88.429151,-52.733295],[89.765511,-57.687719],[89.997226,-59.369685],[89.874721,-60.195035],[89.026068,-60.037145],[87.280642,-59.041989],[82.117611,-55.195985],[75.125141,-49.432265],[66.806471,-58.549335],[58.487771,-67.666425],[65.415061,-74.986215],[72.342351,-82.306025],[64.890181,-81.174295],[61.334333,-80.325112],[57.992543,-78.921395],[54.920558,-77.018562],[52.174127,-74.672031],[49.808996,-71.937220],[47.880913,-68.869547],[46.445626,-65.524429],[45.558881,-61.957285],[44.506993,-57.928705],[42.517242,-54.172484],[39.223453,-50.149486],[34.259451,-45.320575],[24.162271,-36.092395],[31.274481,-28.005385],[39.007281,-19.740695],[42.588068,-22.337006],[50.325821,-28.828675]]);
    difference()
    {
       linear_extrude(height=h)
         polygon([[-9.717087,47.988025],[-9.568745,46.875196],[-9.180220,46.013970],[-8.636261,45.433837],[-8.021618,45.164287],[-7.421043,45.234811],[-6.919284,45.674898],[-6.601092,46.514040],[-6.551217,47.781725],[-6.549053,50.195964],[-5.804445,53.108137],[-4.939182,54.463703],[-3.630858,55.599055],[-1.793655,56.399295],[0.658243,56.749525],[3.082099,56.585008],[4.847189,55.985106],[6.057338,55.050958],[6.816372,53.883700],[7.396395,51.254406],[7.417863,48.906325],[7.577543,47.327482],[7.968219,46.278839],[8.512131,45.723586],[9.131519,45.624912],[9.748625,45.946010],[10.285689,46.650067],[10.664950,47.700276],[10.808651,49.059825],[11.361433,51.938053],[12.037702,53.206860],[12.967483,54.318975],[14.140970,55.242034],[15.548357,55.943672],[17.179839,56.391524],[19.025611,56.553225],[20.742303,56.361605],[22.033485,55.808250],[22.959758,54.949045],[23.581723,53.839875],[24.155138,51.095175],[24.238541,48.021225],[24.596453,45.244995],[25.609800,42.234962],[27.188000,39.202336],[29.240471,36.358325],[31.779553,33.120117],[33.910820,29.886715],[35.655621,26.596251],[37.035308,23.186857],[38.071232,19.596668],[38.784743,15.763816],[39.197192,11.626434],[39.329931,7.122655],[38.977710,1.138705],[37.953338,-4.523229],[36.305249,-9.831098],[34.081878,-14.752852],[31.331661,-19.256440],[28.103032,-23.309814],[24.444427,-26.880922],[20.404281,-29.937716],[16.031027,-32.448146],[11.373103,-34.380161],[6.478941,-35.701711],[1.396979,-36.380748],[-3.824351,-36.385220],[-9.136611,-35.683079],[-14.491369,-34.242274],[-19.840187,-32.030755],[-24.521238,-29.338392],[-28.700709,-26.125628],[-32.369959,-22.454467],[-35.520345,-18.386913],[-38.143227,-13.984971],[-40.229963,-9.310644],[-41.771910,-4.425937],[-42.760428,0.607146],[-43.186876,5.726601],[-43.042610,10.870422],[-42.318991,15.976607],[-41.007376,20.983150],[-39.099123,25.828048],[-36.585592,30.449296],[-33.458141,34.784890],[-29.708127,38.772825],[-27.805685,40.864942],[-26.247753,43.180587],[-25.195098,45.438127],[-24.808487,47.355925],[-24.396732,51.880802],[-23.908060,53.481506],[-23.182963,54.699362],[-22.185522,55.578102],[-20.879814,56.161455],[-17.199917,56.616925],[-15.226510,56.420608],[-13.715190,55.815042],[-12.583206,54.878809],[-11.747808,53.690487],[-10.635774,50.871902],[-9.717087,47.987925]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[21.031031,19.393105],[20.012468,18.196454],[18.354321,16.819486],[14.037211,14.205495],[11.240257,12.703217],[9.032853,11.174221],[7.413837,9.615983],[6.382051,8.025982],[5.936335,6.401696],[6.075530,4.740603],[6.798476,3.040180],[8.104013,1.297905],[10.235055,-0.551777],[12.680187,-1.822225],[15.330971,-2.519401],[18.078975,-2.649269],[20.815762,-2.217791],[23.432897,-1.230930],[25.821945,0.305349],[27.874471,2.385085],[30.551567,6.499975],[31.274293,8.372375],[31.590402,10.183461],[31.502843,11.979771],[31.014564,13.807841],[28.847641,17.745415],[26.510311,20.541054],[25.464749,21.337188],[24.486692,21.735269],[23.565215,21.737598],[22.689395,21.346480],[21.031031,19.393105]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-31.304007,17.745415],[-33.470932,13.807841],[-33.959212,11.979771],[-34.046772,10.183461],[-33.730664,8.372375],[-33.007938,6.499975],[-30.330837,2.385085],[-28.278317,0.305349],[-25.889273,-1.230930],[-23.272139,-2.217791],[-20.535352,-2.649269],[-17.787347,-2.519401],[-15.136559,-1.822225],[-12.691424,-0.551777],[-10.560377,1.297905],[-9.254841,3.040180],[-8.531896,4.740603],[-8.392703,6.401696],[-8.838420,8.025982],[-9.870206,9.615983],[-11.489222,11.174221],[-13.696626,12.703217],[-16.493577,14.205495],[-20.810687,16.819486],[-22.468835,18.196454],[-23.487397,19.393105],[-25.145761,21.346480],[-26.021581,21.737598],[-26.943058,21.735269],[-27.921116,21.337188],[-28.966677,20.541054],[-31.304007,17.745415]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-5.944247,34.322425],[-5.314545,30.174909],[-3.761738,26.136832],[-1.790276,23.205737],[-0.805189,22.467040],[0.095393,22.379165],[1.090800,23.096398],[2.060227,24.462153],[3.691414,28.380556],[4.529500,32.617029],[4.507551,34.380371],[4.115033,35.654225],[3.543999,36.157431],[2.815473,36.179775],[2.013477,35.743944],[1.222033,34.872625],[0.308298,33.743859],[-0.397633,33.338225],[-0.981489,33.649441],[-1.528997,34.671225],[-2.771148,36.446003],[-3.501289,36.856548],[-4.227527,36.955250],[-4.892402,36.746649],[-5.438454,36.235284],[-5.808222,35.425696],[-5.944247,34.322425]]);
    }
    linear_extrude(height=h)
      polygon([[65.055381,76.172225],[58.083021,70.041325],[65.831051,61.080925],[71.922358,54.752650],[74.257270,52.827559],[75.687151,52.120525],[76.921587,52.519003],[78.724361,53.603975],[83.066391,57.170625],[87.027424,60.346466],[88.392209,60.919262],[89.324085,60.828550],[89.806235,60.084260],[89.821846,58.696322],[89.354099,56.674667],[88.386181,54.029225],[86.759258,50.763643],[84.741099,47.823558],[82.379442,45.242847],[79.722025,43.055387],[76.816583,41.295058],[73.710855,39.995736],[70.452579,39.191299],[67.089491,38.915625],[62.860811,38.631619],[59.373298,37.568775],[55.948264,35.410856],[51.907021,31.841625],[48.826105,29.110067],[46.325870,27.331666],[44.562890,26.598662],[44.006801,26.653009],[43.693741,27.003295],[41.527923,30.768887],[37.477611,36.682825],[32.085311,44.126625],[38.537251,50.380025],[41.042421,53.054408],[43.093940,55.713387],[44.480101,58.049361],[44.989201,59.754725],[45.454185,64.091820],[46.775724,68.225312],[48.843694,72.039943],[51.547976,75.420450],[54.778446,78.251573],[58.424983,80.418050],[62.377465,81.804621],[66.525771,82.296025],[72.027731,82.306025],[65.055381,76.175125]]);
    linear_extrude(height=h)
      polygon([[-56.815957,79.441525],[-54.591631,78.033304],[-52.499413,76.214536],[-50.589995,74.067078],[-48.914070,71.672787],[-47.522330,69.113520],[-46.465468,66.471133],[-45.794176,63.827482],[-45.559147,61.264425],[-45.091945,59.132845],[-43.819857,56.469562],[-41.937165,53.614411],[-39.638147,50.907225],[-33.717137,44.798425],[-38.223337,39.280125],[-42.039476,34.338837],[-44.886637,30.207925],[-46.231599,28.370215],[-46.889618,27.999901],[-47.649343,28.026116],[-49.807962,29.360647],[-53.375547,32.558825],[-56.832517,35.395111],[-60.332556,37.379762],[-64.232673,38.670795],[-68.889877,39.426225],[-72.655448,40.039614],[-76.058572,41.052089],[-79.098563,42.463097],[-81.774733,44.272087],[-84.086395,46.478507],[-86.032861,49.081805],[-87.613443,52.081428],[-88.827454,55.476825],[-89.682935,59.659502],[-89.566044,60.786352],[-89.077811,61.272237],[-88.212044,61.118678],[-86.962553,60.327192],[-83.287631,56.836525],[-79.471072,53.505850],[-77.775000,52.492647],[-76.516633,52.120525],[-74.985704,52.827333],[-72.547486,54.751812],[-66.291267,61.078125],[-58.406397,70.035725],[-65.502047,76.169425],[-72.597681,82.303025],[-67.473647,82.303025],[-65.047435,82.077231],[-62.229278,81.462450],[-59.368884,80.552581],[-56.815957,79.441525]]);
  }
}

scale([LogoScaleX, LogoScaleY , 1])
color(LogoColor)
poly_HackADayLogo(ExtrudeHeight);