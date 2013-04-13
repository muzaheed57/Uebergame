
singleton TSShapeConstructor(Ekasia_tumula_01_bDae)
{
   baseShape = "./ekasia_tumula_01_b.dae";
};

function Ekasia_tumula_01_bDae::onLoad(%this)
{
   %this.setDetailLevelSize("160", "320");
   %this.setDetailLevelSize("80", "128");
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
}
