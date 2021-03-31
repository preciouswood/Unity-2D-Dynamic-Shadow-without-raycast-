Shader "Unlit/ExtesionDistanceMapShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags {"RenderType"="Opaque" }
        LOD 100

        Pass
		{
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
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : Color
			{
				float u0 = i.uv.x * 2 - 1;
				float v0 = i.uv.y * 2 - 1;

				v0 = v0 * abs(u0);
				v0 = (v0 + 1) * 0.5;
				float2 newCoords = float2(i.uv.x, v0);


				half horizontal = tex2D(_MainTex, newCoords).r < 0.9 ? length(newCoords - 0.5) : 1;
				half vertical = tex2D(_MainTex, newCoords.yx).r < 0.9 ? length(newCoords - 0.5) : 1;
				return half4(horizontal, vertical, 0, 1);

			}
			ENDCG
		}
        
    }
}
