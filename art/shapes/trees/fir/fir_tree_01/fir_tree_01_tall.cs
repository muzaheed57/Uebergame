
singleton TSShapeConstructor(Fir_tree_01_tallDae)
{
   baseShape = "./fir_tree_01_tall.dae";
};

function Fir_tree_01_tallDae::onLoad(%this)
{
   %this.addImposter("50", "6", "0", "0", "128", "1", "0");
   %this.setDetailLevelSize("128", "128");
}
