//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Features:
// Vert Position
// Base Texture
// Bumpmap [Deferred]
// NormalsOut
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
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float4x4 worldToObj      : register(C4)
)
{
   ConnectData OUT;

   // Vert Position
   OUT.hpos = mul(modelview, float4(IN.position.xyz,1));
   
   // Base Texture
   OUT.out_texCoord = (float2)IN.texCoord;
   
   // Bumpmap [Deferred]
   float3x3 objToTangentSpace;
   objToTangentSpace[0] = IN.T;
   objToTangentSpace[1] = cross( IN.T, normalize(IN.normal) ) * IN.tangentW;
   objToTangentSpace[2] = normalize(IN.normal);
   float3x3 worldToTangent = mul( objToTangentSpace, (float3x3)worldToObj );
   OUT.outWorldToTangent = worldToTangent;
   
   // NormalsOut
   
   // Forward Shaded Material
   
   return OUT;
}
