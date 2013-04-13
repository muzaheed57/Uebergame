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

struct VertData
{
   float3 position        : POSITION;
   float tangentW        : TEXCOORD3;
   float3 normal          : NORMAL;
   float3 T               : TANGENT;
   float2 texCoord        : TEXCOORD0;
   float2 texCoord2       : TEXCOORD1;
   float4 diffuse         : COLOR;
   float texCoord3       : TEXCOORD2;
   float4 inst_objectTrans[4] : TEXCOORD4;
   float inst_visibility : TEXCOORD8;
};


struct ConnectData
{
   float4 hpos            : POSITION;
   float isBack          : TEXCOORD0;
   float2 posXY           : TEXCOORD1;
   float2 out_texCoord    : TEXCOORD2;
   float visibility      : TEXCOORD3;
   float depth           : TEXCOORD4;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float2   atlasScale      : register(C0),
                  uniform float4x4 worldToCamera   : register(C1),
                  uniform float4   lightParams     : register(C5)
)
{
   ConnectData OUT;

   // Paraboloid Vert Transform
   float4x4 objTrans = { // Instancing!
      IN.inst_objectTrans[0],
      IN.inst_objectTrans[1],
      IN.inst_objectTrans[2],
      IN.inst_objectTrans[3] };
   float4x4 worldViewOnly = mul( worldToCamera, objTrans ); // Instancing!
   OUT.hpos = mul(worldViewOnly, float4(IN.position.xyz,1)).xzyw;
   float L = length(OUT.hpos.xyz);
   bool isBack = OUT.hpos.z < 0.0;
   OUT.isBack = isBack ? -1.0 : 1.0;
   if ( isBack ) OUT.hpos.z = -OUT.hpos.z;
   OUT.hpos /= L;
   OUT.hpos.z = OUT.hpos.z + 1.0;
   OUT.hpos.xy /= OUT.hpos.z;
   OUT.hpos.z = L / lightParams.x;
   OUT.hpos.w = 1.0;
   OUT.posXY = OUT.hpos.xy;
   OUT.hpos.xy *= atlasScale.xy;
   OUT.hpos.x += isBack ? 0.5 : -0.5;
   
   // Base Texture
   OUT.out_texCoord = (float2)IN.texCoord;
   
   // Alpha Test
   
   // Visibility
   OUT.visibility = IN.inst_visibility; // Instancing!
   
   // Depth (Out)
   OUT.depth = OUT.hpos.z / OUT.hpos.w;
   
   // Hardware Instancing
   
   // Single Pass Paraboloid
   
   return OUT;
}
