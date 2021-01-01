Shader "Custom/DiffuseShader"
{
    Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        _DiffuseTex("Texture", 2D) = "white" {}
        _Ambient("Ambient", Range(0, 1)) = 0.25
    }
    SubShader
    {
        //태그
        Tags { "LightMode" = "ForwardBase" }

        // 렌더링 정보, 계산 코드 포함
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc" 
            
            // 정점 셰이더는 해당 구조체(입력 구조체)를 통해 특정 정보를 요청할 수 있음
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            // 해당 구조체를 통해 정점 셰이더는 프레그먼트 셰이더로 정보를 전달
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
                float2 uv : TEXCOORD0;
            };

            fixed4 _Color;
            sampler2D _DiffuseTex;
            float4 _DiffuseTex_ST;
            float _Ambient;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = worldNormal;
                o.uv = TRANSFORM_TEX(v.uv, _DiffuseTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normalDirection = normalize(i.worldNormal);

                float4 tex = tex2D(_DiffuseTex, i.uv);

                float nl = max(_Ambient, dot(normalDirection, _WorldSpaceLightPos0.xyz));
                float4 diffuseTerm = nl * _Color * tex * _LightColor0;

                return diffuseTerm;
            }
            ENDCG
        }
    }
}
