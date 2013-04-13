
singleton TSShapeConstructor(Thuja_01_big_lowDae)
{
   baseShape = "./thuja_01_big_low.dae";
   loadLights = "0";
};

function Thuja_01_big_lowDae::onLoad(%this)
{
   %this.addImposter("32", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("80", "128");
}
