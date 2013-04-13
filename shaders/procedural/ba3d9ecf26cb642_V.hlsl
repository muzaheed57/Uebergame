//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/terrain/terrain.hlsl"
#include "shaders/common/lighting.hlsl"
//------------------------------------------------------------------------------
// Autogenerated 'Light Buffer Conditioner [RGB]' Uncondition Method
//------------------------------------------------------------------------------
inline void autogenUncondition_bde4cbab(in float4 bufferSample, out float3 lightColor, out float NL_att, out float specular)
{
   lightColor = bufferSample.rgb;
   NL_att = dot(bufferSample.rgb, float3(0.3576, 0.7152, 0.1192));
   specular = max(bufferSample.a / NL_att, 0.00001f);
}


#include "shaders/common/torque.hlsl"

// Features:
// Vert Position
// Terrain Base Texture
// Terrain Detail Texture 0
// Terrain Normal Texture 0
// Deferred RT Lighting
// Terrain Additive
// HDR Output
// DXTnm 0

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
   float4 screenspacePos  : TEXCOORD2;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float    oneOverTerrainSize : register(C6),
                  uniform float    squareSize      : register(C7),
                  uniform float3   eyePos          : register(C4),
                  uniform float4   detailScaleAndFade0 : register(C5)
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
   
   // Terrain Normal Texture 0
   
   // Deferred RT Lighting
   OUT.screenspacePos = OUT.hpos;
   
   // Terrain Additive
   
   // HDR Output
   
   // DXTnm 0
   
   return OUT;
}
