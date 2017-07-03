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

struct VertexDataOut {
  float4 position [[position]];
  float2 tex_coord;
};

struct VertexDataIn {
  packed_float3 position;
  packed_float2 tex_coord;
};

vertex VertexDataOut vert_tex_shader(constant VertexDataIn *vert_in [[buffer(0)]],
                                     uint v_id [[vertex_id]]) {
  VertexDataOut vert_out;
  vert_out.position = float4(vert_in[v_id].position, 1.0);
  vert_out.tex_coord = vert_in[v_id].tex_coord;
  return vert_out;
}

constexpr constant sampler tex_sampler(mag_filter::linear, min_filter::linear);

fragment float4 frag_tex_shader(VertexDataOut frag_in [[stage_in]],
                                texture2d<half> tex_in [[texture(0)]]) {
  return float4(tex_in.sample(tex_sampler, frag_in.tex_coord));
}
