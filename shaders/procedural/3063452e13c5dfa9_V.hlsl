//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/wind.hlsl"
//------------------------------------------------------------------------------
// Autogenerated 'Light Buffer Conditioner [RGB]' Uncondition Method
//------------------------------------------------------------------------------
inline void autogenUncondition_bde4cbab(in float4 bufferSample, out float3 lightColor, out float NL_att, out float specular)
{
   lightColor = bufferSample.rgb;
   NL_att = dot(bufferSample.rgb, float3(0.3576, 0.7152, 0.1192));
   specular = max(bufferSample.a / NL_att, 0.00001f);
}


#include "shaders/common/lighting.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Wind Effect
// Vert Position
// Base Texture
// Alpha Test
// Specular Map
// Bumpmap [Deferred]
// Deferred RT Lighting
// Pixel Specular [Deferred]
// Visibility
// Fog
// HDR Output
// Translucent
// DXTnm
// Forward Shaded Material

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
   float3x3 outWorldToTangent : TEXCOORD1;
   float3 outWsPosition   : TEXCOORD4;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4   windParams      : register(C13),
                  uniform float3   windDirAndSpeed : register(C0),
                  uniform float    accumTime       : register(C14),
                  uniform float4x4 objTrans        : register(C1),
                  uniform float4x4 modelview       : register(C5),
                  uniform float4x4 worldToObj      : register(C9)
)
{
   ConnectData OUT;

   // Wind Effect
   float3 inPosition = IN.position.xyz;
   [branch] if ( any( windDirAndSpeed ) ) {
   inPosition = windBranchBending( inPosition, normalize( IN.normal ), accumTime, windDirAndSpeed.z, IN.diffuse.g, windParams.y, IN.diffuse.r, dot( objTrans[3], 1 ), windParams.z, windParams.w, IN.diffuse.b );
   inPosition = windTrunkBending( inPosition, windDirAndSpeed.xy, inPosition.z * windParams.x );
   } // [branch]
   
   // Vert Position
   OUT.hpos = mul(modelview, float4(inPosition.xyz,1));
   
   // Base Texture
   OUT.out_texCoord = (float2)IN.texCoord;
   
   // Alpha Test
   
   // Specular Map
   
   // Bumpmap [Deferred]
   float3x3 objToTangentSpace;
   objToTangentSpace[0] = IN.T;
   objToTangentSpace[1] = cross( IN.T, normalize(IN.normal) ) * IN.tangentW;
   objToTangentSpace[2] = normalize(IN.normal);
   float3x3 worldToTangent = mul( objToTangentSpace, (float3x3)worldToObj );
   OUT.outWorldToTangent = worldToTangent;
   
   // Deferred RT Lighting
   OUT.outWsPosition = mul( objTrans, float4( inPosition.xyz, 1 ) ).xyz;
   
   // Pixel Specular [Deferred]
   
   // Visibility
   
   // Fog
   
   // HDR Output
   
   // Translucent
   
   // DXTnm
   
   // Forward Shaded Material
   
   return OUT;
}
