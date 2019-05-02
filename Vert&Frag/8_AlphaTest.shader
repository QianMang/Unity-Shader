﻿Shader "Unlit/8_AlphaTest"{
	Properties{
		_Color("Color",Color)=(1,1,1,1)
		_MainTex("MainTex",2D)="white"{}
		_CutOff("Alpha CutOff",Range(0,1))=0.5

	}
	SubShader{
		Tags{"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		Pass{
			Tags{"LightMode"="ForwardBase"}
			Cull Off   //
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _CutOff;

			struct a2v {
				float4 vertex: POSITION;
				float4 normal:NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv : TEXCOORD2;
			};
		
			v2f vert(a2v v) {
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex);
				o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);   // o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
				return o;
			}

			fixed4 frag(v2f i) :SV_Target{
				fixed3 worldNormal=normalize(i.worldNormal);
				fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed4 texColor=tex2D(_MainTex,i.uv);
				clip(texColor.a-_CutOff);

				fixed3 albedo=texColor.rgb * _Color.rgb;
				fixed3 ambient= UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffuse= _LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));
				return fixed4(ambient+diffuse,1.0);
			}
			ENDCG
		}
		
	}
	FallBack "Diffuse"
}