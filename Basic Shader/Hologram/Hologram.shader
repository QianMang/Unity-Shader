Shader "Custom/Hologram" {
	Properties{
		_RimColor("Rim Color", Color) = (0,0,0,0)
		_RimPower("Rim Power",Range(0.0,8.0)) = 2.0
	}



		SubShader{
			Tags{
				"Queue"="Transparent"
			}

			Pass{
				ZWrite On
				ColorMask 0
			}

			CGPROGRAM
			#pragma surface surf Lambert alpha:fade

			float4 _RimColor;
			float _RimPower;
			struct Input {
				float3 viewDir;

			};

			void surf(Input IN, inout SurfaceOutput o) {
				half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
				o.Emission = _RimColor.rgb * pow(rim,_RimPower);
				o.Alpha = pow(rim, _RimPower);

			}
			ENDCG

		}
		FallBack "Diffuse"
}
