//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/torque.hlsl"

// Features:
// Vert Position
// Base Texture
// Visibility
// Fog
// HDR Output
// Translucent
// Hardware Instancing
// Forward Shaded Material

struct ConnectData
{
   float2 texCoord        : TEXCOORD0;
   float visibility      : TEXCOORD1;
   float3 wsPosition      : TEXCOORD2;
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
              uniform float4    fogColor        : register(C0),
              uniform float3    eyePosWorld     : register(C1),
              uniform float3    fogData         : register(C2)
)
{
   Fragout OUT;

   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Visibility
   OUT.col.a *= IN.visibility;
   
   // Fog
   float fogAmount = saturate( computeSceneFog( eyePosWorld, IN.wsPosition, fogData.r, fogData.g, fogData.b ) );
   OUT.col.rgb = lerp( fogColor.rgb, OUT.col.rgb, fogAmount );
   
   // HDR Output
   OUT.col = hdrEncode( OUT.col );
   
   // Translucent
   
   // Hardware Instancing
   
   // Forward Shaded Material
   

   return OUT;
}
