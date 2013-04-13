//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Features:
// Vert Position
// Base Texture
// Diffuse Color
// Alpha Test
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
              uniform sampler2D diffuseMap      : register(S0),
              uniform float4    diffuseMaterialColor : register(C0),
              uniform float     alphaTestValue  : register(C1)
)
{
   Fragout OUT;

   // Vert Position
   
   // Base Texture
   OUT.col = tex2D(diffuseMap, IN.texCoord);
   
   // Diffuse Color
   OUT.col *= diffuseMaterialColor;
   
   // Alpha Test
   clip( OUT.col.a - alphaTestValue );
   
   // NormalsOut
   IN.wsNormal = normalize( half3( IN.wsNormal ) );
   OUT.col = float4( ( -IN.wsNormal + 1 ) * 0.5, 1 );
   
   // Forward Shaded Material
   

   return OUT;
}
