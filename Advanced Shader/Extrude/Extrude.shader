Shader "Advanced/Extrude" {
	Properties{
		_MainTex("Texture", 2D) = "white"{}
	}
	SubShader{
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;   //
		};

		struct appdata {
			float4 vertex:POSITION;
			float3 normal:NORMAL;
			float4 texcoord:TEXCOORD0;
		};

		void vert(inout appdata v) {
			v.vertex.xyz+=v.normal*0.1;
		}

		void surf(Input IN, inout SurfaceOutput o) {
			fixed4 a = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = a.rgb;
		}

		ENDCG
	}
		FallBack "Diffuse"
}