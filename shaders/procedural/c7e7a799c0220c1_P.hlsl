//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/wind.hlsl"
//------------------------------------------------------------------------------
// Autogenerated 'Light Buffer Conditioner [RGB]' Uncondition Method
//------------------------------------------------------------------------------
inline void autogenUncondition_bde4cbab(in float4 bufferSample, out float3 lightColor, out float NL_att, out float specular)
{
   lightColor = bufferSample.rgb;
   NL_att = dot(bufferSample.rgb, float3(0.3576, 0.7152, 0.1192));
   specular = max(bufferSample.a / NL_att, 0.00001f);
}


#include "shaders/common/lighting.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Wind Effect
// Vert Position
// Base Texture
// Specular Map
// Bumpmap [Deferred]
// Deferred RT Lighting
// Pixel Specular [Deferred]
// Visibility
// Fog
// HDR Output
// Forward Shaded Material

struct ConnectData
{
   float2 texCoord        : TEXCOORD0;
   float3x3 worldToTangent  : TEXCOORD1;
   float3 wsPosition      : TEXCOORD4;
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
              uniform sampler2D diffuseMap      : register(S0),
              uniform sampler2D specularMap     : register(S1),
              uniform sampler2D bumpMap         : register(S2),
              uniform float3    eyePosWorld     : register(C15),
              uniform float4    inLightPos[3] : register(C0),
              uniform float4    inLightInvRadiusSq : register(C3),
              uniform float4    inLightColor[4] : register(C4),
              uniform float4    inLightSpotDir[3] : register(C8),
              uniform float4    inLightSpotAngle : register(C11),
              uniform float4    inLightSpotFalloff : register(C12),
              uniform float     specularPower   : register(C13),
              uniform float4    ambient         : register(C16),
              uniform float     visibility      : register(C14),
              uniform float4    fogColor        : register(C17),
              uniform float3    fogData         : register(C18)
)
{
   Fragout OUT;

   // Wind Effect
   
   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Specular Map
   float4 specularColor = tex2D(specularMap, IN.texCoord);
   
   // Bumpmap [Deferred]
   float4 bumpNormal = tex2D(bumpMap, IN.texCoord);
   bumpNormal.xyz = bumpNormal.xyz * 2.0 - 1.0;
   float3 wsNormal = normalize( mul( bumpNormal.xyz, IN.worldToTangent ) );
   
   // Deferred RT Lighting
   float3 wsView = normalize( eyePosWorld - IN.wsPosition );
   float4 rtShading; float4 specular;
   compute4Lights( wsView, IN.wsPosition, wsNormal, float4( 1, 1, 1, 1 ),
      inLightPos, inLightInvRadiusSq, inLightColor, inLightSpotDir, inLightSpotAngle, inLightSpotFalloff, specularPower, specularColor,
      rtShading, specular );
   OUT.col *= float4( rtShading.rgb + ambient.rgb, 1 );
   
   // Pixel Specular [Deferred]
   OUT.col.rgb += ( specular * specularColor ).rgb;
   
   // Visibility
   fizzle( IN.vpos, visibility );
   
   // Fog
   float fogAmount = saturate( computeSceneFog( eyePosWorld, IN.wsPosition, fogData.r, fogData.g, fogData.b ) );
   OUT.col.rgb = lerp( fogColor.rgb, OUT.col.rgb, fogAmount );
   
   // HDR Output
   OUT.col = hdrEncode( OUT.col );
   
   // Forward Shaded Material
   

   return OUT;
}
