
singleton TSShapeConstructor(Bigleafplant_01_tallDae)
{
   baseShape = "./bigleafplant_01_tall.dae";
};

function Bigleafplant_01_tallDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "80", "1", "0");
}
