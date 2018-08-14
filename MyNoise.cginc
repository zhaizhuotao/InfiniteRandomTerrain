#if !defined(NOISE_INCLUDED)
#define NOISE_INCLUDED
fixed gradients1D[2] = {
        1, -1
    };
float gradientsMask1D = 1;
float4 gradients2D[8];
int gradientsMask2D;

fixed3 gradients3D[16] = {
    fixed3( 1, 1, 0),
    fixed3(-1, 1, 0),
    fixed3( 1,-1, 0),
    fixed3(-1,-1, 0),
    fixed3( 1, 0, 1),
    fixed3(-1, 0, 1),
    fixed3( 1, 0,-1),
    fixed3(-1, 0,-1),
    fixed3( 0, 1, 1),
    fixed3( 0,-1, 1),
    fixed3( 0, 1,-1),
    fixed3( 0,-1,-1),
    fixed3( 1, 1, 0),
    fixed3(-1, 1, 0),
    fixed3( 0,-1, 1),
    fixed3( 0,-1,-1)
};
int gradientsMask3D = 15;

float hash[512];

int hashMask;// = 255;

struct NoiseSample
{
    float value;
    float3 derivative;
};

float Smooth(float t)
{
    return t * t * t * (t * (t * 6 - 15) + 10);
}
float SmoothDerivative(float t)
{
    return 30 * t * t * (t * (t - 2) + 1);
}
float Dot(float2 g, float x, float y)
{
    return g.x * x + g.y * y;
}
float Dot(float3 g, float x, float y, float z)
{
    return g.x * x + g.y * y + g.z * z;
}
NoiseSample Value2D(float3 myPoint, float frequency)
{
    //将坐标从[-0.5,0.5]映射到[0.5,1.5]
    myPoint.x = myPoint.x + 1.0;
    myPoint.y = myPoint.y + 1.0;
    myPoint.x = frequency * myPoint.x;
    myPoint.y = frequency * myPoint.y;

    int ix0 = floor(myPoint.x);
    int iy0 = floor(myPoint.y);
    float tx = myPoint.x - (float)ix0;
    float ty = myPoint.y - (float)iy0;

    ix0 = fmod(ix0,hashMask);
    iy0 = fmod(iy0,hashMask);
    int ix1 = ix0 + 1;
    int iy1 = iy0 + 1;
   
    int h0 = hash[ix0];
    int h1 = hash[ix1];
    int h00 = hash[h0 + iy0];
    int h10 = hash[h1 + iy0];
    int h01 = hash[h0 + iy1];
    int h11 = hash[h1 + iy1];
    float dtx = SmoothDerivative(tx);
    float dty = SmoothDerivative(ty);
    tx = Smooth(tx);
    ty = Smooth(ty);
    float a = h00;
    float b = h10 - h00;
    float c = h01 - h00;
    float d = h11 - h01 - h10 + h00;
    NoiseSample mysample;
    mysample.value = (a + b * tx + (c + d * tx) * ty) / hashMask;
    mysample.derivative.x = (b + d * ty) * dtx;
    mysample.derivative.y = (c + d * tx) * dty;
    mysample.derivative.z = 0;
    mysample.derivative *= frequency;
    return mysample;
}
NoiseSample Perlin2D (float3 myPoint, float frequency) {
    //将坐标从[-0.5,0.5]映射到[0.5,1.5]
    myPoint.x = myPoint.x + 1;
    myPoint.y = myPoint.y + 1;

    myPoint *= frequency;
    int ix0 = floor(myPoint.x);
    int iy0 = floor(myPoint.y);
    float tx0 = myPoint.x - (float)ix0;
    float ty0 = myPoint.y - (float)iy0;
    float tx1 = tx0 - 1;
    float ty1 = ty0 - 1;
    ix0 = abs(fmod(ix0 , hashMask));
    iy0 = abs(fmod(iy0 , hashMask));
    int ix1 = ix0 + 1;
    int iy1 = iy0 + 1;
    
    int h0 = hash[ix0];
    int h1 = hash[ix1];

    float2 g00 = gradients2D[abs(fmod((int)hash[h0 + iy0] , gradientsMask2D))].xy;
    float2 g10 = gradients2D[abs(fmod((int)hash[h1 + iy0] , gradientsMask2D))].xy;
    float2 g01 = gradients2D[abs(fmod((int)hash[h0 + iy1] , gradientsMask2D))].xy;
    float2 g11 = gradients2D[abs(fmod((int)hash[h1 + iy1] , gradientsMask2D))].xy;

    float v00 = Dot(g00, tx0, ty0);
    float v10 = Dot(g10, tx1, ty0);
    float v01 = Dot(g01, tx0, ty1);
    float v11 = Dot(g11, tx1, ty1);

    float dtx = SmoothDerivative(tx0);
    float dty = SmoothDerivative(ty0);
    float tx = Smooth(tx0);
    float ty = Smooth(ty0);

    float a = v00;
    float b = v10 - v00;
    float c = v01 - v00;
    float d = v11 - v01 - v10 + v00;
    float2 da = g00;
    float2 db = g10 - g00;
    float2 dc = g01 - g00;
    float2 dd = g11 - g01 - g10 + g00;
    NoiseSample mysample;
    mysample.value = (a + b * tx + (c + d * tx) * ty);
    mysample.derivative.xy = da + db * tx + (dc + dd * tx) * ty;
    mysample.derivative.x += (b + d * ty) * dtx;
    mysample.derivative.y += (c + d * tx) * dty;
    mysample.derivative.z = 0;
    mysample.derivative = mysample.derivative * frequency;

    return mysample;
}
#endif