﻿Shader "Unlit/DiffuseVF"  //with shadow caster and accept
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"   //light
			#include "Lighting.cginc" 
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				fixed4 diff : COLOR0;
				float4 pos : SV_POSITION;    //pos instead of vertex  , for TRANSFER_SHADOW(o)
				SHADOW_COORDS(1)
			};
			//
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));   // _WorldSpaceLightPos0
				o.diff = nl * _LightColor0;       // _LightColor0
				TRANSFER_SHADOW(o)
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed shadow = SHADOW_ATTENUATION(i);
				//shadow will be near 0 (black) where darkest
				col.rgb *= i.diff * shadow;
				//col.rgb *= i.diff *  (shadow < 0.2 ? float3(1,0,0):shadow);     //red shadow
				
				return col;
			}
			ENDCG
		}

		Pass{    //shadow pass
			Tags{"LightMode"="ShadowCaster"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"
			struct appdata {
				float4 vertex: POSITION;
				float3 normal:NORMAL;
				float4 uv : TEXCOORD0;

			};
			struct v2f{
				V2F_SHADOW_CASTER;

			};
			v2f vert(appdata v){
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag(v2f i):SV_Target{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}
}