
singleton TSShapeConstructor(Ekasia_tumula_01_aDae)
{
   baseShape = "./ekasia_tumula_01_a.dae";
};

function Ekasia_tumula_01_aDae::onLoad(%this)
{
   %this.addImposter("24", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("160", "320");
   %this.setDetailLevelSize("80", "128");
}
