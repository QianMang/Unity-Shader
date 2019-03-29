

Shader "Unlit/4texture"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture",2D)="white"{}
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(1,250)) = 20

	}
	SubShader
	{

		Pass{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord:TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 worldNormal : TEXCOORD0;
				fixed3 worldPos : TEXCOORD1;
				float2 uv: TEXCOORD2;
			};

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;   //
			fixed4 _Specular;
			float _Gloss;
			

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				i.worldNormal = normalize(i.worldNormal);
				//texture
				fixed3 albedo =tex2D(_MainTex,i.uv).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				//diffuse
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0 * albedo * saturate(dot(i.worldNormal,worldLightDir));
				//specular
				//fixed3 reflectDir = normalize(reflect(-worldLightDir,i.worldNormal));    //-worldLightDir
				
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				fixed3 reflectDir = normalize(worldLightDir + viewDir);   //Blinn-phong
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(dot(reflectDir,i.worldNormal),0),_Gloss);
				return fixed4(ambient + diffuse + specular,1.0);
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
