//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/imposter.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Imposter Vert
// Paraboloid Vert Transform
// Base Texture
// Alpha Test
// Visibility
// Depth (Out)

struct ConnectData
{
   float imposterFade    : TEXCOORD0;
   float2 posXY           : TEXCOORD1;
   float2 texCoord        : TEXCOORD2;
   float2 vpos            : VPOS;
   float depth           : TEXCOORD3;
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
              uniform float     alphaTestValue  : register(C1)
)
{
   Fragout OUT;

   // Imposter Vert
   visibility *= IN.imposterFade;
   
   // Paraboloid Vert Transform
   clip( 1.0 - abs(IN.posXY.x) );
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Alpha Test
   clip( OUT.col.a - alphaTestValue );
   
   // Visibility
   fizzle( IN.vpos, visibility );
   
   // Depth (Out)
   OUT.col = float4( IN.depth, 0, 0, 1 );
   

   return OUT;
}
