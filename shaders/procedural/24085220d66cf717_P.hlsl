//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/torque.hlsl"

// Features:
// Vert Position
// Eye Space Depth (Out)
// Visibility
// Hardware Instancing

struct ConnectData
{
   float4 wsEyeVec        : TEXCOORD0;
   float visibility      : TEXCOORD1;
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
              uniform float3    vEye            : register(C0),
              uniform float4    oneOverFarplane : register(C1)
)
{
   Fragout OUT;

   // Vert Position
   
   // Eye Space Depth (Out)
#ifndef CUBE_SHADOW_MAP
   float eyeSpaceDepth = dot(vEye, (IN.wsEyeVec.xyz / IN.wsEyeVec.w));
#else
   float eyeSpaceDepth = length( IN.wsEyeVec.xyz / IN.wsEyeVec.w ) * oneOverFarplane.x;
#endif
   OUT.col = float4(eyeSpaceDepth.rrr,1);
   
   // Visibility
   fizzle( IN.vpos, IN.visibility );
   
   // Hardware Instancing
   

   return OUT;
}
