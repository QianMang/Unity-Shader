Shader "Custom/RimLight1" {
	Properties{
		_RimColor("Rim Color", Color) = (0,0.5,0.5,0.0)
		//_Texture("Texture",2D) = "white"{}
		_RimRange("Rim Range",Range(0,1))=0.8
	}



		SubShader{
			CGPROGRAM
				#pragma surface surf Lambert

		float4 _RimColor;
		sampler2D _Texture;
		float _RimRange;
		struct Input {
			float3 viewDir;
			float2 uv_Texture;
		};
			
		void surf(Input IN, inout SurfaceOutput o) {
			half rim =1-saturate( dot(normalize(IN.viewDir), o.Normal));
			if (rim > _RimRange)
				o.Emission = _RimColor;
			else
				o.Emission = 0;

		}
		ENDCG

	}
	FallBack "Diffuse"
}
