
singleton TSShapeConstructor(Thuja_01_big_highDae)
{
   baseShape = "./thuja_01_big_high.dae";
   loadLights = "0";
};

function Thuja_01_big_highDae::onLoad(%this)
{
   %this.addImposter("32", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("80", "128");
}
