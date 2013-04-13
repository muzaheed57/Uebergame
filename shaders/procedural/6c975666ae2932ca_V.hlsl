//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/foliage.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Foliage Feature
// Vert Position
// Parallax
// Base Texture
// Alpha Test
// Bumpmap [Deferred]
// Eye Space Depth (Out)
// Visibility
// GBuffer Conditioner

struct VertData
{
   float3 position        : POSITION;
   float3 normal          : NORMAL;
   float4 diffuse         : COLOR;
   float4 texCoord        : TEXCOORD0;
};


struct ConnectData
{
   float foliageFade     : TEXCOORD0;
   float4 hpos            : POSITION;
   float2 out_texCoord    : TEXCOORD1;
   float3 outNegViewTS    : TEXCOORD2;
   float3x3 outViewToTangent : TEXCOORD3;
   float4 wsEyeVec        : TEXCOORD6;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float3   eyePosWorld     : register(C13),
                  uniform float4x4 modelview       : register(C0),
                  uniform float3   eyePos          : register(C4),
                  uniform float4x4 viewToObj       : register(C5),
                  uniform float4x4 objTrans        : register(C9)
)
{
   ConnectData OUT;

   // Foliage Feature
   float3 T;
   foliageProcessVert( IN.position, IN.diffuse, IN.texCoord, IN.normal, T, eyePosWorld );
   OUT.foliageFade = IN.diffuse.a;
   
   // Vert Position
   OUT.hpos = mul(modelview, float4(IN.position.xyz,1));
   
   // Parallax
   OUT.out_texCoord = (float2)IN.texCoord;
   float3x3 objToTangentSpace;
   objToTangentSpace[0] = T;
   objToTangentSpace[1] = cross( T, normalize(IN.normal) );
   objToTangentSpace[2] = normalize(IN.normal);
   OUT.outNegViewTS = mul( objToTangentSpace, float3( IN.position.xyz - eyePos ) );
   OUT.outNegViewTS.y = -OUT.outNegViewTS.y;
   
   // Base Texture
   
   // Alpha Test
   
   // Bumpmap [Deferred]
   float3x3 viewToTangent = mul( objToTangentSpace, (float3x3)viewToObj );
   OUT.outViewToTangent = viewToTangent;
   
   // Eye Space Depth (Out)
   float3 depthPos = mul( objTrans, float4( IN.position.xyz, 1 ) ).xyz;
   OUT.wsEyeVec = float4( depthPos.xyz - eyePosWorld, 1 );
   
   // Visibility
   
   // GBuffer Conditioner
   
   return OUT;
}
