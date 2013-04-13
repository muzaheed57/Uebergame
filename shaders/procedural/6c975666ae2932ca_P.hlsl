//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/foliage.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Foliage Feature
// Vert Position
// Parallax
// Base Texture
// Alpha Test
// Bumpmap [Deferred]
// Eye Space Depth (Out)
// Visibility
// GBuffer Conditioner

struct ConnectData
{
   float foliageFade     : TEXCOORD0;
   float2 texCoord        : TEXCOORD1;
   float3 outNegViewTS    : TEXCOORD2;
   float3x3 viewToTangent   : TEXCOORD3;
   float4 wsEyeVec        : TEXCOORD6;
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
              uniform float     parallaxInfo    : register(C1),
              uniform sampler2D bumpMap         : register(S0),
              uniform sampler2D diffuseMap      : register(S1),
              uniform float     alphaTestValue  : register(C2),
              uniform float3    vEye            : register(C3),
              uniform float4    oneOverFarplane : register(C4)
)
{
   Fragout OUT;

   // Foliage Feature
   visibility *= IN.foliageFade;
   
   // Vert Position
   
   // Parallax
   float3 negViewTS = normalize( IN.outNegViewTS );
   IN.texCoord.xy += parallaxOffset( bumpMap, IN.texCoord.xy, negViewTS, parallaxInfo );
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Alpha Test
   clip( OUT.col.a - alphaTestValue );
   
   // Bumpmap [Deferred]
   float4 bumpNormal = tex2D(bumpMap, IN.texCoord);
   bumpNormal.xyz = bumpNormal.xyz * 2.0 - 1.0;
   half3 gbNormal = (half3)mul( bumpNormal.xyz, IN.viewToTangent );
   
   // Eye Space Depth (Out)
#ifndef CUBE_SHADOW_MAP
   float eyeSpaceDepth = dot(vEye, (IN.wsEyeVec.xyz / IN.wsEyeVec.w));
#else
   float eyeSpaceDepth = length( IN.wsEyeVec.xyz / IN.wsEyeVec.w ) * oneOverFarplane.x;
#endif
   
   // Visibility
   fizzle( IN.vpos, visibility );
   
   // GBuffer Conditioner
   float4 normal_depth = float4(normalize(gbNormal), eyeSpaceDepth);

   // output buffer format: GFXFormatR16G16B16A16F
   // g-buffer conditioner: float4(normal.X, normal.Y, depth Hi, depth Lo)
   float4 _gbConditionedOutput = float4(sqrt(half(2.0/(1.0 - normal_depth.y))) * half2(normal_depth.xz), 0.0, normal_depth.a);
   
   // Encode depth into hi/lo
   float2 _tempDepth = frac(normal_depth.a * float2(1.0, 65535.0));
   _gbConditionedOutput.zw = _tempDepth.xy - _tempDepth.yy * float2(1.0/65535.0, 0.0);

   OUT.col = _gbConditionedOutput;
   

   return OUT;
}
