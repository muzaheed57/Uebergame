//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "shaders/common/wind.hlsl"
#include "shaders/common/torque.hlsl"

// Features:
// Wind Effect
// Vert Position
// Base Texture
// Alpha Test
// Bumpmap [Deferred]
// Visibility
// Eye Space Depth (Out)
// GBuffer Conditioner
// Hardware Instancing

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
   float3 inst_windDirAndSpeed : TEXCOORD4;
   float4 inst_objectTrans[4] : TEXCOORD5;
   float inst_visibility : TEXCOORD9;
};


struct ConnectData
{
   float4 hpos            : POSITION;
   float2 out_texCoord    : TEXCOORD0;
   float3x3 outViewToTangent : TEXCOORD1;
   float visibility      : TEXCOORD4;
   float4 wsEyeVec        : TEXCOORD5;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4   windParams      : register(C0),
                  uniform float    accumTime       : register(C1),
                  uniform float4x4 viewProj        : register(C2),
                  uniform float4x4 worldToCamera   : register(C6),
                  uniform float3   eyePosWorld     : register(C10)
)
{
   ConnectData OUT;

   // Wind Effect
   float4x4 objTrans = { // Instancing!
      IN.inst_objectTrans[0],
      IN.inst_objectTrans[1],
      IN.inst_objectTrans[2],
      IN.inst_objectTrans[3] };
   float3 inPosition = IN.position.xyz;
   [branch] if ( any( IN.inst_windDirAndSpeed ) ) {
   inPosition = windBranchBending( inPosition, normalize( IN.normal ), accumTime, IN.inst_windDirAndSpeed.z, IN.diffuse.g, windParams.y, IN.diffuse.r, dot( objTrans[3], 1 ), windParams.z, windParams.w, IN.diffuse.b );
   inPosition = windTrunkBending( inPosition, IN.inst_windDirAndSpeed.xy, inPosition.z * windParams.x );
   } // [branch]
   
   // Vert Position
   float4x4 modelview = mul( viewProj, objTrans ); // Instancing!
   OUT.hpos = mul(modelview, float4(inPosition.xyz,1));
   
   // Base Texture
   OUT.out_texCoord = (float2)IN.texCoord;
   
   // Alpha Test
   
   // Bumpmap [Deferred]
   float3x3 objToTangentSpace;
   objToTangentSpace[0] = IN.T;
   objToTangentSpace[1] = cross( IN.T, normalize(IN.normal) ) * IN.tangentW;
   objToTangentSpace[2] = normalize(IN.normal);
   float4x4 worldViewOnly = mul( worldToCamera, objTrans ); // Instancing!
   float3x3 viewToObj = transpose( (float3x3)worldViewOnly ); // Instancing!
   float3x3 viewToTangent = mul( objToTangentSpace, (float3x3)viewToObj );
   OUT.outViewToTangent = viewToTangent;
   
   // Visibility
   OUT.visibility = IN.inst_visibility; // Instancing!
   
   // Eye Space Depth (Out)
   float3 depthPos = mul( objTrans, float4( inPosition.xyz, 1 ) ).xyz;
   OUT.wsEyeVec = float4( depthPos.xyz - eyePosWorld, 1 );
   
   // GBuffer Conditioner
   
   // Hardware Instancing
   
   return OUT;
}
