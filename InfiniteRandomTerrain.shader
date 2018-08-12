﻿Shader "ZhaiZhuoTao/InfiniteRandomTerrain" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
        _PositionOffset("PositionOffset",Vector) = (0,0,0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows
        #pragma vertex vert
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
        #include "MyNoise.cginc"
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
            float3 customColor;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
        float4 _PositionOffset;
        void vert (inout appdata_full v,out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            float3 pos = v.vertex.xzy + _PositionOffset.xzy;
            float randomValue = Perlin2D(pos,8) + Perlin2D(pos,4) + Perlin2D(pos,2);
            v.vertex.y = 0.05 * randomValue;
            //v.vertex.y = Value2D(v.vertex.xzy,4)* 0.1;
            //o.customColor = fixed3(v.vertex.z,0,0);//x,z的取值范围是[-0.5,0.5],y的值保持不变。
            o.customColor = fixed3(0,randomValue,(1-randomValue)*(1-randomValue));
        }
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//o.Albedo = c.rgb;
            o.Albedo = IN.customColor;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
