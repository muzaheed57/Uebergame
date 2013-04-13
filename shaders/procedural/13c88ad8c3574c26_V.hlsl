//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/torque.hlsl"
#include "shaders/common/terrain/terrain.hlsl"

// Features:
// Vert Position
// Terrain Base Texture
// Terrain Detail Texture 0
// Terrain Detail Texture 1
// Terrain Detail Texture 2
// Eye Space Depth (Out)
// GBuffer Conditioner

struct VertData
{
   float3 position        : POSITION;
   float3 normal          : NORMAL;
   float tcTangentZ      : TEXCOORD0;
   float tcEmpty         : TEXCOORD1;
};


struct ConnectData
{
   float4 hpos            : POSITION;
   float3 outTexCoord     : TEXCOORD0;
   float4 detCoord0       : TEXCOORD1;
   float4 detCoord1       : TEXCOORD2;
   float4 detCoord2       : TEXCOORD3;
   float4 wsEyeVec        : TEXCOORD4;
   float3 gbNormal        : TEXCOORD5;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float    oneOverTerrainSize : register(C16),
                  uniform float    squareSize      : register(C17),
                  uniform float3   eyePos          : register(C12),
                  uniform float4   detailScaleAndFade0 : register(C13),
                  uniform float4   detailScaleAndFade1 : register(C14),
                  uniform float4   detailScaleAndFade2 : register(C15),
                  uniform float4x4 objTrans        : register(C4),
                  uniform float3   eyePosWorld     : register(C18),
                  uniform float4x4 worldViewOnly   : register(C8)
)
{
   ConnectData OUT;

   // Vert Position
   OUT.hpos = mul(modelview, float4(IN.position.xyz,1));
   
   // Terrain Base Texture
   float3 texCoord = IN.position.xyz * float3( oneOverTerrainSize, oneOverTerrainSize, -oneOverTerrainSize );
   OUT.outTexCoord.xy = texCoord.xy;
   OUT.outTexCoord.z = 0;
   float3 T = normalize( float3( squareSize, 0, IN.tcTangentZ ) );
   
   // Terrain Detail Texture 0
   float dist = distance( IN.position.xyz, eyePos );
   OUT.detCoord0.xyz = texCoord * detailScaleAndFade0.xyx;
   OUT.detCoord0.w = clamp( ( detailScaleAndFade0.z - dist ) * detailScaleAndFade0.w, 0.0, 1.0 );
   
   // Terrain Detail Texture 1
   OUT.detCoord1.xyz = texCoord * detailScaleAndFade1.xyx;
   OUT.detCoord1.w = clamp( ( detailScaleAndFade1.z - dist ) * detailScaleAndFade1.w, 0.0, 1.0 );
   
   // Terrain Detail Texture 2
   OUT.detCoord2.xyz = texCoord * detailScaleAndFade2.xyx;
   OUT.detCoord2.w = clamp( ( detailScaleAndFade2.z - dist ) * detailScaleAndFade2.w, 0.0, 1.0 );
   
   // Eye Space Depth (Out)
   float3 depthPos = mul( objTrans, float4( IN.position.xyz, 1 ) ).xyz;
   OUT.wsEyeVec = float4( depthPos.xyz - eyePosWorld, 1 );
   
   // GBuffer Conditioner
   OUT.gbNormal = mul(worldViewOnly, float4( normalize(IN.normal), 0.0 ) ).xyz;
   
   return OUT;
}
