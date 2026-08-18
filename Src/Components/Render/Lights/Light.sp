package RenderComponents

import Math
import Common

state LightData
{
    color := Color(1.0, 1.0, 1.0, 0.0),
    temperature := float32(6500.0),
    intensity := float32(10.0),

    castShadow := true
}

Vec3 LightData::TemperatureToRGB()
{
    rgb := Vec3();

    temperature := Math.FClamp(this.temperature, 1000.0, 40000.0) / 100.0;

    if (temperature <= 66.0)
    {
        rgb.x = 1.0;
        rgb.y = Math.FClamp(
            0.39008157876901960784 * Math.Logf(temperature) - 0.63184144378862745098, 
            0.0, 
            1.0
        );
    }
    else
    {
        tempTempature := temperature - 60.0;
        rgb.x = Math.FClamp(
            1.29293618606274509804 * Math.Powf(tempTempature, -0.1332047592), 
            0.0, 
            1.0
        );
        rgb.y = Math.FClamp(
            1.12989086089529411765 * Math.Powf(tempTempature, -0.0755148492),
            0.0, 
            1.0 
        );
    }

    if (temperature >= 66.0)
    {
        rgb.z = 1.0;
    }
    else if (temperature <= 19.0)
    {
        rgb.z = 0.0;
    }
    else
    {
        rgb.z = Math.FClamp(
            0.54320678911019607843 * Math.Logf(temperature - 10.0) - 1.19625408914, 
            0.0,
            1.0
        );
    }

    return rgb;
}

Vec3 LightData::GetRadiance()
{
    temp := this.TemperatureToRGB();

    rgb := Vec3();
    rgb.x = this.color.r * temp.x;
    rgb.y = this.color.g * temp.y;
    rgb.z = this.color.b * temp.z;

    // luma := 0.2126 * rgb.x + 0.7152 * rgb.y + 0.0722 * rgb.z;
    // rgb.x /= luma;
    // rgb.y /= luma;
    // rgb.z /= luma;

    return rgb;
}