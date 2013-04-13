//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/torque.hlsl"
#include "shaders/common/terrain/terrain.hlsl"

// Features:
// Vert Position
// Terrain Base Texture
// Terrain Parallax Texture 0
// Terrain Detail Texture 0
// Terrain Normal Texture 0
// Terrain Detail Texture 1
// Terrain Normal Texture 1
// Eye Space Depth (Out)
// GBuffer Conditioner
// DXTnm 0
// DXTnm 1

struct ConnectData
{
   float3 texCoord        : TEXCOORD0;
   float3 outNegViewTS    : TEXCOORD1;
   float4 detCoord0       : TEXCOORD2;
   float3x3 viewToTangent   : TEXCOORD3;
   float4 detCoord1       : TEXCOORD6;
   float4 wsEyeVec        : TEXCOORD7;
};


struct Fragout
{
   float4 col : COLOR0;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform sampler2D layerTex        : register(S0),
              uniform float     layerSize       : register(C2),
              uniform float3    detailIdStrengthParallax0 : register(C0),
              uniform sampler2D normalMap0      : register(S1),
              uniform float3    detailIdStrengthParallax1 : register(C1),
              uniform sampler2D normalMap1      : register(S2),
              uniform float3    vEye            : register(C3),
              uniform float4    oneOverFarplane : register(C4)
)
{
   Fragout OUT;

   // Vert Position
   
   // Terrain Base Texture
   
   // Terrain Parallax Texture 0
   
   // Terrain Detail Texture 0
   float3 negViewTS = normalize( IN.outNegViewTS );
   float4 layerSample = round( tex2D( layerTex, IN.texCoord.xy ) * 255.0f );
   float detailBlend0 = calcBlend( detailIdStrengthParallax0.x, IN.texCoord.xy, layerSize, layerSample );
   float blendTotal = 0;
   blendTotal = max( blendTotal, detailBlend0 );
   IN.detCoord0.xy += parallaxOffset( normalMap0, IN.detCoord0.xy, negViewTS, detailIdStrengthParallax0.z * detailBlend0 );
   
   // Terrain Normal Texture 0
   float3 gbNormal = IN.viewToTangent[2];
   if ( detailBlend0 > 0.0f )
   {
   float4 bumpNormal = float4( tex2D(normalMap0, IN.detCoord0.xy).ag * 2.0 - 1.0, 0.0, 0.0 ); // DXTnm
   bumpNormal.z = sqrt( 1.0 - dot( bumpNormal.xy, bumpNormal.xy ) ); // DXTnm
      gbNormal = lerp( gbNormal, mul( bumpNormal.xyz, IN.viewToTangent ), min( detailBlend0, IN.detCoord0.w ) );
   }
   
   // Terrain Detail Texture 1
   float detailBlend1 = calcBlend( detailIdStrengthParallax1.x, IN.texCoord.xy, layerSize, layerSample );
   blendTotal = max( blendTotal, detailBlend1 );
   
   // Terrain Normal Texture 1
   if ( detailBlend1 > 0.0f )
   {
   float4 bumpNormal = float4( tex2D(normalMap1, IN.detCoord1.xy).ag * 2.0 - 1.0, 0.0, 0.0 ); // DXTnm
   bumpNormal.z = sqrt( 1.0 - dot( bumpNormal.xy, bumpNormal.xy ) ); // DXTnm
      gbNormal = lerp( gbNormal, mul( bumpNormal.xyz, IN.viewToTangent ), min( detailBlend1, IN.detCoord1.w ) );
   }
   
   // Eye Space Depth (Out)
#ifndef CUBE_SHADOW_MAP
   float eyeSpaceDepth = dot(vEye, (IN.wsEyeVec.xyz / IN.wsEyeVec.w));
#else
   float eyeSpaceDepth = length( IN.wsEyeVec.xyz / IN.wsEyeVec.w ) * oneOverFarplane.x;
#endif
   
   // GBuffer Conditioner
   float4 normal_depth = float4(normalize(gbNormal), eyeSpaceDepth);

   // output buffer format: GFXFormatR16G16B16A16F
   // g-buffer conditioner: float4(normal.X, normal.Y, depth Hi, depth Lo)
   float4 _gbConditionedOutput = float4(sqrt(half(2.0/(1.0 - normal_depth.y))) * half2(normal_depth.xz), 0.0, normal_depth.a);
   
   // Encode depth into hi/lo
   float2 _tempDepth = frac(normal_depth.a * float2(1.0, 65535.0));
   _gbConditionedOutput.zw = _tempDepth.xy - _tempDepth.yy * float2(1.0/65535.0, 0.0);

   OUT.col = _gbConditionedOutput;
   
   // DXTnm 0
   
   // DXTnm 1
   

   return OUT;
}
