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
// Hardware Instancing
// Single Pass Paraboloid

struct ConnectData
{
   float isBack          : TEXCOORD0;
   float2 posXY           : TEXCOORD1;
   float2 texCoord        : TEXCOORD2;
   float visibility      : TEXCOORD3;
   float2 vpos            : VPOS;
   float depth           : TEXCOORD4;
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
              uniform float     alphaTestValue  : register(C0)
)
{
   Fragout OUT;

   // Paraboloid Vert Transform
   clip( abs( IN.isBack ) - 0.999 );
   clip( 1.0 - abs(IN.posXY.x) );
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Alpha Test
   clip( OUT.col.a - alphaTestValue );
   
   // Visibility
   fizzle( IN.vpos, IN.visibility );
   
   // Depth (Out)
   OUT.col = float4( IN.depth, 0, 0, 1 );
   
   // Hardware Instancing
   
   // Single Pass Paraboloid
   

   return OUT;
}
