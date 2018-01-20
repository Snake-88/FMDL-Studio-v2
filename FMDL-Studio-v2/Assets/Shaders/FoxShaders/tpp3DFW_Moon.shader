Shader "FoxShaders/tpp3DFW_Moon"
{
	Properties
	{
		SelfColor("SelfColor", Vector) = (0.0, 0.0, 0.0, 0.0)
		SelfColorIntensity("SelfColorIntensity", Vector) = (0.0, 0.0, 0.0, 0.0)
		Umin("Umin", Vector) = (0.0, 0.0, 0.0, 0.0)
		Vmin("Vmin", Vector) = (0.0, 0.0, 0.0, 0.0)
		Umax("Umax", Vector) = (0.0, 0.0, 0.0, 0.0)
		Vmax("Vmax", Vector) = (0.0, 0.0, 0.0, 0.0)
		Dummy0("Dummy0", Vector) = (0.0, 0.0, 0.0, 0.0)
		Mask_Tex_LIN("Mask_Tex_LIN", 2D) = "white" {}
	}
		
	Subshader
	{
		Tags{ "Queue" = "Geometry" "Ignore Projector" = "True" "RenderType" = "Opaque" }
		LOD 200

		Blend SrcAlpha OneMinusSrcAlpha

		AlphaToMask On

		Pass
		{
			ZWrite On
			ColorMask 0
		}

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows alpha
		#pragma target 3.0

		sampler2D Base_Tex_SRGB;
		sampler2D NormalMap_Tex_NRM;
		sampler2D SpecularMap_Tex_LIN;
		sampler2D Translucent_Tex_LIN;

		struct Input
		{
			float2 uvBase_Tex_SRGB;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 mainTex = tex2D(Base_Tex_SRGB, IN.uvBase_Tex_SRGB);
			o.Albedo = mainTex.rgb;
			o.Alpha = mainTex.a;
			o.Metallic = 0.0f;
			o.Smoothness = 1.0f - tex2D(SpecularMap_Tex_LIN, IN.uvBase_Tex_SRGB).g;
			fixed4 finalNormal = tex2D(NormalMap_Tex_NRM, IN.uvBase_Tex_SRGB);
			finalNormal.r = finalNormal.g;
			finalNormal.g = 1.0f - finalNormal.g;
			finalNormal.b = 1.0f;
			finalNormal.a = 1.0f;
			o.Normal = UnpackNormal(finalNormal);
		}
		ENDCG
	}
	FallBack "Standard"
}