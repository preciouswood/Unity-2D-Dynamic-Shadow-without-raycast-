Shader "Unlit/GetMinDistanceShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TextureSizeCountDown ("Texture Size Count Down" , Float) = 0
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
			float _TextureSizeCountDown;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

			fixed4 frag (float2 uv : TEXCOORD0) : Color
            {
				float4 color = tex2D(_MainTex, uv);

				float nearPixelOffset = uv.x;

				float4 nearColor = tex2D(_MainTex, uv - float2(_TextureSizeCountDown, 0) );
				float4 result = min(color, nearColor);
				return float4(result.xy, 0, 1);

            }
            ENDCG
        }
    }
}
