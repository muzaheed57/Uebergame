//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/wind.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Wind Effect
// Paraboloid Vert Transform
// Alpha Test
// Visibility
// Depth (Out)
// Single Pass Paraboloid

struct ConnectData
{
   float isBack          : TEXCOORD0;
   float2 posXY           : TEXCOORD1;
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
              uniform float     visibility      : register(C0)
)
{
   Fragout OUT;

   // Wind Effect
   
   // Paraboloid Vert Transform
   clip( abs( IN.isBack ) - 0.999 );
   clip( 1.0 - abs(IN.posXY.x) );
   
   // Alpha Test
   
   // Visibility
   fizzle( IN.vpos, visibility );
   
   // Depth (Out)
   OUT.col = float4( IN.depth, 0, 0, 1 );
   
   // Single Pass Paraboloid
   

   return OUT;
}
