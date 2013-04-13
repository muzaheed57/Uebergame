
singleton TSShapeConstructor(Boulder_01_medium_eggyDae)
{
   baseShape = "./boulder_01_medium_eggy.dae";
};

function Boulder_01_medium_eggyDae::onLoad(%this)
{
   %this.setDetailLevelSize("16", "12");
}
