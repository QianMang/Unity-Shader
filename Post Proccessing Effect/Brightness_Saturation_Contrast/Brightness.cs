﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//BrightnessSaturationAndContrast

public class Brightness : PostEffectsBase {
    public Shader briSatConShader;
    private Material briSatConMaterial;
    public Material material{
        get{
            briSatConMaterial = CheckShaderAndCreateMaterial(briSatConShader, briSatConMaterial);
            return briSatConMaterial;
        }
    }

    [Range(0.0f, 3.0f)]
    public float brightness = 1.0f;

    //饱和度
    [Range(0.0f, 3.0f)]
    public float saturation = 1.0f;

    [Range(0.0f, 3.0f)]
    public float contrast = 1.0f;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(material!=null){
            print("123");
            material.SetFloat("_Brightness", brightness);
            material.SetFloat("_Saturation", saturation);
            material.SetFloat("_Contrast", contrast);

            Graphics.Blit(source, destination, material);
        }else{
            Graphics.Blit(source, destination);
        }
    }
}
