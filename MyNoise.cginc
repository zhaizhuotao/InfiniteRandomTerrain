#if !defined(NOISE_INCLUDED)
#define NOISE_INCLUDED
fixed gradients1D[2] = {
        1, -1
    };
float gradientsMask1D = 1;

float4 gradients2D[8];
//float2 gradients2D[8] = {
//    float2( 1, 0),
//    float2(-1, 0),
//    float2( 0, 1),
//    float2( 0,-1),
//    normalize(float2( 1, 1)),
//    normalize(float2(-1, 1)),
//    normalize(float2( 1,-1)),
//    normalize(float2(-1,-1))
//};
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
float Value2D(float3 myPoint, float frequency)
{
    //将坐标从[-0.5,0.5]映射到[0,1]
    myPoint.x = myPoint.x + 0.5;
    myPoint.y = myPoint.y + 0.5;
    //将坐标从[0,1]映射到[0,255]
    myPoint.x = myPoint.x * hashMask;
    myPoint.y = myPoint.y * hashMask;
    //这时才能使用坐标值作为下标值来访问数组
    myPoint = frequency * myPoint;

    int ix0 = floor(myPoint.x);
    int iy0 = floor(myPoint.y);
    float tx = myPoint.x - (float)ix0;
    float ty = myPoint.y - (float)iy0;

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
    float a = h00;
    float b = h10 - h00;
    float c = h01 - h00;
    float d = h11 - h01 - h10 + h00;
    return (a + b * tx + (c + d * tx) * ty) / hashMask;
}
float Perlin2D (float3 myPoint, float frequency) {
    //将坐标从[-0.5,0.5]映射到[0,1]
    myPoint.x = myPoint.x + 0.5;
    myPoint.y = myPoint.y + 0.5;
    //将坐标从[0,1]映射到[0,255]
    myPoint.x = myPoint.x * hashMask;
    myPoint.y = myPoint.y * hashMask;
    //这时才能使用坐标值作为下标值来访问数组
    myPoint *= frequency;
    int ix0 = floor(myPoint.x);
    int iy0 = floor(myPoint.y);
    float tx0 = myPoint.x - (float)ix0;
    float ty0 = myPoint.y - (float)iy0;
    float tx1 = tx0 - 1;
    float ty1 = ty0 - 1;
    ix0 = ix0 % hashMask;
    iy0 = iy0 % hashMask;
    int ix1 = ix0 + 1;
    int iy1 = iy0 + 1;
    
    int h0 = hash[ix0];
    int h1 = hash[ix1];

    float2 g00 = gradients2D[(int)hash[h0 + iy0] % (int)gradientsMask2D].xy;
    float2 g10 = gradients2D[(int)hash[h1 + iy0] % (int)gradientsMask2D].xy;
    float2 g01 = gradients2D[(int)hash[h0 + iy1] % (int)gradientsMask2D].xy;
    float2 g11 = gradients2D[(int)hash[h1 + iy1] % (int)gradientsMask2D].xy;

    float v00 = Dot(g00, tx0, ty0);
    float v10 = Dot(g10, tx1, ty0);
    float v01 = Dot(g01, tx0, ty1);
    float v11 = Dot(g11, tx1, ty1);

    float tx = Smooth(tx0);
    float ty = Smooth(ty0);

    float a = v00;
    float b = v10 - v00;
    float c = v01 - v00;
    float d = v11 - v01 - v10 + v00;

    return (a + b * tx + (c + d * tx) * ty);
}

float Perlin3D(float3 mypoint, float frequency)
{
    //将坐标从[-0.5,0.5]映射到[0,1]
    mypoint.x = mypoint.x + 0.5;
    mypoint.y = mypoint.y + 0.5;
    //将坐标从[0,1]映射到[0,255]
    mypoint.x = mypoint.x * hashMask;
    mypoint.y = mypoint.y * hashMask;
    //这时才能使用坐标值作为下标值来访问数组
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

    float a = v000;
    float b = v100 - v000;
    float c = v010 - v000;
    float d = v001 - v000;
    float e = v110 - v010 - v100 + v000;
    float f = v101 - v001 - v100 + v000;
    float g = v011 - v001 - v010 + v000;
    float h = v111 - v011 - v101 + v001 - v110 + v010 + v100 - v000;
    //return a + b * tx + (c + e * tx) * ty + (d + f * tx + (g + h * tx) * ty) * tz;
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