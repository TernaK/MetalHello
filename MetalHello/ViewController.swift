//
//  ViewController.swift
//  MetalHello
//
//  Created by Terna Kpamber on 6/30/17.
//  Copyright © 2017 Terna Kpamber. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
  
  var metal_device: MTLDevice!
  var metal_layer: CAMetalLayer!
  var command_queue: MTLCommandQueue!
  var pipeline_state: MTLRenderPipelineState!
  
  var vertex_buffer: MTLBuffer!
  let vertex_data:[Float] = [
    -1,-1,0, 1,-1,0, 0,1,0
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let x = Compute(with_data: [6, 2, 3, 4, 7, 1, 9, 11])
    // Do any additional setup after loading the view, typically from a nib.
    /*
    metal_device = MTLCreateSystemDefaultDevice()
    metal_layer = CAMetalLayer()
    metal_layer.device = metal_device
    metal_layer.framebufferOnly = true
    metal_layer.pixelFormat = .bgra8Unorm
    metal_layer.frame = view.layer.frame
    view.layer.addSublayer(metal_layer)
    
    // vertex data
    let buffer_length = vertex_data.count * MemoryLayout.size(ofValue: vertex_data[0])
    vertex_buffer = metal_device.makeBuffer(bytes: vertex_data, length: buffer_length, options: [])
    
    // shaders
    let metal_library = metal_device.makeDefaultLibrary()
    let vertex_shader = metal_library?.makeFunction(name: "vertex_shader")
    let fragment_shader = metal_library?.makeFunction(name: "fragment_shader")
    
    let pipeline_state_descriptor = MTLRenderPipelineDescriptor()
    pipeline_state_descriptor.label = "render_pipeline"
    pipeline_state_descriptor.vertexFunction = vertex_shader
    pipeline_state_descriptor.fragmentFunction = fragment_shader
    pipeline_state_descriptor.colorAttachments[0].pixelFormat = metal_layer.pixelFormat
    
    pipeline_state = try? metal_device.makeRenderPipelineState(descriptor: pipeline_state_descriptor)
    if pipeline_state == nil {
      print("could not setup pipeline")
    }
    
    command_queue = metal_device.makeCommandQueue()
    
    render()
//    let timer = CADisplayLink(target: self, selector: #selector(render))
//    timer.add(to: .main, forMode: .defaultRunLoopMode)
 */
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @objc func render() {
    let drawable = metal_layer.nextDrawable()
    let render_pass_descriptor = MTLRenderPassDescriptor()
    render_pass_descriptor.colorAttachments[0].texture = drawable?.texture
    render_pass_descriptor.colorAttachments[0].clearColor = .init(red: 0.7, green: 0.1, blue: 0.6, alpha: 1.0);
    render_pass_descriptor.colorAttachments[0].loadAction = .clear
    
    let command_buffer = command_queue.makeCommandBuffer()
    let command_encoder = command_buffer?.makeRenderCommandEncoder(descriptor: render_pass_descriptor)
    command_encoder?.setRenderPipelineState(pipeline_state)
    command_encoder?.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
    command_encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
    command_encoder?.endEncoding()
    
    command_buffer?.present(drawable!)
    
    command_buffer?.commit()
  }
  
}

