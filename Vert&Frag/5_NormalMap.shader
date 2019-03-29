Shader "Unlit/5NormalMap"
{
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture",2D) = "white"{}
		_BumpMap("Normal Map",2D)="bump"{}
		_BumpScale("Bump Scale",Float)=1.0
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(1,250)) = 20
	}
	SubShader{
		Pass{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "UnityCG.cginc"
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex: POSITION;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f {
				float4 pos:POSITION;
				float4 uv :TEXCOORD0;  // xy for _MainTex  , zw for _BumpMap
				float3 lightDir:TEXCOORD1;
				float3 viewDir:TEXCOORD2;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.uv.xy=v.texcoord.xy * _MainTex_ST.xy+_MainTex_ST.zw;
				o.uv.zw=v.texcoord.xy*_BumpMap_ST.xy+_BumpMap_ST.zw;

				fixed3 worldNormal =UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent=UnityObjectToWorldNormal(v.tangent.xyz);
				fixed3 worldBinormal =cross(v.normal,v.tangent.xyz) * v.tangent.w;
				float3x3 worldToTangent= float3x3(worldTangent,worldBinormal,worldNormal);
				
				o.lightDir=mul(worldToTangent,WorldSpaceLightDir(v.vertex));
				o.viewDir=mul(worldToTangent,WorldSpaceViewDir(v.vertex));
				return o;
			}
			fixed4 frag(v2f i) : SV_Target{
				fixed3 tangentLightDir=normalize(i.lightDir);
				fixed3 tangentViewDir=normalize(i.viewDir);
				
				//get the texel in the normal Map
				fixed4 packedNormal=tex2D(_BumpMap,i.uv.zw);
				fixed3 tangentNormal;
				tangentNormal=UnpackNormal(packedNormal);
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z=sqrt(1.0-saturate( dot(tangentNormal.xy,tangentNormal.xy)));

				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				fixed3 diffuse =_LightColor0.rgb * albedo * max(0,dot(tangentNormal,tangentLightDir));
				fixed3 halfDir=normalize(tangentLightDir+tangentViewDir);
				fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(max(0,dot(tangentNormal,halfDir)),_Gloss);
				return fixed4(ambient+diffuse+specular,1.0);
			}



			ENDCG

		}
	}
	Fallback "Specular"
}