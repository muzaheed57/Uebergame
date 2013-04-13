
singleton TSShapeConstructor(Misc_groundshrubs_01_cDae)
{
   baseShape = "./misc_groundshrubs_01_c.dae";
};

function Misc_groundshrubs_01_cDae::onLoad(%this)
{
   %this.addImposter("16", "6", "0", "0", "80", "1", "0");
   %this.setDetailLevelSize("2", "80");
}
