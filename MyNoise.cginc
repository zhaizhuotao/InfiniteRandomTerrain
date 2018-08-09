#if !defined(NOISE_INCLUDED)
#define NOISE_INCLUDED
fixed gradients1D[2] = {
        1, -1
    };
fixed gradientsMask1D = 1;

fixed2 gradients2D[8] = {
    fixed2( 1, 0),
    fixed2(-1, 0),
    fixed2( 0, 1),
    fixed2( 0,-1),
    normalize(fixed2( 1, 1)),
    normalize(fixed2(-1, 1)),
    normalize(fixed2( 1,-1)),
    normalize(fixed2(-1,-1))
};
fixed gradientsMask2D = 7;

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
float Value2D(float3 myPoint, float frequency)
{
    myPoint.x = myPoint.x + 0.5;
    myPoint.y = myPoint.y + 0.5;
    myPoint.x = myPoint.x * hashMask;
    myPoint.y = myPoint.y * hashMask;
    myPoint = frequency * myPoint;

    int ix0 = floor(myPoint.x);
    int iy0 = floor(myPoint.y);
    float tx = myPoint.x - (float)ix0;
    float ty = myPoint.y - (float)iy0;
    //return tx;
    ix0 = ix0 % hashMask;
    iy0 = iy0 % hashMask;
    int ix1 = ix0 + 1;
    int iy1 = iy0 + 1;
    //return (float)ix0 / (float)hashMask;
    int h0 = hash[ix0];
    int h1 = hash[ix1];
    //return (float)h0/hashMask;
    int h00 = hash[h0 + iy0];
    int h10 = hash[h1 + iy0];
    int h01 = hash[h0 + iy1];
    int h11 = hash[h1 + iy1];
    //return (float)h11 / hashMask;
    tx = Smooth(tx);
    ty = Smooth(ty);
    return lerp(h00, h10, tx);
    return lerp(lerp(h00, h10, tx),lerp(h01, h11, tx),ty) * (1 / hashMask);
    //NoiseSample sample;
    //sample.value = lerp(
    //    lerp(h00, h10, tx),
    //    lerp(h01, h11, tx),
    //    ty) * (1f / hashMask);
    //sample.derivative.x = 0f;
    //sample.derivative.y = 0f;
    //sample.derivative.z = 0f;
    //sample.derivative *= frequency;
    //return sample;
}
float Perlin3D(float3 mypoint, float frequency)
{
    mypoint = frequency * mypoint;
    int ix0 = floor(mypoint.x);
    int iy0 = floor(mypoint.y);
    int iz0 = floor(mypoint.z);
    float tx0 = mypoint.x - ix0;
    float ty0 = mypoint.y - iy0;
    float tz0 = mypoint.z - iz0;
    float tx1 = tx0 - 1;
    float ty1 = ty0 - 1;
    float tz1 = tz0 - 1;
    ix0 = ix0 % hashMask;
    iy0 = iy0 % hashMask;
    iz0 = iz0 % hashMask;
    int ix1 = ix0 + 1;
    int iy1 = iy0 + 1;
    int iz1 = iz0 + 1;

    int h0 = hash[ix0];
    int h1 = hash[ix1];
    int h00 = hash[h0 + iy0];
    int h10 = hash[h1 + iy0];
    int h01 = hash[h0 + iy1];
    int h11 = hash[h1 + iy1];
    float3 g000 = gradients3D[(int)hash[h00 + iz0] % gradientsMask3D];
    float3 g100 = gradients3D[(int)hash[h10 + iz0] % gradientsMask3D];
    float3 g010 = gradients3D[(int)hash[h01 + iz0] % gradientsMask3D];
    float3 g110 = gradients3D[(int)hash[h11 + iz0] % gradientsMask3D];
    float3 g001 = gradients3D[(int)hash[h00 + iz1] % gradientsMask3D];
    float3 g101 = gradients3D[(int)hash[h10 + iz1] % gradientsMask3D];
    float3 g011 = gradients3D[(int)hash[h01 + iz1] % gradientsMask3D];
    float3 g111 = gradients3D[(int)hash[h11 + iz1] % gradientsMask3D];

    float v000 = Dot(g000, tx0, ty0, tz0);
    float v100 = Dot(g100, tx1, ty0, tz0);
    float v010 = Dot(g010, tx0, ty1, tz0);
    float v110 = Dot(g110, tx1, ty1, tz0);
    float v001 = Dot(g001, tx0, ty0, tz1);
    float v101 = Dot(g101, tx1, ty0, tz1);
    float v011 = Dot(g011, tx0, ty1, tz1);
    float v111 = Dot(g111, tx1, ty1, tz1);

    float tx = Smooth(tx0);
    float ty = Smooth(ty0);
    float tz = Smooth(tz0);
    return lerp(
        lerp(lerp(v000, v100, tx), lerp(v010, v110, tx), ty),
        lerp(lerp(v001, v101, tx), lerp(v011, v111, tx), ty),
        tz);
    //NoiseSample sample;
    //sample.value = lerp(
    //    lerp(lerp(v000, v100, tx), lerp(v010, v110, tx), ty),
    //    lerp(lerp(v001, v101, tx), lerp(v011, v111, tx), ty),
    //    tz);
    //sample.derivative.x = 0;
    //sample.derivative.y = 0;
    //sample.derivative.z = 0;
    //sample.derivative = sample.derivative * frequency;
    //return sample;
}
#endif