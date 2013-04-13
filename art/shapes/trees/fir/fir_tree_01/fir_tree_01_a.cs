
singleton TSShapeConstructor(Fir_tree_01_aDae)
{
   baseShape = "./fir_tree_01_a.dae";
};

function Fir_tree_01_aDae::onLoad(%this)
{
   %this.addImposter("50", "6", "0", "0", "128", "1", "0");
}
