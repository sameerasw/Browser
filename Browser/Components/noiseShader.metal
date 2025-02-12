//
//  noiseShader.metal
//  Browser
//
//  Created by Leonardo Larrañaga on 2/11/25.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 noiseShader(float2 position, half4 color, float2 size, float time) {
    float2 pos = position / size;
    float noise = fract(sin(dot(pos, float2(12.9898, 78.233))) * 4378.5453);
    return half4(half3(noise), color.a);
}
