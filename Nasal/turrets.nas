# Turret by 5H1N0B1
# GNU licence

var UPDATE_PERIOD = 0.01; # update interval for engine init() functions

#turret Gun class
var turret=
{
  #create new object
  new: func(name,index, view_number,heading_path,pitch_path)
  {
    # copy the turret object
    var m = { parents: [turret] };
    m.name = name;
    m.index = index;
    m.view = view_number;
    m.viewheading = props.globals.getNode("/sim/current-view/heading-offset-deg");
    m.viewpitch = props.globals.getNode("/sim/current-view/pitch-offset-deg");
    m.loop_running = 0;
    m.heading = props.globals.getNode(heading_path);
    m.pitch   = props.globals.getNode(pitch_path);

    return m;
  },

  #move the turret
  move: func
  {
    me.heading.setValue(me.viewheading.getValue());
    me.pitch.setValue(me.viewpitch.getValue());
    #me.update();
  },

  #Call the update loop
  init: func
  {
    if (me.loop_running) return;
    me.loop_running = 1;
    var loop = func
    {
      me.update();
      settimer(loop, UPDATE_PERIOD);
    };
    settimer(loop, 0);
  },
  #Create the update loop and the listener
  update: func
  {
    if(getprop("/sim/current-view/view-number") == me.view  ) {
      me.move();
    }
  }
};

#  nom     : TourelledeNez
#  index   :  0 <-Il s'agit de la première tourelle, la variable est definie dans sim/model/turret[0]
#  view    :  9 Il s'agit de l'index reel de la view, disponible ici : /sim/current-view/view-number
#  heading : path de la variable heading du model 3D
#  pitch   : path de la variable pitch du model 3D

#création de l'objet
var tourelledetoit = turret.new("TourelledeToit",0,10,"sim/model/turret[0]/heading","sim/model/turret[0]/pitch");
var tourelledequeue = turret.new("TourelledeQueue",1,11,"sim/model/turret[1]/heading","sim/model/turret[1]/pitch");
var tourelledenez = turret.new("TourelledeNez",2,12,"sim/model/turret[2]/heading","sim/model/turret[2]/pitch");

#init de l'objet
setlistener("sim/signals/fdm-initialized", func
{
  tourelledetoit.init(); 
  tourelledenez.init(); 
  tourelledequeue.init(); 
}, 0, 0);

#Note : pour rajouter une tourelle, s'assurer que les variables soient bonne, que la 3D soit présente. Ensuite Il suffit d'ajouter : 
# var tourelledetoit = turret.new("TourelledeToit",0,9,"sim/model/turret[0]/heading","sim/model/turret[0]/pitch");
# setlistener("sim/signals/fdm-initialized", func
#    tourelledetoit.init();
     #}, 0, 0);

#la gestion des tir n'a pas encore été faite    
