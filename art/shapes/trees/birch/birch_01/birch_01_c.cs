
singleton TSShapeConstructor(Birch_01_cDae)
{
   baseShape = "./birch_01_c.dae";
   loadLights = "0";
};

function Birch_01_cDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("80", "128");
}
