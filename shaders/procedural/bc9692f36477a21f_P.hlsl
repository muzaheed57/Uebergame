//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/imposter.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Imposter Vert
// Vert Position
// Base Texture
// Alpha Test
// Bumpmap [Deferred]
// Eye Space Depth (Out)
// Visibility
// GBuffer Conditioner
// DXTnm

struct ConnectData
{
   float imposterFade    : TEXCOORD0;
   float2 texCoord        : TEXCOORD1;
   float3x3 viewToTangent   : TEXCOORD2;
   float4 wsEyeVec        : TEXCOORD5;
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
              uniform sampler2D diffuseMap      : register(S0),
              uniform float     alphaTestValue  : register(C1),
              uniform sampler2D bumpMap         : register(S1),
              uniform float3    vEye            : register(C2),
              uniform float4    oneOverFarplane : register(C3)
)
{
   Fragout OUT;

   // Imposter Vert
   visibility *= IN.imposterFade;
   
   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Alpha Test
   clip( OUT.col.a - alphaTestValue );
   
   // Bumpmap [Deferred]
   float4 bumpNormal = float4( normalize( tex2D(bumpMap, IN.texCoord).xyw * 2.0 - 1.0 ), 0.0 ); // Obj DXTnm
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
   
   // DXTnm
   

   return OUT;
}
