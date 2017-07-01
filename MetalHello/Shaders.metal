//
//  Shaders.metal
//  MetalHello
//
//  Created by Terna Kpamber on 6/30/17.
//  Copyright © 2017 Terna Kpamber. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


vertex float4 vertex_shader(const device packed_float3* vertices [[buffer(0)]],
                            unsigned int v_id [[vertex_id]]) {
  return float4(vertices[v_id], 1.0);
}

fragment float4 fragment_shader() {
  return float4(0.4, 0.6, 0.1, 1.0);
}

kernel void power2_kernel(constant float *_A [[buffer(0)]],
                          device float *_B [[buffer(1)]],
                          constant uint *N [[buffer(2)]],
                          uint tid [[thread_position_in_grid]]) {
  if(tid < *N)
  	_B[tid] = _A[tid] * _A[tid];
}

