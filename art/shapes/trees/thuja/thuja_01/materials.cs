
singleton Material(thuja_01_small_low_thuja_bark_01)
{
   mapTo = "thuja_bark_01";
   diffuseMap[0] = "art/shapes/trees/thuja/thuja_01/thuja_01_bark_diffuse.dds";
   specular[0] = "0 0 0 1";
   specularPower[0] = "16";
   doubleSided = "0";
   translucentBlendOp = "None";
    diffuseColor[0] = "0.996078 0.87451 0.670588 1";
   materialTag0 = "Bark";
};

singleton Material(thuja_01_small_low_thuja_branch_01)
{
   mapTo = "thuja_branch_01";
   diffuseMap[0] = "art/shapes/trees/thuja/thuja_01/thuja_01_branch_diffuse.dds";
   specular[0] = "0 0 0 1";
   specularPower[0] = "16";
   doubleSided = "1";
   translucent = "0";
   diffuseColor[0] = "0.584314 0.737255 0.670588 1";
   alphaTest = "1";
    alphaRef = "80";
   subSurface[0] = "1";
   subSurfaceColor[0] = "0.380392 0.411765 0.262745 1";
   materialTag0 = "Branch";
};
