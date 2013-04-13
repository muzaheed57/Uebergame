//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Features:
// Vert Position
// Base Texture
// NormalsOut
// Forward Shaded Material

struct ConnectData
{
   float2 texCoord        : TEXCOORD0;
   float3 wsNormal        : TEXCOORD1;
};


struct Fragout
{
   float4 col : COLOR0;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform sampler2D diffuseMap      : register(S0)
)
{
   Fragout OUT;

   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // NormalsOut
   IN.wsNormal = normalize( half3( IN.wsNormal ) );
   OUT.col = float4( ( -IN.wsNormal + 1 ) * 0.5, OUT.col.a );
   
   // Forward Shaded Material
   

   return OUT;
}
