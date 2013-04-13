//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/imposter.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Imposter Vert
// Vert Position
// Base Texture
// Alpha Test
// Eye Space Depth (Out)
// Visibility

struct ConnectData
{
   float imposterFade    : TEXCOORD0;
   float2 texCoord        : TEXCOORD1;
   float4 wsEyeVec        : TEXCOORD2;
   float2 vpos            : VPOS;
};


struct Fragout
{
   float4 col : COLOR0;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform float     visibility      : register(C0),
              uniform sampler2D diffuseMap      : register(S0),
              uniform float     alphaTestValue  : register(C1),
              uniform float3    vEye            : register(C2),
              uniform float4    oneOverFarplane : register(C3)
)
{
   Fragout OUT;

   // Imposter Vert
   visibility *= IN.imposterFade;
   
   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Alpha Test
   clip( OUT.col.a - alphaTestValue );
   
   // Eye Space Depth (Out)
#ifndef CUBE_SHADOW_MAP
   float eyeSpaceDepth = dot(vEye, (IN.wsEyeVec.xyz / IN.wsEyeVec.w));
#else
   float eyeSpaceDepth = length( IN.wsEyeVec.xyz / IN.wsEyeVec.w ) * oneOverFarplane.x;
#endif
   OUT.col = float4(eyeSpaceDepth.rrr,1);
   
   // Visibility
   fizzle( IN.vpos, visibility );
   

   return OUT;
}
