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
// Terrain Parallax Texture 1
// Terrain Detail Texture 1
// Terrain Normal Texture 1
// Deferred RT Lighting
// Fog
// Terrain Additive
// HDR Output
// Forward Shaded Material
// DXTnm 0
// DXTnm 1

struct ConnectData
{
   float3 texCoord        : TEXCOORD0;
   float3 outNegViewTS    : TEXCOORD1;
   float4 detCoord0       : TEXCOORD2;
   float4 detCoord1       : TEXCOORD3;
   float3 wsNormal        : TEXCOORD4;
   float3 wsPosition      : TEXCOORD5;
};


struct Fragout
{
   float4 col : COLOR0;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform sampler2D baseTexMap      : register(S0),
              uniform sampler2D layerTex        : register(S1),
              uniform float     layerSize       : register(C17),
              uniform float3    detailIdStrengthParallax0 : register(C0),
              uniform sampler2D normalMap0      : register(S2),
              uniform sampler2D detailMap0      : register(S3),
              uniform float3    detailIdStrengthParallax1 : register(C1),
              uniform sampler2D normalMap1      : register(S4),
              uniform sampler2D detailMap1      : register(S5),
              uniform float3    eyePosWorld     : register(C18),
              uniform float4    inLightPos[3] : register(C2),
              uniform float4    inLightInvRadiusSq : register(C5),
              uniform float4    inLightColor[4] : register(C6),
              uniform float4    inLightSpotDir[3] : register(C10),
              uniform float4    inLightSpotAngle : register(C13),
              uniform float4    inLightSpotFalloff : register(C14),
              uniform float     specularPower   : register(C15),
              uniform float4    specularColor   : register(C16),
              uniform float4    ambient         : register(C19),
              uniform float4    fogColor        : register(C20),
              uniform float3    fogData         : register(C21)
)
{
   Fragout OUT;

   // Vert Position
   
   // Terrain Base Texture
   float4 baseColor = tex2D( baseTexMap, IN.texCoord.xy );
   OUT.col = baseColor;
   
   // Terrain Parallax Texture 0
   
   // Terrain Detail Texture 0
   float3 negViewTS = normalize( IN.outNegViewTS );
   float4 layerSample = round( tex2D( layerTex, IN.texCoord.xy ) * 255.0f );
   float detailBlend0 = calcBlend( detailIdStrengthParallax0.x, IN.texCoord.xy, layerSize, layerSample );
   float blendTotal = 0;
   blendTotal = max( blendTotal, detailBlend0 );
   IN.detCoord0.xy += parallaxOffset( normalMap0, IN.detCoord0.xy, negViewTS, detailIdStrengthParallax0.z * detailBlend0 );
   float4 detailColor;
   if ( detailBlend0 > 0.0f )
   {
      detailColor = ( tex2D( detailMap0, IN.detCoord0.xy ) * 2.0 ) - 1.0;
      detailColor *= detailIdStrengthParallax0.y * IN.detCoord0.w;
      OUT.col = lerp( OUT.col, baseColor + detailColor, detailBlend0 );
   }
   
   // Terrain Normal Texture 0
   
   // Terrain Parallax Texture 1
   
   // Terrain Detail Texture 1
   float detailBlend1 = calcBlend( detailIdStrengthParallax1.x, IN.texCoord.xy, layerSize, layerSample );
   blendTotal = max( blendTotal, detailBlend1 );
   IN.detCoord1.xy += parallaxOffset( normalMap1, IN.detCoord1.xy, negViewTS, detailIdStrengthParallax1.z * detailBlend1 );
   if ( detailBlend1 > 0.0f )
   {
      detailColor = ( tex2D( detailMap1, IN.detCoord1.xy ) * 2.0 ) - 1.0;
      detailColor *= detailIdStrengthParallax1.y * IN.detCoord1.w;
      OUT.col = lerp( OUT.col, baseColor + detailColor, detailBlend1 );
   }
   
   // Terrain Normal Texture 1
   
   // Deferred RT Lighting
   IN.wsNormal = normalize( half3( IN.wsNormal ) );
   float3 wsView = normalize( eyePosWorld - IN.wsPosition );
   float4 rtShading; float4 specular;
   compute4Lights( wsView, IN.wsPosition, IN.wsNormal, float4( 1, 1, 1, 1 ),
      inLightPos, inLightInvRadiusSq, inLightColor, inLightSpotDir, inLightSpotAngle, inLightSpotFalloff, specularPower, specularColor,
      rtShading, specular );
   OUT.col *= float4( rtShading.rgb + ambient.rgb, 1 );
   
   // Fog
   float fogAmount = saturate( computeSceneFog( eyePosWorld, IN.wsPosition, fogData.r, fogData.g, fogData.b ) );
   OUT.col.rgb = lerp( fogColor.rgb, OUT.col.rgb, fogAmount );
   
   // Terrain Additive
   clip( blendTotal - 0.0001 );
   OUT.col.a = blendTotal;
   
   // HDR Output
   OUT.col = hdrEncode( OUT.col );
   
   // Forward Shaded Material
   
   // DXTnm 0
   
   // DXTnm 1
   

   return OUT;
}
