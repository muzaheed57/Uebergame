//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/imposter.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Imposter Vert
// Paraboloid Vert Transform
// Base Texture
// Alpha Test
// Visibility
// Depth (Out)
// Single Pass Paraboloid

struct VertData
{
   float4 position        : POSITION;
   float2 tcImposterParams : TEXCOORD0;
   float3 tcImposterUpVec : TEXCOORD1;
   float3 tcImposterRightVec : TEXCOORD2;
};


struct ConnectData
{
   float imposterFade    : TEXCOORD0;
   float4 hpos            : POSITION;
   float isBack          : TEXCOORD1;
   float2 posXY           : TEXCOORD2;
   float2 out_texCoord    : TEXCOORD3;
   float depth           : TEXCOORD4;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4   imposterLimits  : register(C4),
                  uniform float4   imposterUVs[64] : register(C5),
                  uniform float3   eyePosWorld     : register(C69),
                  uniform float2   atlasScale      : register(C70),
                  uniform float4x4 worldViewOnly   : register(C0),
                  uniform float4   lightParams     : register(C71)
)
{
   ConnectData OUT;

   // Imposter Vert
   float3 inPosition;
   float2 texCoord;
   float3x3 worldToTangent;
   OUT.imposterFade = IN.tcImposterParams.y;
   imposter_v( IN.position.xyz, IN.position.w, IN.tcImposterParams.x * length(IN.tcImposterRightVec), normalize(IN.tcImposterUpVec), normalize(IN.tcImposterRightVec), imposterLimits.y, imposterLimits.x, imposterLimits.z, imposterLimits.w, eyePosWorld, imposterUVs, inPosition, texCoord, worldToTangent );
   float3 wsPosition = inPosition.xyz;
   float3x3 viewToTangent = worldToTangent;
   
   // Paraboloid Vert Transform
   OUT.hpos = mul(worldViewOnly, float4(inPosition.xyz,1)).xzyw;
   float L = length(OUT.hpos.xyz);
   bool isBack = OUT.hpos.z < 0.0;
   OUT.isBack = isBack ? -1.0 : 1.0;
   if ( isBack ) OUT.hpos.z = -OUT.hpos.z;
   OUT.hpos /= L;
   OUT.hpos.z = OUT.hpos.z + 1.0;
   OUT.hpos.xy /= OUT.hpos.z;
   OUT.hpos.z = L / lightParams.x;
   OUT.hpos.w = 1.0;
   OUT.posXY = OUT.hpos.xy;
   OUT.hpos.xy *= atlasScale.xy;
   OUT.hpos.x += isBack ? 0.5 : -0.5;
   
   // Base Texture
   OUT.out_texCoord = (float2)texCoord;
   
   // Alpha Test
   
   // Visibility
   
   // Depth (Out)
   OUT.depth = OUT.hpos.z / OUT.hpos.w;
   
   // Single Pass Paraboloid
   
   return OUT;
}
