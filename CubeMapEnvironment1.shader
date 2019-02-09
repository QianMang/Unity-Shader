Shader "Custom/CubeMapEnvironment1" {  //with bump map
	Properties{
		_myDiffuseTex("Diffuse Texture", 2D) = "white"{}
		_myBumpTex("Bump Texture",2D) = "bump"{}
		_myBumpSlider("Bump Scale",Range(0,4)) = 1
		_myBrightSlider("Bright Scale",Range(0,10)) = 1
		_myCube("Cube Map",CUBE) = "white"{}
	}

		SubShader{
		CGPROGRAM
#pragma surface surf Lambert
	sampler2D _myDiffuseTex;
	sampler2D _myBumpTex;
	half _myBumpSlider;
	half _myBrightSlider;
	samplerCUBE _myCube;

	struct Input {
		float2 uv_myDiffuseTex;
		float2 uv_myBumpTex;
		float3 worldRefl; INTERNAL_DATA
	};

	void surf(Input IN, inout SurfaceOutput o) {

		o.Albedo = tex2D(_myDiffuseTex, IN.uv_myDiffuseTex).rgb;
		o.Normal = UnpackNormal(tex2D(_myBumpTex, IN.uv_myBumpTex)) * _myBrightSlider;
		o.Normal *= float3(_myBumpSlider, _myBumpSlider, 1);
		o.Emission = texCUBE(_myCube, WorldReflectionVector(IN, o.Normal)).rgb;
	}
	ENDCG
	}

		FallBack "Diffuse"



}