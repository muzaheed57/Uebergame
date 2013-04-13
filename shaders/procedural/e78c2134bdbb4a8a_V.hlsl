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
// Terrain Parallax Texture 0
// Terrain Detail Texture 0
// Terrain Normal Texture 0
// Terrain Detail Texture 1
// Terrain Normal Texture 1
// Deferred RT Lighting
// Fog
// Terrain Additive
// HDR Output
// Forward Shaded Material
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
   float4 detCoord1       : TEXCOORD3;
   float3 wsNormal        : TEXCOORD4;
   float3 outWsPosition   : TEXCOORD5;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float    oneOverTerrainSize : register(C11),
                  uniform float    squareSize      : register(C12),
                  uniform float3   eyePos          : register(C8),
                  uniform float4   detailScaleAndFade0 : register(C9),
                  uniform float4   detailScaleAndFade1 : register(C10),
                  uniform float4x4 objTrans        : register(C4)
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
   
   // Terrain Parallax Texture 0
   
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
   
   // Terrain Detail Texture 1
   OUT.detCoord1.xyz = texCoord * detailScaleAndFade1.xyx;
   OUT.detCoord1.w = clamp( ( detailScaleAndFade1.z - dist ) * detailScaleAndFade1.w, 0.0, 1.0 );
   
   // Terrain Normal Texture 1
   
   // Deferred RT Lighting
   OUT.wsNormal = mul( objTrans, float4( normalize( IN.normal ), 0.0 ) ).xyz;
   OUT.outWsPosition = mul( objTrans, float4( IN.position.xyz, 1 ) ).xyz;
   
   // Fog
   
   // Terrain Additive
   
   // HDR Output
   
   // Forward Shaded Material
   
   // DXTnm 0
   
   // DXTnm 1
   
   return OUT;
}