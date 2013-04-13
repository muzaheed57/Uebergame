
singleton TSShapeConstructor(Thuja_01_small_lowDae)
{
   baseShape = "./thuja_01_small_low.dae";
};

function Thuja_01_small_lowDae::onLoad(%this)
{
   %this.addImposter("32", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("80", "128");
}
