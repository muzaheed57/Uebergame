
singleton Material(cedar_01_a_cedar_01_branch)
{
   mapTo = "cedar_01_branch";
   diffuseColor[0] = "0.741176 0.690196 0.470588 1";
   specular[0] = "0.5 0.5 0.5 1";
   specularPower[0] = "1";
   doubleSided = "1";
   translucent = "0";
   diffuseMap[0] = "art/shapes/trees/cedar/cedar_01/cedar_01_branch_diffuse.dds";
   normalMap[0] = "art/shapes/trees/cedar/cedar_01/cedar_01_branch_normal.dds";
   alphaTest = "1";
    alphaRef = "60";
   materialTag0 = "Branch";
};

singleton Material(cedar_01_a_cedar_01_bark)
{
   mapTo = "cedar_01_bark";
   diffuseColor[0] = "0.635294 0.564706 0.403922 1";
   specular[0] = "0.5 0.5 0.5 1";
   specularPower[0] = "1";
   doubleSided = "0";
   translucentBlendOp = "None";
   diffuseMap[0] = "art/shapes/trees/cedar/cedar_01/cedar_01_bark_diffuse.dds";
   materialTag0 = "Bark";
};
