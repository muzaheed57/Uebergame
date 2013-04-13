//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/torque.hlsl"

// Features:
// Vert Position
// Bumpmap [Deferred]
// Detail Normal Map
// Visibility
// Eye Space Depth (Out)
// GBuffer Conditioner
// Hardware Instancing

struct ConnectData
{
   float3x3 viewToTangent   : TEXCOORD0;
   float2 texCoord        : TEXCOORD3;
   float2 detCoord        : TEXCOORD4;
   float visibility      : TEXCOORD5;
   float2 vpos            : VPOS;
   float4 wsEyeVec        : TEXCOORD6;
};


struct Fragout
{
   float4 col : COLOR0;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform sampler2D bumpMap         : register(S0),
              uniform sampler2D detailBumpMap   : register(S1),
              uniform float     detailBumpStrength : register(C0),
              uniform float3    vEye            : register(C1),
              uniform float4    oneOverFarplane : register(C2)
)
{
   Fragout OUT;

   // Vert Position
   
   // Bumpmap [Deferred]
   float4 bumpNormal = tex2D(bumpMap, IN.texCoord);
   bumpNormal.xyz = bumpNormal.xyz * 2.0 - 1.0;
   float4 detailBump = tex2D(detailBumpMap, IN.detCoord);
   detailBump.xyz = detailBump.xyz * 2.0 - 1.0;
   bumpNormal.xy += detailBump.xy * detailBumpStrength;
   half3 gbNormal = (half3)mul( bumpNormal.xyz, IN.viewToTangent );
   
   // Detail Normal Map
   
   // Visibility
   fizzle( IN.vpos, IN.visibility );
   
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
   
   // Hardware Instancing
   

   return OUT;
}
