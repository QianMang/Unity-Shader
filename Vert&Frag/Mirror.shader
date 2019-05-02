//Mirrior , use Render Texture and an additional orthographic camera
Shader "Custom/Mirror" {
	Properties {
		
		_MainTex ("texture", 2D) = "white" {}
		
	}
	SubShader {
		Tags{ "RenderType" = "Opaque" "Queue" = "Geometry" }
		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			sampler2D _MainTex;
			struct a2v{
				float4 vertex: POSITION;
				float2 texcoord:TEXCOORD0;
			};
			struct v2f {
				fixed4 pos:SV_POSITION;
				fixed2 uv:TEXCOORD0;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv=v.texcoord;
				o.uv.x=1-o.uv.x;
				return o;
			}
		
			fixed4 frag(v2f i) :SV_Target{
				return fixed4(tex2D(_MainTex,i.uv).rgb,1.0);
			}
			
			ENDCG
		}
	}
	FallBack Off
}
