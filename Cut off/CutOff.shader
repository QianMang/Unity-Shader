Shader "Custom/CutOff" {
	Properties{
		_Color("Color", Color) = (0,0.5,0.5,0.0)
		_Color2("Color", Color) = (0,0.5,0.5,0.0)
		
		//_RimRange("Rim Range",Range(0,1)) = 0.8
	}



		SubShader{
		CGPROGRAM
#pragma surface surf Lambert

	float4 _Color;
	float4 _Color2;
	sampler2D _Texture;
	//float _RimRange;

	struct Input {
		float3 viewDir;
		float2 uv_Texture;
		float3 worldPos;
	};

	void surf(Input IN, inout SurfaceOutput o) {
		//half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
		if (frac(IN.worldPos.y * 10 * 0.5) > 0.4)
			o.Emission = _Color;// *rim;
		else
			o.Emission = _Color2;// *rim;

	}
	ENDCG

	}
		FallBack "Diffuse"
}
