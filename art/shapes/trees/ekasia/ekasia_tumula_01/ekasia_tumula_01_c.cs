
singleton TSShapeConstructor(Ekasia_tumula_01_cDae)
{
   baseShape = "./ekasia_tumula_01_c.dae";
};

function Ekasia_tumula_01_cDae::onLoad(%this)
{
   %this.setDetailLevelSize("160", "320");
   %this.setDetailLevelSize("80", "128");
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
}
