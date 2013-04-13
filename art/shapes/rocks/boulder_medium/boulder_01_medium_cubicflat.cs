
singleton TSShapeConstructor(Boulder_01_medium_cubicflatDae)
{
   baseShape = "./boulder_01_medium_cubicflat.dae";
};

function Boulder_01_medium_cubicflatDae::onLoad(%this)
{
   %this.removeImposter();
}
