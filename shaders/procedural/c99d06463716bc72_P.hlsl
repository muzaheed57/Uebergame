//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/torque.hlsl"

// Features:
// Paraboloid Vert Transform
// Base Texture
// Alpha Test
// Visibility
// Depth (Out)

struct ConnectData
{
   float2 posXY           : TEXCOORD0;
   float2 texCoord        : TEXCOORD1;
   float2 vpos            : VPOS;
   float depth           : TEXCOORD2;
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
              uniform float     alphaTestValue  : register(C0),
              uniform float     visibility      : register(C1)
)
{
   Fragout OUT;

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
