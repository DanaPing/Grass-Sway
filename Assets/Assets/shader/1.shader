Shader "Custom/1"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
//parameters
        _WindFrequency("Wind Frequency", Range(0.01,100)) = 1
       _WindStrength("Wind Strength", Range(0,2)) = 0.3
        _WindGust("Distance Between Gusts", Range(0.01,50)) = 0.25
     _WindDirection("Wind Direction", vector) = (1,0,1,0)
        
    }
    SubShader
    {
        Tags { "Queue"="Transparent"
        "Render Type" = "TransparentCutout"//assign grass texture on planes
         }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        //#pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        half _WindFrequency;
        half _WindGust;
        half _WindStrength;
        float3 _WindDirection;

        void vert(inout appdata_full v)
        {
            float4 localSpaceVertex = v.vertex;
            float4 worldSpaceVertex = mul(unity_ObjectToWorld, localSpaceVertex);

            float height = (localSpaceVertex.y/2 + 0.5);
//grass swing horizontally, x-coordinate and z-coordinate.
            worldSpaceVertex.x += sin(_Time.x* _WindFrequency + worldSpaceVertex.x* _WindGust)*height*_WindStrength*_WindDirection.x;
        worldSpaceVertex.z += sin(_Time.x* _WindFrequency + worldSpaceVertex.z* _WindGust)*height*_WindStrength*_WindDirection.z;
        
        v.vertex = mul( unity_WorldToObject, worldSpaceVertex);


        }



        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
