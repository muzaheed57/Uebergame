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
   float2 posXY           : TEXCOORD1;
   float2 out_texCoord    : TEXCOORD2;
   float depth           : TEXCOORD3;
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
                  uniform float4   lightParams     : register(C71),
                  uniform float2   atlasXOffset    : register(C72)
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
   OUT.hpos /= L;
   OUT.hpos.z = OUT.hpos.z + 1.0;
   OUT.hpos.xy /= OUT.hpos.z;
   OUT.hpos.z = L / lightParams.x;
   OUT.hpos.w = 1.0;
   OUT.posXY = OUT.hpos.xy;
   OUT.hpos.xy *= atlasScale.xy;
   OUT.hpos.xy += atlasXOffset;
   
   // Base Texture
   OUT.out_texCoord = (float2)texCoord;
   
   // Alpha Test
   
   // Visibility
   
   // Depth (Out)
   OUT.depth = OUT.hpos.z / OUT.hpos.w;
   
   return OUT;
}
