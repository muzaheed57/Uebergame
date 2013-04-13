
singleton TSShapeConstructor(Birch_01_aDae)
{
   baseShape = "./birch_01_a.dae";
   loadLights = "0";
};

function Birch_01_aDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("80", "128");
}
