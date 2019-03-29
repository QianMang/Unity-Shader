﻿Shader "Unlit/6_RampTexture" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		//_MainTex("Texture",2D)="white"{}
		_RampTex ("RampTex", 2D) = "white" {}
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss ("Smoothness", Range(8,200)) = 20
		
	}
	SubShader {
		Pass{
			Tags { "Lightmode"="ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			//sampler2D _MainTex;
			sampler2D _RampTex;
			float4 _RampTex_ST;
			fixed4 _Specular;
			float _Gloss;
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f {
				float4 pos:SV_POSITION;
				float3 worldNormal :TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};
			v2f vert(a2v v) {
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv=TRANSFORM_TEX(v.texcoord,_RampTex);
				return o;
			}
			fixed4 frag(v2f i) :SV_Target{
				fixed3 worldNormal=normalize(i.worldNormal);
				fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed halfLambert= 0.5 * dot(worldNormal,worldLightDir)+0.5;

				fixed3 diffuse = _LightColor0.rgb * tex2D(_RampTex,fixed2(halfLambert,halfLambert)).rgb * _Color.rgb;
				fixed3 viewDir=normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir=normalize(worldLightDir+viewDir);
				fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);
				return fixed4(ambient+diffuse+specular,1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
