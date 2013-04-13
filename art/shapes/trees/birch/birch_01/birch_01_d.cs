
singleton TSShapeConstructor(Birch_01_dDae)
{
   baseShape = "./birch_01_d.dae";
   loadLights = "0";
};

function Birch_01_dDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("80", "128");
}
