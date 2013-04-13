
singleton TSShapeConstructor(Thuja_01_small_highDae)
{
   baseShape = "./thuja_01_small_high.dae";
};

function Thuja_01_small_highDae::onLoad(%this)
{
   %this.addImposter("32", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("80", "128");
}
