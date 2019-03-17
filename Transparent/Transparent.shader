Shader "Custom/Transparent" {
	Properties{
		_MainTex("texture",2D) = "black"{}
	}
	SubShader{
		Tags{
		"Queue" = "Transparent"
		}
		Cull off
		Blend SrcAlpha OneMinusSrcAlpha
		Pass{
		SetTexture[_MainTex]{ combine texture }
		}
	}

}