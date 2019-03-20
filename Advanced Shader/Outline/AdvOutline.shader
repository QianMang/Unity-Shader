Shader "Advanced/AdvOutline" {

	Properties{
		_MainTex("Texture", 2D) = "white"{}
		_OutlineColor("Outline Color",Color)=(0,0,0,1)
		_Outline("Outline Width",Range(.002,1))=.005
	}

	SubShader{
		Tags{"Queue"="Transparent"}

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

		Pass{
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			//#pragma multi_compile_fog
			#include "UnityCG.cginc"

			float _Outline;
			float4 _OutlineColor;
			struct appdata {
				float4 vertex: POSITION;
				float3 normal:NORMAL;
			};
			struct v2f {
				float4 pos:SV_POSITION;
				float4 color:COLOR;
			};
			v2f vert(appdata v) {
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				float3 norm=normalize(mul( (float3x3)UNITY_MATRIX_IT_MV , v.normal ) );
				float2 offset=TransformViewToProjection (norm.xy);
				o.pos.xy =o.pos.xy+ offset * o.pos.z *_Outline;
				o.color = _OutlineColor;
				return o;
			}
			fixed4 frag(v2f i) :SV_Target{
				return i.color;
			}
			ENDCG

		}

	}
		FallBack "Diffuse"
}