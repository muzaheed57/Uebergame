//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/foliage.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Foliage Feature
// Vert Position
// Base Texture
// Diffuse Color
// Alpha Test
// Bumpmap [Deferred]
// Visibility
// HDR Output

struct ConnectData
{
   float foliageFade     : TEXCOORD0;
   float2 texCoord        : TEXCOORD1;
   float3x3 worldToTangent  : TEXCOORD2;
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
              uniform float4    diffuseMaterialColor : register(C1),
              uniform float     alphaTestValue  : register(C2),
              uniform sampler2D bumpMap         : register(S1)
)
{
   Fragout OUT;

   // Foliage Feature
   visibility *= IN.foliageFade;
   
   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Diffuse Color
   OUT.col *= diffuseMaterialColor;
   
   // Alpha Test
   clip( OUT.col.a - alphaTestValue );
   
   // Bumpmap [Deferred]
   float4 bumpNormal = tex2D(bumpMap, IN.texCoord);
   bumpNormal.xyz = bumpNormal.xyz * 2.0 - 1.0;
   float3 wsNormal = normalize( mul( bumpNormal.xyz, IN.worldToTangent ) );
   
   // Visibility
   fizzle( IN.vpos, visibility );
   
   // HDR Output
   OUT.col = hdrEncode( OUT.col );
   

   return OUT;
}
