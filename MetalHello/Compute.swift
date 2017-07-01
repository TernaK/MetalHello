//
//  Compute.swift
//  MetalHello
//
//  Created by Terna Kpamber on 6/30/17.
//  Copyright © 2017 Terna Kpamber. All rights reserved.
//

import MetalKit
import Metal

class Compute {
  
  var metal_device: MTLDevice!
  var pipeline_state: MTLComputePipelineState!
  var buffer_in: MTLBuffer!
  var buffer_out: MTLBuffer!
  
  init(with_data data_in: [Float]) {
    metal_device = MTLCreateSystemDefaultDevice()
    
    let metal_library = metal_device.makeDefaultLibrary()
    let kernel_function = metal_library?.makeFunction(name: "power2_kernel")
    
    pipeline_state = try! metal_device.makeComputePipelineState(function: kernel_function!)
    
    let buffer_byte_length = data_in.count * MemoryLayout.size(ofValue: data_in[0])
    buffer_in = metal_device.makeBuffer(bytes: data_in, length: buffer_byte_length, options: [])
    buffer_out = metal_device.makeBuffer(length: buffer_byte_length, options: [])
    
    let command_queue = metal_device.makeCommandQueue()
    let command_buffer = command_queue?.makeCommandBuffer()
    let command_encoder = command_buffer?.makeComputeCommandEncoder()
    command_encoder?.setComputePipelineState(pipeline_state)
    command_encoder?.setBuffer(buffer_in, offset: 0, index: 0)
    command_encoder?.setBuffer(buffer_out, offset: 0, index: 1)
    var data_count:UInt32 = UInt32(data_in.count)
    command_encoder?.setBytes(&data_count, length: MemoryLayout<UInt32>.size, index: 2)
    
    let thread_group_size = MTLSize(width: 4, height: 1, depth: 1)
    let thread_group_count = MTLSize(width: Int(ceil(Float(data_in.count) / Float(thread_group_size.width))), height: 1, depth: 1)
    
    command_encoder?.dispatchThreadgroups(thread_group_count, threadsPerThreadgroup: thread_group_size)
    
    command_encoder?.endEncoding()
    command_buffer?.commit()
    
    command_buffer?.waitUntilCompleted()
    
    let data = NSData(bytesNoCopy: buffer_out.contents(), length: buffer_out.length, freeWhenDone: false)
    var data_out = [Float](repeatElement(0, count: data_in.count))
    data.getBytes(&data_out, length: buffer_out.length)
    print(data_out)
  }
}
