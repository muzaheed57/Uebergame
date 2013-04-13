
singleton Material(birch_01_a_birch_01_bark)
{
   mapTo = "birch_01_bark";
   diffuseColor[0] = "0.803922 0.803922 0.803922 1";
   specular[0] = "0 0 0 1";
   specularPower[0] = "1";
   doubleSided = "0";
   translucentBlendOp = "None";
   diffuseMap[0] = "art/shapes/trees/birch/birch_01/birch_01_bark_diffuse.dds";
   normalMap[0] = "art/shapes/trees/birch/birch_01/birch_01_bark_normal.dds";
     specularMap[0] = "art/shapes/trees/birch/birch_01/birch_01_bark_diffuse.dds";
   materialTag0 = "Bark";
};

singleton Material(birch_01_a_birch_01_leaves)
{
   mapTo = "birch_01_leaves";
   diffuseColor[0] = "0.937255 0.996078 0.639216 1";
   specular[0] = "0 0 0 1";
   specularPower[0] = "16";
   doubleSided = "1";
   translucent = "0";
   diffuseMap[0] = "art/shapes/trees/birch/birch_01/birch_01_leaves_diffuse.dds";
   alphaTest = "1";
   alphaRef = "80";
    subSurfaceColor[0] = "0.337255 0.352941 0.184314 1";
   normalMap[0] = "art/shapes/trees/birch/birch_01/birch_01_leaves_normal.dds";
   subSurface[0] = "1";
   materialTag0 = "Branch";
};
