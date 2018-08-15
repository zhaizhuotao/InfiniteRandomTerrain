Shader "ZhaiZhuoTao/InfiniteRandomTerrainShader"
{
	Properties
	{
        _PositionOffset("PositionOffset",Vector) = (0,0,0)
		_MainTex ("MainTex", 2D) = "white"{}
        _SecondTex("SecondTex", 2D) = "white"{}
        _ThirdTex("ThirdTex",2D) = "white"{}
        _ColorTuner("ColorTuner",Range(0,1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
            Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#include "UnityStandardBRDF.cginc"
			//#include "UnityCG.cginc"
            #include "MyNoise.cginc"
			//struct appdata
			//{
			//	float4 vertex : POSITION;
			//	float2 uv : TEXCOORD0;
			//};

			struct v2f
			{
				float2 uv : TEXCOORD0;
                float2 uv1: TEXCOORD1;
                float2 uv2: TEXCOORD2;
                float3 localPos:TEXCOORD3;
                float3 normal : TEXCOORD4;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
            sampler2D _SecondTex;
            float4 _SecondTex_ST;
            sampler2D _ThirdTex;
            float4 _ThirdTex_ST;
			float4 _PositionOffset;
            float _ColorTuner;
			v2f vert (appdata_full v)
			{
				v2f o;
                float3 pos = v.vertex.xzy + _PositionOffset.xzy;
                float randomValue = Perlin2D(pos,8).value + Perlin2D(pos,4).value + Perlin2D(pos,2).value;
                //float randomValue = Value2D(pos,8).value + Value2D(pos,4).value + Value2D(pos,2).value;
                o.vertex = v.vertex;
                o.vertex.y = 0.05 * randomValue;
                float3 mynormal = Perlin2D(pos,8).derivative + Perlin2D(pos,4).derivative + Perlin2D(pos,2).derivative;
                //float3 mynormal = Value2D(pos,8).derivative + Value2D(pos,4).derivative + Value2D(pos,2).derivative;
                //o.normal = normalize(float3(-mynormal.x,1,-mynormal.y));
                o.normal = UnityObjectToWorldNormal(normalize(float3(-mynormal.x,1,-mynormal.y)));
                o.localPos = o.vertex;
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.texcoord1.xy, _SecondTex);
                o.uv2 = TRANSFORM_TEX(v.texcoord2.xy, _ThirdTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb;
				// sample the texture
                float height = (i.localPos.y + 0.05) / 0.1;
				fixed4 colMain = tex2D(_MainTex, i.uv) * saturate(1-4*height*height);
                fixed4 colSecond = tex2D(_SecondTex,i.uv1) * saturate(1-4*(height-0.5)*(height-0.5));
                fixed4 colThird = tex2D(_ThirdTex,i.uv2) * saturate(1-4*(height-1.0)*(height-1.0));
                fixed4 col = fixed4((0.75*DotClamped(lightDir,i.normal)+0.25) * (colMain + colSecond + colThird) * lightColor,1);
				return col;
			}
			ENDCG
		}
	}
}
