Shader "MyShaders/Hologram"
{
	Properties
	{
		_MainTex("Image", 2D) = "blue" {}
		_Color("Hologram color", Color) = (0,0,0,0)
		_Trans("Transparancy", Range(0,1)) = 0.5
		_Fragments("Fragments of the hologram", Range(0,100)) = 10
		_Border("Border for render", Range(0,1.5)) = 1
		_BorderColor("Color for the border", Color) = (1,1,1,1)
	}
		SubShader
		{
			Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }
			LOD 100

			Cull Off

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			Pass{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float3 worldPos : TEXCOORD1;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _Color;
				float _Trans;
				float _Border;
				float4 _BorderColor;

				v2f vert(appdata v)
				{
					v2f o;
					v.vertex.xy *= _Border;
					o.worldPos = mul(unity_ObjectToWorld, v.vertex);
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = _BorderColor;
					col.a *= _Trans;
					return col * 2;
				}
				ENDCG
			}

			Pass
			{
				ZWrite On
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float3 worldPos : TEXCOORD1;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _Color;
				float _Trans;
				float _Fragments;
				float _BlinkMagnitude;

				v2f vert(appdata v)
				{
					v2f o;
					o.worldPos = mul(unity_ObjectToWorld, v.vertex);
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv);
					col *= _Color;
					col.a = _Trans;
					clip(1 - i.vertex.y % _Fragments);
					return col;
				}
				ENDCG
			}
		}
}