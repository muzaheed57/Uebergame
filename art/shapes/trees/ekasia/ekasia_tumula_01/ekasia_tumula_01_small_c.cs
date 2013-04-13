
singleton TSShapeConstructor(Ekasia_tumula_01_small_cDae)
{
   baseShape = "./ekasia_tumula_01_small_c.dae";
   loadLights = "0";
};

function Ekasia_tumula_01_small_cDae::onLoad(%this)
{
   %this.setDetailLevelSize("160", "256");
   %this.setDetailLevelSize("80", "128");
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
}
