
singleton TSShapeConstructor(Misc_groundshrubs_01_aDae)
{
   baseShape = "./misc_groundshrubs_01_a.dae";
};

function Misc_groundshrubs_01_aDae::onLoad(%this)
{
   %this.addImposter("16", "6", "0", "0", "80", "1", "0");
   %this.setDetailLevelSize("2", "80");
}
