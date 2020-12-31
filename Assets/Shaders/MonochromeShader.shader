Shader "Unlit/MonochromeShader"
{
    Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
    }
    SubShader
    {
        //태그
        Tags { "RenderType"="Opaque" }

        // 렌더링 정보, 계산 코드 포함
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            // 정점 셰이더는 해당 구조체(입력 구조체)를 통해 특정 정보를 요청할 수 있음
            struct appdata
            {
                float4 vertex : POSITION;
            };

            // 해당 구조체를 통해 정점 셰이더는 프레그먼트 셰이더로 정보를 전달
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
