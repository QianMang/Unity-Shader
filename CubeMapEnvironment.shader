Shader "Custom/CubeMapEnvironment" {
	Properties{
		_myDiffuseTex("Diffuse Texture", 2D) = "white"{}
		_myBumpTex("Bump Texture",2D) = "bump"{}
		_myBumpSlider("Bump Scale",Range(0,4)) = 1
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
		float3 worldRefl;
	};

	void surf(Input IN, inout SurfaceOutput o) {
		o.Albedo = texCUBE(_myCube, IN.worldRefl).rgb;
		
	}
	ENDCG
	}

		FallBack "Diffuse"



}