
singleton TSShapeConstructor(Bigleafplant_01_small_lowDae)
{
   baseShape = "./bigleafplant_01_small_low.dae";
};

function Bigleafplant_01_small_lowDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "80", "1", "0");
}
