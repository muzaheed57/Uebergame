//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/wind.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Wind Effect
// Paraboloid Vert Transform
// Base Texture
// Alpha Test
// Visibility
// Depth (Out)
// Hardware Instancing

struct ConnectData
{
   float2 posXY           : TEXCOORD0;
   float2 texCoord        : TEXCOORD1;
   float visibility      : TEXCOORD2;
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
              uniform sampler2D diffuseMap      : register(S0),
              uniform float     alphaTestValue  : register(C0)
)
{
   Fragout OUT;

   // Wind Effect
   
   // Paraboloid Vert Transform
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
   

   return OUT;
}
