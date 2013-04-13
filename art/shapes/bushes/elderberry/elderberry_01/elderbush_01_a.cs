
singleton TSShapeConstructor(Elderbush_01_aDae)
{
   baseShape = "./elderbush_01_a.dae";
};

function Elderbush_01_aDae::onLoad(%this)
{
   %this.addImposter("25", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("128", "320");
   %this.setDetailLevelSize("64", "128");
}
