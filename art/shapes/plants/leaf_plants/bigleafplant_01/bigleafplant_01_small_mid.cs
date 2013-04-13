
singleton TSShapeConstructor(Bigleafplant_01_small_midDae)
{
   baseShape = "./bigleafplant_01_small_mid.dae";
};

function Bigleafplant_01_small_midDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "80", "1", "0");
}
