//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/wind.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Wind Effect
// Vert Position
// Visibility
// Eye Space Depth (Out)
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
   float4 wsEyeVec        : TEXCOORD0;
   float3 gbNormal        : TEXCOORD1;
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
                  uniform float3   eyePosWorld     : register(C15),
                  uniform float4x4 worldViewOnly   : register(C9)
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
   
   // Visibility
   
   // Eye Space Depth (Out)
   float3 depthPos = mul( objTrans, float4( inPosition.xyz, 1 ) ).xyz;
   OUT.wsEyeVec = float4( depthPos.xyz - eyePosWorld, 1 );
   
   // GBuffer Conditioner
   OUT.gbNormal = mul(worldViewOnly, float4( normalize(IN.normal), 0.0 ) ).xyz;
   
   return OUT;
}
