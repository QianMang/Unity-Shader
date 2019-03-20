Shader "Advanced/Outline" {

	Properties{
		_MainTex("Texture", 2D) = "white"{}
		_OutlineColor("Outline Color",Color)=(0,0,0,1)
		_Outline("Outline Width",Range(.002,0.1))=.005
	}

	SubShader{
		ZWrite off
		
		CGPROGRAM
			#pragma surface surf Lambert vertex:vert
			float _Outline;
			float4 _OutlineColor;
			sampler2D _MainTex;
			struct Input {
				float2 uv_MainTex;
			};
			
			void vert(inout appdata_full v) {
				v.vertex.xyz+=v.normal*_Outline;
			}

			void surf(Input IN, inout SurfaceOutput o) {
				o.Emission=_OutlineColor.rgb;
			}
		ENDCG

		ZWrite on
		CGPROGRAM
			#pragma surface surf Lambert

			sampler2D _MainTex;
			struct Input {
				float2 uv_MainTex;   
			};

			void surf(Input IN, inout SurfaceOutput o) {
				fixed4 a = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = a.rgb;
			}

		ENDCG
	}
		FallBack "Diffuse"
}