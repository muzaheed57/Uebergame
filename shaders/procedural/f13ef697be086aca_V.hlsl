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
// Terrain Normal Texture 0
// Terrain Parallax Texture 1
// Terrain Detail Texture 1
// Terrain Normal Texture 1
// Eye Space Depth (Out)
// GBuffer Conditioner
// DXTnm 0
// DXTnm 1

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
   float3 outNegViewTS    : TEXCOORD1;
   float4 detCoord0       : TEXCOORD2;
   float3x3 outViewToTangent : TEXCOORD3;
   float4 detCoord1       : TEXCOORD6;
   float4 wsEyeVec        : TEXCOORD7;
   float3 gbNormal        : TEXCOORD8;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float    oneOverTerrainSize : register(C19),
                  uniform float    squareSize      : register(C20),
                  uniform float3   eyePos          : register(C16),
                  uniform float4   detailScaleAndFade0 : register(C17),
                  uniform float4x4 viewToObj       : register(C4),
                  uniform float4   detailScaleAndFade1 : register(C18),
                  uniform float4x4 objTrans        : register(C8),
                  uniform float3   eyePosWorld     : register(C21),
                  uniform float4x4 worldViewOnly   : register(C12)
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
   float3x3 objToTangentSpace;
   objToTangentSpace[0] = T;
   objToTangentSpace[1] = cross( T, normalize(IN.normal) );
   objToTangentSpace[2] = normalize(IN.normal);
   OUT.outNegViewTS = mul( objToTangentSpace, float3( eyePos - IN.position.xyz ) );
   float dist = distance( IN.position.xyz, eyePos );
   OUT.detCoord0.xyz = texCoord * detailScaleAndFade0.xyx;
   OUT.detCoord0.w = clamp( ( detailScaleAndFade0.z - dist ) * detailScaleAndFade0.w, 0.0, 1.0 );
   
   // Terrain Normal Texture 0
   float3x3 viewToTangent = mul( objToTangentSpace, (float3x3)viewToObj );
   OUT.outViewToTangent = viewToTangent;
   
   // Terrain Parallax Texture 1
   
   // Terrain Detail Texture 1
   OUT.detCoord1.xyz = texCoord * detailScaleAndFade1.xyx;
   OUT.detCoord1.w = clamp( ( detailScaleAndFade1.z - dist ) * detailScaleAndFade1.w, 0.0, 1.0 );
   
   // Terrain Normal Texture 1
   
   // Eye Space Depth (Out)
   float3 depthPos = mul( objTrans, float4( IN.position.xyz, 1 ) ).xyz;
   OUT.wsEyeVec = float4( depthPos.xyz - eyePosWorld, 1 );
   
   // GBuffer Conditioner
   OUT.gbNormal = mul(worldViewOnly, float4( normalize(IN.normal), 0.0 ) ).xyz;
   
   // DXTnm 0
   
   // DXTnm 1
   
   return OUT;
}
