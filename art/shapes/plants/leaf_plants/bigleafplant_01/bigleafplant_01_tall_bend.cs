
singleton TSShapeConstructor(Bigleafplant_01_tall_bendDae)
{
   baseShape = "./bigleafplant_01_tall_bend.dae";
};

function Bigleafplant_01_tall_bendDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "80", "1", "0");
}
