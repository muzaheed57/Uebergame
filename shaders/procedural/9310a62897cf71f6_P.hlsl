//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/imposter.hlsl"
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
// Imposter Vert
// Vert Position
// Base Texture
// Alpha Test
// Bumpmap [Deferred]
// Deferred RT Lighting
// Visibility
// HDR Output
// DXTnm

struct ConnectData
{
   float imposterFade    : TEXCOORD0;
   float2 texCoord        : TEXCOORD1;
   float4 screenspacePos  : TEXCOORD2;
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
              uniform float4    rtParams1       : register(C2),
              uniform sampler2D lightInfoBuffer : register(S1)
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
   
   // Deferred RT Lighting
   float2 uvScene = IN.screenspacePos.xy / IN.screenspacePos.w;
   uvScene = ( uvScene + 1.0 ) / 2.0;
   uvScene.y = 1.0 - uvScene.y;
   uvScene = ( uvScene * rtParams1.zw ) + rtParams1.xy;
   float3 d_lightcolor;
   float d_NL_Att;
   float d_specular;
   lightinfoUncondition(tex2D(lightInfoBuffer, uvScene), d_lightcolor, d_NL_Att, d_specular);
   OUT.col *= float4(d_lightcolor, 1.0);
   
   // Visibility
   fizzle( IN.vpos, visibility );
   
   // HDR Output
   OUT.col = hdrEncode( OUT.col );
   
   // DXTnm
   

   return OUT;
}
