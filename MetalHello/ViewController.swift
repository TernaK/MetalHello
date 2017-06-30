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
  var pipeline_state: MTLRenderPipelineState!
  
  var vertex_buffer: MTLBuffer!
  let vertex_data:[Float] = [
    -1,-1,0, 1,-1,0, 0,1,0
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
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
    pipeline_state_descriptor.vertexFunction = vertex_shader
    pipeline_state_descriptor.fragmentFunction = fragment_shader
    pipeline_state_descriptor.colorAttachments[0].pixelFormat = metal_layer.pixelFormat
    
    pipeline_state = try! metal_device.makeRenderPipelineState(descriptor: pipeline_state_descriptor)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

