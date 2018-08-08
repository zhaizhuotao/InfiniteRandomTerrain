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

int hash[512] = {151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,
        140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,
        247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
         57,177, 33, 88,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
         74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
         60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
         65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
        200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
         52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
        207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
        119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
        129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
        218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
         81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
        184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
        222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180,
        151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,
        140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,
        247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
         57,177, 33, 88,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
         74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
         60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
         65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
        200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
         52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
        207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
        119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
        129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
        218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
         81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
        184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
        222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180};
int hashMask = 255;

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
    myPoint = frequency * myPoint;
    int ix0 = floor(myPoint.x);
    int iy0 = floor(myPoint.y);
    float tx = myPoint.x - ix0;
    float ty = myPoint.y - iy0;
    ix0 = ix0 % hashMask;
    iy0 = iy0 % hashMask;
    int ix1 = ix0 + 1;
    int iy1 = iy0 + 1;

    int h0 = hash[ix0];
    int h1 = hash[ix1];
    int h00 = hash[h0 + iy0];
    int h10 = hash[h1 + iy0];
    int h01 = hash[h0 + iy1];
    int h11 = hash[h1 + iy1];
    tx = Smooth(tx);
    ty = Smooth(ty);
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
    float3 g000 = gradients3D[hash[h00 + iz0] % gradientsMask3D];
    float3 g100 = gradients3D[hash[h10 + iz0] % gradientsMask3D];
    float3 g010 = gradients3D[hash[h01 + iz0] % gradientsMask3D];
    float3 g110 = gradients3D[hash[h11 + iz0] % gradientsMask3D];
    float3 g001 = gradients3D[hash[h00 + iz1] % gradientsMask3D];
    float3 g101 = gradients3D[hash[h10 + iz1] % gradientsMask3D];
    float3 g011 = gradients3D[hash[h01 + iz1] % gradientsMask3D];
    float3 g111 = gradients3D[hash[h11 + iz1] % gradientsMask3D];

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