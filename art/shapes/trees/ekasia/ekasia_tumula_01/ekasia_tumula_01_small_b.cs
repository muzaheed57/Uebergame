
singleton TSShapeConstructor(Ekasia_tumula_01_small_bDae)
{
   baseShape = "./ekasia_tumula_01_small_b.dae";
};

function Ekasia_tumula_01_small_bDae::onLoad(%this)
{
   %this.setDetailLevelSize("160", "256");
   %this.setDetailLevelSize("80", "128");
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
}
