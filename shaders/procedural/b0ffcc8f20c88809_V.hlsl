//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/torque.hlsl"

// Features:
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
   float tangentW        : TEXCOORD3;
   float3 normal          : NORMAL;
   float3 T               : TANGENT;
   float2 texCoord        : TEXCOORD0;
   float2 texCoord2       : TEXCOORD1;
   float4 diffuse         : COLOR;
   float texCoord3       : TEXCOORD2;
};


struct ConnectData
{
   float4 hpos            : POSITION;
   float2 out_texCoord    : TEXCOORD0;
   float3 outNegViewTS    : TEXCOORD1;
   float3x3 outViewToTangent : TEXCOORD2;
   float4 wsEyeVec        : TEXCOORD5;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float3   eyePos          : register(C4),
                  uniform float4x4 viewToObj       : register(C5),
                  uniform float4x4 objTrans        : register(C9),
                  uniform float3   eyePosWorld     : register(C13)
)
{
   ConnectData OUT;

   // Vert Position
   OUT.hpos = mul(modelview, float4(IN.position.xyz,1));
   
   // Parallax
   OUT.out_texCoord = (float2)IN.texCoord;
   float3x3 objToTangentSpace;
   objToTangentSpace[0] = IN.T;
   objToTangentSpace[1] = cross( IN.T, normalize(IN.normal) ) * IN.tangentW;
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
