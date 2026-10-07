Shader "Custom/PlayerShader"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1) // Base color of the object
        _MainTex ("Base Texture", 2D) = "white" {} // Texture map
    }
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipeline" "RenderType" = "Opaque" }

        Pass
        {
        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        struct Attributes
        {
            float4 positionOS : POSITION; // Object space position
            float3 normalOS : NORMAL; // Object space normal
            float2 uv : TEXCOORD0; // Texture UV
        };

        struct Varyings
        {
            float4 positionHCS : SV_POSITION; // Homogeneous clip-space position
            float3 normalWS : TEXCOORD1; // World space normal
            float2 uv : TEXCOORD0; // UV for texturing
        };

        // Declare the base texture and sampler
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseColor; 
        CBUFFER_END

        // Vertex Shader
        Varyings vert(Attributes IN)
        {
            Varyings OUT;
            OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
            OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));
            OUT.uv = IN.uv;
            return OUT;
        }
        
        half4 frag(Varyings IN) : SV_Target
        {
            
            half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
            
            Light mainLight = GetMainLight();
            half3 lightDir = normalize(mainLight.direction);

            half3 normalWS = normalize(IN.normalWS);
            half NdotL = saturate(dot(normalWS, lightDir));
            half3 ambientSH = SampleSH(normalWS);
            half3 diffuse = texColor.rgb * _BaseColor.rgb * NdotL;
            
            half3 finalColor = diffuse + ambientSH * texColor.rgb * _BaseColor.rgb;
            
            return half4(finalColor, 1.0);
        }
        ENDHLSL
        }
    }
}
