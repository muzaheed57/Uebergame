//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
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
// Vert Position
// Base Texture
// Diffuse Color
// Specular Map
// Bumpmap [Deferred]
// Deferred RT Lighting
// Sub-Surface Approximation [Deferred]
// Pixel Specular [Deferred]
// Visibility
// HDR Output
// DXTnm

struct ConnectData
{
   float2 texCoord        : TEXCOORD0;
   float4 screenspacePos  : TEXCOORD1;
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
              uniform float4    diffuseMaterialColor : register(C0),
              uniform sampler2D specularMap     : register(S1),
              uniform float4    rtParams2       : register(C4),
              uniform sampler2D lightInfoBuffer : register(S2),
              uniform float4    subSurfaceParams : register(C1),
              uniform float     specularPower   : register(C2),
              uniform float     visibility      : register(C3)
)
{
   Fragout OUT;

   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Diffuse Color
   OUT.col *= diffuseMaterialColor;
   
   // Specular Map
   float4 specularColor = tex2D(specularMap, IN.texCoord);
   
   // Bumpmap [Deferred]
   
   // Deferred RT Lighting
   float2 uvScene = IN.screenspacePos.xy / IN.screenspacePos.w;
   uvScene = ( uvScene + 1.0 ) / 2.0;
   uvScene.y = 1.0 - uvScene.y;
   uvScene = ( uvScene * rtParams2.zw ) + rtParams2.xy;
   float3 d_lightcolor;
   float d_NL_Att;
   float d_specular;
   lightinfoUncondition(tex2D(lightInfoBuffer, uvScene), d_lightcolor, d_NL_Att, d_specular);
   
   // Sub-Surface Approximation [Deferred]
   float subLamb = smoothstep(-subSurfaceParams.a, 1.0, d_NL_Att) - smoothstep(0.0, 1.0, d_NL_Att);
   subLamb = max(0.0, subLamb);
   OUT.col *= float4(d_lightcolor + (subLamb * subSurfaceParams.rgb), 1.0);
   
   // Pixel Specular [Deferred]
   float specular = pow( d_specular, ceil(specularPower / AL_ConstantSpecularPower)) * d_NL_Att;
   OUT.col += float4( specularColor.rgb, 0 ) * specular;
   
   // Visibility
   fizzle( IN.vpos, visibility );
   
   // HDR Output
   OUT.col = hdrEncode( OUT.col );
   
   // DXTnm
   

   return OUT;
}
