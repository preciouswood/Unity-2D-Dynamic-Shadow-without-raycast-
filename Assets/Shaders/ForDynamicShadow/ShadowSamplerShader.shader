Shader "Unlit/ShadowSamplerShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

			float GetShadowDistanceH(float2 TexCoord)
			{
				half u = TexCoord.x;
				half v = TexCoord.y;

				u = abs(u - 0.5) * 2;
				v = v * 2 - 1;
				half v0 = v / u;
				v0 = (v0 + 1) * 0.5;

				half2 newCoords = half2(TexCoord.x, v0);
				//horizontal info was stored in the Red component
				return tex2D(_MainTex, newCoords).r;
			}
			float GetShadowDistanceV(float2 TexCoord)
			{
				half u = TexCoord.y;
				half v = TexCoord.x;

				u = abs(u - 0.5f) * 2;
				v = v * 2 - 1;
				half v0 = v / u;
				v0 = (v0 + 1) * 0.5;

				half2 newCoords = half2(TexCoord.y, v0);
				//vertical info was stored in the Green component
				return tex2D(_MainTex, newCoords).g;
			}

            fixed4 frag (v2f i) : Color
            {
				// distance of this pixel from the center
				half distance = length(i.uv - 0.5f);
				//distance *= 128;

				//apply a 2-pixel bias
				distance -= 0.0025;

				//distance stored in the shadow map
				half shadowMapDistance;
				//coords in [-1,1]
				half nY = (i.uv.y - 0.5f);
				half nX = (i.uv.x - 0.5f);

				//we use these to determine which quadrant we are in
				if (abs(nY) < abs(nX))
				{
					shadowMapDistance = GetShadowDistanceH(i.uv);
				}
				else
				{
					shadowMapDistance = GetShadowDistanceV(i.uv);
				}

				//if distance to this pixel is lower than distance from shadowMap,
				//then we are not in shadow
				half light = distance < shadowMapDistance ? 1 : 0;
				half4 result = light;
				return result;
            }
            ENDCG
        }
    }
}
